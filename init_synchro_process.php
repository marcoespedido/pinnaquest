<?php

session_start();

$conn = new mysqli("localhost", "root", "", "pinnaquest_db");
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $title = mysqli_real_escape_string($conn, $_POST['quest_title']);
    $material_id = intval($_POST['source_material']);
    $difficulty = mysqli_real_escape_string($conn, $_POST['difficulty']);
    $quiz_type = mysqli_real_escape_string($conn, $_POST['quiz_type']);
    $item_count = intval($_POST['item_count']);
    $timer = intval($_POST['timer_mins']);

    // Get the file path of the selected material
    $mat_res = $conn->query("SELECT file_path FROM teacher_materials WHERE id = $material_id");
    if (!$mat_res || $mat_res->num_rows === 0) {
        die("Error: Material not found in database.");
    }
    $material = $mat_res->fetch_assoc();
    $file_path = $material['file_path'];

    if (!file_exists($file_path)) {
        die("Error: Material file not found on server at: " . htmlspecialchars($file_path));
    }

    // Generate Room Code
    $room_code = "PQ-" . str_pad(rand(0, 999999), 6, '0', STR_PAD_LEFT);

    // Insert the session into DB
    $sql = "INSERT INTO synchro_sessions (room_code, title, material_id, difficulty, quiz_type, item_count, timer_mins, status, created_at) 
            VALUES ('$room_code', '$title', '$material_id', '$difficulty', '$quiz_type', '$item_count', '$timer', 'waiting', NOW())";

    if (!$conn->query($sql)) {
        die("Database Error: " . $conn->error);
    }
    $session_id = $conn->insert_id;

    $pythonPath = '"C:\Users\DREAM PC\AppData\Local\Programs\Python\Python311\python.exe"';
    $escapedPath = escapeshellarg($file_path);
    $command = "chcp 65001 && $pythonPath engine.py $escapedPath \"$difficulty\" \"$quiz_type\" $item_count 2>&1";
    $output = shell_exec($command);

    // Extract JSON from output
    $jsonStart = strpos($output, '{');
    $jsonEnd = strrpos($output, '}');
    $data = null;

    if ($jsonStart !== false && $jsonEnd !== false) {
        $jsonOnly = substr($output, $jsonStart, ($jsonEnd - $jsonStart) + 1);
        $data = json_decode($jsonOnly, true);
    }

    if ($data && !isset($data['error']) && isset($data['quiz'])) {
        // Save questions to synchro_questions table
        $questions = $data['quiz'];
        shuffle($questions);
        $order = 0;
        foreach ($questions as $q) {
            $order++;
            $question_text = $conn->real_escape_string($q['question'] ?? '');
            $q_type = (strpos($quiz_type, 'identif') !== false) ? 'identification' : 'multiple_choice';

            if ($q_type === 'multiple_choice') {
                $options = $q['options'] ?? ['', '', '', ''];
                $opt_a = $conn->real_escape_string($options[0] ?? '');
                $opt_b = $conn->real_escape_string($options[1] ?? '');
                $opt_c = $conn->real_escape_string($options[2] ?? '');
                $opt_d = $conn->real_escape_string($options[3] ?? '');
                $answer_index = intval($q['answer_index'] ?? 0);
                $letters = ['A', 'B', 'C', 'D'];
                $correct_answer = $conn->real_escape_string($letters[$answer_index] ?? 'A');
                $time_lim = 20;

                $q_sql = "INSERT INTO synchro_questions 
                    (session_id, question_order, question_text, option_a, option_b, option_c, option_d, correct_answer, question_type, time_limit) 
                    VALUES ($session_id, $order, '$question_text', '$opt_a', '$opt_b', '$opt_c', '$opt_d', '$correct_answer', 'multiple_choice', $time_lim)";
            } else {
                // Identification — fill in the blank style
                $correct_answer = $conn->real_escape_string($q['answer'] ?? '');
                // Clean question text (remove ____ for display, keep it as the question)
                $q_sql = "INSERT INTO synchro_questions 
                    (session_id, question_order, question_text, option_a, option_b, option_c, option_d, correct_answer, question_type, time_limit) 
                    VALUES ($session_id, $order, '$question_text', '', '', '', '', '$correct_answer', 'identification', 30)";
            }
            $conn->query($q_sql);
        }

        // Initialize game state
        $conn->query("INSERT INTO synchro_game_state (session_id, current_question, phase) VALUES ($session_id, 0, 'lobby') ON DUPLICATE KEY UPDATE phase='lobby', current_question=0");

    } else {
        // AI failed - use fallback: log error but still go to lobby
        // Teacher can try again or the questions table will just be empty
        error_log("PinnaQuest: Python Engine failed for session $session_id. Output: " . substr($output, 0, 500));
    }

    // Save session info and redirect to lobby
    $_SESSION['active_room_code'] = $room_code;
    header("Location: teacher_lobby.php?room=$room_code");
    exit();
}
?>