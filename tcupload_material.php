<?php
// tcupload_material.php — Teacher material upload with subject whitelist validation

$conn = new mysqli("localhost", "root", "", "pinnaquest_db");
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$ALLOWED_SUBJECTS = [
    "Readings in Philippine History",
    "Understanding the Self",
    "Art Appreciation",
    "Physical Education",
    "Science and Development of Reading",
];

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    // ── Detect PHP-level rejection (post_max_size exceeded) ────────
    if (empty($_FILES) && empty($_POST)) {
        echo "<script>
            alert('❌ Upload Failed!\\n\\nYour PDF is too large for the server.\\n\\nPlease increase upload_max_filesize and post_max_size in php.ini,\\nor use a smaller PDF file.');
            window.location.href = 'teacher_materials.php';
        </script>";
        exit();
    }

    // ── File upload error codes ─────────────────────────────────────
    $upload_error = $_FILES["material_file"]["error"] ?? -1;
    if ($upload_error === UPLOAD_ERR_INI_SIZE || $upload_error === UPLOAD_ERR_FORM_SIZE) {
        echo "<script>
            alert('❌ File Too Large!\\n\\nThe PDF exceeds the server upload limit.\\nTry compressing the PDF or splitting it into smaller files.');
            window.location.href = 'teacher_materials.php';
        </script>";
        exit();
    }
    if ($upload_error === UPLOAD_ERR_NO_FILE) {
        echo "<script>
            alert('❌ No file selected. Please choose a PDF file.');
            window.location.href = 'teacher_materials.php';
        </script>";
        exit();
    }

    $title = trim($_POST['title'] ?? '');

    // ── Subject whitelist ───────────────────────────────────────────
    if (!in_array($title, $ALLOWED_SUBJECTS)) {
        echo "<script>
            alert('❌ Upload Rejected!\\n\\nPinnaQuest covers selected GE subjects only:\\n\\n• Readings in Philippine History\\n• Understanding the Self\\n• Art Appreciation\\n• Physical Education\\n• Science and Development of Reading\\n\\nPlease select a valid subject.');
            window.location.href = 'teacher_materials.php';
        </script>";
        exit();
    }

    // ── PDF only ────────────────────────────────────────────────────
    $file_ext = strtolower(pathinfo($_FILES["material_file"]["name"], PATHINFO_EXTENSION));
    if ($file_ext !== 'pdf') {
        echo "<script>
            alert('❌ Only PDF files are accepted.');
            window.location.href = 'teacher_materials.php';
        </script>";
        exit();
    }

    // ── Size limit: 100MB ───────────────────────────────────────────
    if ($_FILES["material_file"]["size"] > 100 * 1024 * 1024) {
        echo "<script>
            alert('❌ File too large. Maximum size is 100MB.');
            window.location.href = 'teacher_materials.php';
        </script>";
        exit();
    }

    // ── Save ────────────────────────────────────────────────────────
    $target_dir = "uploads/teacher_vault/";
    if (!is_dir($target_dir)) mkdir($target_dir, 0777, true);

    $title_safe  = $conn->real_escape_string($title);
    $file_name   = time() . "_" . basename($_FILES["material_file"]["name"]);
    $target_file = $target_dir . $file_name;

    if (move_uploaded_file($_FILES["material_file"]["tmp_name"], $target_file)) {
        $sql = "INSERT INTO teacher_materials (title, file_path, date_uploaded)
                VALUES ('$title_safe', '$target_file', NOW())";
        if ($conn->query($sql) === TRUE) {
            echo "<script>
                alert('✅ Resource secured!\\n\\nSubject: $title\\nThe material has been added to your vault.');
                window.location.href = 'teacher_materials.php';
            </script>";
        } else {
            echo "<script>alert('❌ Database error: " . addslashes($conn->error) . "'); history.back();</script>";
        }
    } else {
        echo "<script>alert('❌ Upload failed. Please try again.'); history.back();</script>";
    }
}

$conn->close();
?>