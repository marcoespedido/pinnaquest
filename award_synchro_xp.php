<?php
// award_synchro_xp.php
// Called by student_quiz_game.php when the quiz ends.
// Finds the student's synchro score and awards proportional XP.

header('Content-Type: application/json');
session_start();
require_once __DIR__ . '/xp_policy.php';

if (!isset($_SESSION['user_id'])) {
    echo json_encode(['success' => false]);
    exit();
}

$conn       = new mysqli("localhost", "root", "", "pinnaquest_db");
$user_id    = intval($_SESSION['user_id']);
$session_id = intval($_POST['session_id'] ?? 0);
$nickname   = $conn->real_escape_string(trim($_POST['nickname'] ?? ''));

if (!$session_id || !$nickname) {
    echo json_encode(['success' => false, 'error' => 'Missing fields']);
    exit();
}

// ── Get this student's synchro score ─────────────────────────────
$score_res = $conn->query(
    "SELECT total_score, correct_answers, streak 
     FROM synchro_scores 
     WHERE session_id = $session_id AND nickname = '$nickname'"
);

if (!$score_res || $score_res->num_rows === 0) {
    echo json_encode(['success' => false, 'error' => 'Score not found']);
    exit();
}
$s = $score_res->fetch_assoc();

// ── XP formula for synchro ────────────────────────────────────────
// 15 XP per correct answer + participation bonus of 30
$xp_earned = (intval($s['correct_answers']) * 15) + 30;
// Streak bonus: 5 XP per streak point (max 50)
$xp_earned += min(50, intval($s['streak']) * 5);

// One completed session is one independent XP attempt. The shared ledger
// applies the 300 daily cap and blocks duplicate finish/reconnect requests.
$xp_earned = awardQuizXp($conn, $user_id, 'synchro', 'session:' . $session_id, $session_id, $xp_earned);

// ── Check achievements ─────────────────────────────────────────────
awardAchievementsForUser($conn, $user_id);

// ── Return new totals ─────────────────────────────────────────────
$totals = quizXpTotals($conn, $user_id);

echo json_encode([
    'success'      => true,
    'xp_earned'    => $xp_earned,
    'total_xp'     => $totals['total_xp'],
    'level'        => $totals['level'],
    'progress_pct' => $totals['progress_pct'],
]);

$conn->close();

// ── Local achievement helper (mirrors save_quiz_result.php) ───────
function awardAchievementsForUser($conn, $user_id) {
    $sq = $conn->query(
        "SELECT COUNT(*) as cnt, COALESCE(SUM(correct_answers),0) as correct,
                MAX(CASE WHEN correct_answers=total_questions AND total_questions>0 THEN 1 ELSE 0 END) as has_perfect
         FROM solo_quiz_results WHERE user_id=$user_id"
    )->fetch_assoc();

    $name_esc = '';
    $nr = $conn->query("SELECT COALESCE(display_name,full_name) as n FROM users WHERE id=$user_id");
    if ($nr) { $row = $nr->fetch_assoc(); $name_esc = $conn->real_escape_string($row['n'] ?? ''); }

    $sy_cnt=0; $sy_correct=0; $sy_max_streak=0;
    if ($name_esc) {
        $sy = $conn->query("SELECT COUNT(DISTINCT session_id) as s, COALESCE(SUM(correct_answers),0) as c, COALESCE(MAX(streak),0) as ms FROM synchro_scores WHERE nickname='$name_esc'")->fetch_assoc();
        $sy_cnt=$sy['s']; $sy_correct=$sy['c']; $sy_max_streak=$sy['ms'];
    }
    $total_correct = intval($sq['correct']) + intval($sy_correct);
    $xp    = intval($conn->query("SELECT xp FROM users WHERE id=$user_id")->fetch_assoc()['xp'] ?? 0);
    $level = max(1, floor($xp/300)+1);

    $map = [
        'first_quest'   => intval($sq['cnt'])        >= 1,
        'synchro_debut' => intval($sy_cnt)            >= 1,
        'sharp_shooter' => $total_correct             >= 10,
        'centurion'     => $total_correct             >= 50,
        'xp_warrior'    => $xp                        >= 500,
        'streak_master' => intval($sy_max_streak)     >= 5,
        'legend'        => $level                     >= 5,
        'perfect_run'   => intval($sq['has_perfect']??0) >= 1,
    ];
    foreach ($map as $key => $earned) {
        if ($earned) {
            $k = $conn->real_escape_string($key);
            $conn->query("INSERT IGNORE INTO user_achievements (user_id, achievement_key) VALUES ($user_id,'$k')");
        }
    }
}
?>