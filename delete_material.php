<?php
$conn = new mysqli("localhost", "root", "", "pinnaquest_db");

if (isset($_GET['id'])) {
    $id = $_GET['id'];

    // 1. Kunin muna ang file path para mabura ang actual file sa folder
    $get_file = $conn->query("SELECT file_path FROM materials WHERE id = $id");
    $file_data = $get_file->fetch_assoc();
    
    if ($file_data) {
        // Burahin ang file sa server
        if (file_exists($file_data['file_path'])) {
            unlink($file_data['file_path']);
        }

        // 2. Burahin ang record sa database
        $conn->query("DELETE FROM materials WHERE id = $id");
    }
}

header("Location: materials.php");
exit();
?>