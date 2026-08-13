<?php
// teacher_delete_material.php
$conn = new mysqli("localhost", "root", "", "pinnaquest_db");

if (isset($_GET['id'])) {
    $id = intval($_GET['id']);

    // 1. Kunin ang path mula sa teacher_materials table
    $get_file = $conn->query("SELECT file_path FROM teacher_materials WHERE id = $id");
    $file_data = $get_file->fetch_assoc();
    
    if ($file_data) {
        // Burahin ang actual file sa server folder
        if (file_exists($file_data['file_path'])) {
            unlink($file_data['file_path']);
        }

        // 2. Burahin ang record sa teacher_materials table
        $conn->query("DELETE FROM teacher_materials WHERE id = $id");
    }
}

header("Location: teacher_materials.php");
exit();
?>