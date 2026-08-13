<?php
// save_quiz_result.php
// Called by quiz.php JS when the quiz ends (and, harmlessly, by the other
// solo game modes too — they just won't send a quiz_log, which is fine).
// Awards XP, saves result, checks + unlocks achievements, and — new —
// logs the student's name plus a per-question answer record for test-case
// / reporting purposes.

header('Content-Type: application/json');
session_start();
require_once __DIR__ . '/xp_policy.php';

if (!isset($_SESSION['user_id'])) {
    echo json_encode(['success' => false]);
    exit();
}

// Browser retries, double-clicks, and refreshes must not create another XP
// award for the same completed attempt.
if (!empty($_SESSION['solo_result_saved']) && isset($_SESSION['solo_result_response'])) {
    echo json_encode($_SESSION['solo_result_response']);
    exit();
}

$conn    = new mysqli("localhost", "root", "", "pinnaquest_db");
$user_id = intval($_SESSION['user_id']);

$score           = intval($_POST['score']            ?? 0);
$correct_answers = intval($_POST['correct_answers']  ?? 0);
$total_questions = intval($_POST['total_questions']  ?? 1);
$quiz_title      = $conn->real_escape_string($_SESSION['quiz_data']['title'] ?? 'Solo Quiz');
$questions       = $_SESSION['quiz_data']['questions'] ?? [];
$quiz_key        = quizQuestionsKey(is_array($questions) ? $questions : []);
$quiz_key_sql    = $conn->real_escape_string($quiz_key);
$is_retake       = !empty($_SESSION['solo_retake_of']) ? 1 : 0;
$retake_of       = intval($_SESSION['solo_retake_of'] ?? 0);

ensureQuizXpSchema($conn);

// ── Resolve the student's display name (for the test-case record) ──────
$student_name = 'Student';
$name_res = $conn->query("SELECT COALESCE(display_name, full_name) AS name FROM users WHERE id = $user_id");
if ($name_res && $name_res->num_rows > 0) {
    $name_row = $name_res->fetch_assoc();
    if (!empty($name_row['name'])) $student_name = $name_row['name'];
}
$student_name_safe = $conn->real_escape_string($student_name);

// ── XP formula for solo quizzes ───────────────────────────────────
$perfect_xp = soloPerfectXp($total_questions);
$attempt_xp = soloAttemptXp($correct_answers, $total_questions);
$is_perfect = ($total_questions > 0 && $correct_answers >= $total_questions);
$requested_xp = $attempt_xp;

if ($is_retake) {
    $previousEligible = soloEligibleXpBefore($conn, $user_id, $quiz_key, $retake_of);
    // A perfect attempt is recorded normally but never pays additional XP.
    // A non-perfect retake receives the remaining XP gap to the perfect-run
    // value. This is intentionally not recalculated from the retake score.
    $requested_xp = $is_perfect
        ? 0
        : max(0, $perfect_xp - $previousEligible);
}

// ── Save result ───────────────────────────────────────────────────
$conn->query(
    "INSERT INTO solo_quiz_results
        (user_id, student_name, quiz_title, score, correct_answers, total_questions,
         xp_earned, quiz_key, perfect_xp, is_retake, retake_of)
     VALUES 
        ($user_id, '$student_name_safe', '$quiz_title', $score, $correct_answers, $total_questions,
         0, '$quiz_key_sql', $perfect_xp, $is_retake, " . ($retake_of > 0 ? $retake_of : 'NULL') . ")"
);
$result_id = $conn->insert_id;
unset($_SESSION['solo_quiz_order_initialized']);

// ── Save per-question answer log (quiz.php only sends this) ───────────
// quiz_log is a JSON array of:
//   { q, type, options, correct_answer, user_answer, is_correct }
// user_answer can be null if the student ran out of time / skipped.
$quiz_log_raw = $_POST['quiz_log'] ?? '[]';
$quiz_log     = json_decode($quiz_log_raw, true);

if ($result_id && is_array($quiz_log) && count($quiz_log) > 0) {
    $qnum = 0;
    foreach ($quiz_log as $entry) {
        if (!is_array($entry)) continue;
        $qnum++;

        $q_text    = $conn->real_escape_string((string)($entry['q'] ?? ''));
        $q_type    = $conn->real_escape_string((string)($entry['type'] ?? 'multiple_choice'));

        $opts_arr  = (isset($entry['options']) && is_array($entry['options'])) ? $entry['options'] : [];
        $opts_json = $conn->real_escape_string(json_encode($opts_arr, JSON_UNESCAPED_UNICODE));

        $correct_ans = $conn->real_escape_string((string)($entry['correct_answer'] ?? ''));

        $user_ans_raw = $entry['user_answer'] ?? null;
        $user_ans_sql = ($user_ans_raw === null || $user_ans_raw === '')
            ? 'NULL'
            : "'" . $conn->real_escape_string((string)$user_ans_raw) . "'";

        $is_corr = !empty($entry['is_correct']) ? 1 : 0;

        $conn->query(
            "INSERT INTO solo_quiz_answers
                (result_id, question_number, question_text, question_type, options, correct_answer, user_answer, is_correct)
             VALUES
                ($result_id, $qnum, '$q_text', '$q_type', '$opts_json', '$correct_ans', $user_ans_sql, $is_corr)"
        );
    }
}

// ── Apply shared daily cap and duplicate protection ────────────────
$xp_earned = awardQuizXp($conn, $user_id, 'solo', $quiz_key, $result_id, $requested_xp);
$conn->query("UPDATE solo_quiz_results SET xp_earned = $xp_earned WHERE id = $result_id AND user_id = $user_id");

// ── Check and award achievements ──────────────────────────────────
checkAndAwardAchievements($conn, $user_id);

// ── Return new XP totals ──────────────────────────────────────────
$totals = quizXpTotals($conn, $user_id);

$response = [
    'success'      => true,
    'xp_earned'    => $xp_earned,
    'total_xp'     => $totals['total_xp'],
    'level'        => $totals['level'],
    'progress_pct' => $totals['progress_pct'],
    'result_id'    => $result_id,
];
$_SESSION['solo_result_saved'] = true;
$_SESSION['solo_result_response'] = $response;
unset($_SESSION['solo_retake_of']);
echo json_encode($response);

$conn->close();

// ── HELPER ────────────────────────────────────────────────────────
function checkAndAwardAchievements($conn, $user_id) {
    // ── Gather stats ──────────────────────────────────────────────
    // Solo quizzes
    $sq = $conn->query(
        "SELECT COUNT(*) as cnt, 
                COALESCE(SUM(correct_answers),0) as correct,
                MAX(CASE WHEN correct_answers = total_questions AND total_questions > 0 THEN 1 ELSE 0 END) as has_perfect
         FROM solo_quiz_results WHERE user_id = $user_id"
    )->fetch_assoc();

    // Synchro participation (match by user's display name or full name)
    $name_res = $conn->query("SELECT COALESCE(display_name, full_name) as name FROM users WHERE id = $user_id");
    $name     = $name_res->fetch_assoc()['name'] ?? '';
    $name_esc = $conn->real_escape_string($name);

    $sy_cnt = 0; $sy_correct = 0; $sy_max_streak = 0;
    if ($name) {
        $sy = $conn->query(
            "SELECT COUNT(DISTINCT session_id) as sessions,
                    COALESCE(SUM(correct_answers),0) as correct,
                    COALESCE(MAX(streak),0) as max_streak
             FROM synchro_scores WHERE nickname = '$name_esc'"
        )->fetch_assoc();
        $sy_cnt        = intval($sy['sessions']   ?? 0);
        $sy_correct    = intval($sy['correct']    ?? 0);
        $sy_max_streak = intval($sy['max_streak'] ?? 0);
    }

    $total_correct = intval($sq['correct'] ?? 0) + $sy_correct;

    // XP and level
    $xp_res = $conn->query("SELECT xp FROM users WHERE id = $user_id")->fetch_assoc();
    $xp     = intval($xp_res['xp'] ?? 0);
    $level  = max(1, floor($xp / 300) + 1);

    // ── Define unlock conditions ──────────────────────────────────
    $to_unlock = [];
    if (intval($sq['cnt'])        >= 1)  $to_unlock[] = 'first_quest';
    if ($sy_cnt                   >= 1)  $to_unlock[] = 'synchro_debut';
    if ($total_correct            >= 10) $to_unlock[] = 'sharp_shooter';
    if ($total_correct            >= 50) $to_unlock[] = 'centurion';
    if ($xp                       >= 500)$to_unlock[] = 'xp_warrior';
    if ($sy_max_streak            >= 5)  $to_unlock[] = 'streak_master';
    if ($level                    >= 5)  $to_unlock[] = 'legend';
    if (intval($sq['has_perfect'] ?? 0)) $to_unlock[] = 'perfect_run';

    foreach ($to_unlock as $key) {
        $k = $conn->real_escape_string($key);
        $conn->query(
            "INSERT IGNORE INTO user_achievements (user_id, achievement_key)
             VALUES ($user_id, '$k')"
        );
    }
}
?>