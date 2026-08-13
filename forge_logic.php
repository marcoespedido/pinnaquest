<?php
session_start();
// Sa loob ng forge_logic.php

if (isset($_POST['timer_mins'])) {
    $_SESSION['quiz_time_limit'] = intval($_POST['timer_mins']);
}
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    unset($_SESSION['solo_retake_of'], $_SESSION['solo_result_saved'], $_SESSION['solo_result_response']);
    $title = $_POST['quest_title'] ?? "Untitled Quest";
    $filePath = $_POST['source_material'] ?? "";
    $difficulty = $_POST['difficulty'] ?? "easy";
    $quiz_type = $_POST['quiz_type'] ?? "multiple_choice";
    $item_count = (int)($_POST['item_count'] ?? 10);
    $timer = (int)($_POST['timer_mins'] ?? 0);

    if (empty($filePath) || !file_exists($filePath)) {
        die("Error: File not found at " . htmlspecialchars($filePath));
    }

    $pythonPath = '"C:\Users\DREAM PC\AppData\Local\Programs\Python\Python311\python.exe"';
    $escapedPath = escapeshellarg($filePath);
    
    // Command with all arguments
    $command = "chcp 65001 && $pythonPath engine.py $escapedPath \"$difficulty\" \"$quiz_type\" $item_count 2>&1";
    $output = shell_exec($command);

    // BOMB-PROOF JSON EXTRACTION
    $jsonStart = strpos($output, '{');
    $jsonEnd = strrpos($output, '}');
    $data = null;

    if ($jsonStart !== false && $jsonEnd !== false) {
        $jsonOnly = substr($output, $jsonStart, ($jsonEnd - $jsonStart) + 1);
        $data = json_decode($jsonOnly, true);
    }

    if ($data && !isset($data['error'])) {
        // Save to Session
        $_SESSION['summary'] = [
            'overview' => $data['overview'] ?? "No overview generated.",
            'key_terminologies' => $data['key_terminologies'] ?? [],
            'main_study_points' => $data['main_study_points'] ?? []
        ];
        
        // Ito ang critical fix para sa quiz.php
        $quiz_questions = $data['quiz'] ?? [];
        $_SESSION['questions'] = $quiz_questions; 
        unset($_SESSION['solo_quiz_order_initialized']);
        
        $_SESSION['quiz_data'] = [
            'questions' => $quiz_questions,
            'type' => $quiz_type,
            'difficulty' => $difficulty,
            'timer' => $timer,
            'title' => $title
        ];
        $_SESSION['solo_attempt_token'] = bin2hex(random_bytes(16));

        $_SESSION['title'] = $title;
        header("Location: pre_quiz_summary.php");
        exit();
    
    } else {
        echo "<h3>Forge Error:</h3><pre>" . htmlspecialchars($output) . "</pre>";
    }
}
?>