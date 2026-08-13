<?php
// process_join.php - FIXED
// Only validates the room code and sets session vars.
// Participant nickname/avatar is chosen INSIDE student_waiting_room.php
// and saved via add_participant.php — NOT here.
session_start();
$conn = new mysqli("localhost", "root", "", "pinnaquest_db");
 
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $room_code = strtoupper(trim(mysqli_real_escape_string($conn, $_POST['room_code'])));
 
    // Accept rooms that are still waiting OR already started (late joiners)
    $check_room = $conn->query(
        "SELECT id FROM synchro_sessions 
         WHERE room_code = '$room_code' 
         AND status IN ('waiting', 'started', 'active')"
    );
 
    if ($check_room && $check_room->num_rows > 0) {
        $session = $check_room->fetch_assoc();
        $session_id = $session['id'];
 
        // Save room info to session — nickname/avatar set later in waiting room
        $_SESSION['current_session_id'] = $session_id;
        $_SESSION['joined_room_code']   = $room_code;
 
        header("Location: student_waiting_room.php");
        exit();
    } else {
        echo "<script>
            alert('Invalid room code or quiz has already ended. Please try again.');
            window.location.href='synchro_portal.php';
        </script>";
    }
}
$conn->close();
?>
 