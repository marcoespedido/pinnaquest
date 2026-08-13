<?php
// upload_material.php — Student material upload with subject whitelist validation

$conn = new mysqli("localhost", "root", "", "pinnaquest_db");
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// ── Allowed subjects whitelist ─────────────────────────────────────
$ALLOWED_SUBJECTS = [
    "Readings in Philippine History",
    "Understanding the Self",
    "Art Appreciation",
    "Physical Education",
    "Science and Development of Reading",
];

// ── Check if PHP itself rejected the upload (file too large) ───────
// This happens BEFORE our code runs — $_FILES will be empty
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    // Detect PHP-level upload failure (post_max_size exceeded)
    if (empty($_FILES) && empty($_POST)) {
        echo "<script>
            alert('❌ Upload Failed!\\n\\nYour PDF file is too large for the server to accept.\\n\\nPlease use a smaller PDF file (under 50MB),\\nor ask your administrator to increase the upload limit in php.ini.');
            window.location.href = 'materials.php';
        </script>";
        exit();
    }

    // Detect individual file upload error codes
    $upload_error = $_FILES["material_file"]["error"] ?? -1;
    if ($upload_error === UPLOAD_ERR_INI_SIZE || $upload_error === UPLOAD_ERR_FORM_SIZE) {
        echo "<script>
            alert('❌ File Too Large!\\n\\nThe PDF exceeds the maximum allowed upload size.\\n\\nTip: Try compressing the PDF first, or split it into smaller files.');
            window.location.href = 'materials.php';
        </script>";
        exit();
    }
    if ($upload_error === UPLOAD_ERR_NO_FILE) {
        echo "<script>
            alert('❌ No file selected. Please choose a PDF file before uploading.');
            window.location.href = 'materials.php';
        </script>";
        exit();
    }

    $title = trim($_POST['title'] ?? '');
$display_name = trim($_POST['display_name'] ?? '');

    // ── Server-side subject validation ─────────────────────────────
    if (!in_array($title, $ALLOWED_SUBJECTS)) {
        echo "<script>
            alert('❌ Upload Rejected!\\n\\nPinnaQuest only accepts materials for the following General Education subjects:\\n\\n• Readings in Philippine History\\n• Understanding the Self\\n• Art Appreciation\\n• Physical Education\\n• Science and Development of Reading\\n\\nPlease select a valid subject and try again.');
            window.location.href = 'materials.php';
        </script>";
        exit();
    }

    // ── File type validation — PDF only ────────────────────────────
    $file_ext = strtolower(pathinfo($_FILES["material_file"]["name"], PATHINFO_EXTENSION));
    if ($file_ext !== 'pdf') {
        echo "<script>
            alert('❌ Invalid File Type!\\n\\nOnly PDF files are accepted. Please upload a .pdf file.');
            window.location.href = 'materials.php';
        </script>";
        exit();
    }

    // ── File size limit: 100MB (matches recommended php.ini) ───────
    $max_bytes = 100 * 1024 * 1024;
    if ($_FILES["material_file"]["size"] > $max_bytes) {
        echo "<script>
            alert('❌ File Too Large!\\n\\nMaximum allowed size is 100MB.\\nYour file: ' + Math.round(" . $_FILES["material_file"]["size"] . " / 1048576) + 'MB');
            window.location.href = 'materials.php';
        </script>";
        exit();
    }

    // ── Save file ───────────────────────────────────────────────────
    $target_dir = "uploads/";
    $title_safe        = $conn->real_escape_string($title);

    // Fallback kung walang nilagay na display name
    if (empty($display_name)) {
        $display_name = pathinfo($_FILES["material_file"]["name"], PATHINFO_FILENAME);
    }
    $display_name_safe = $conn->real_escape_string($display_name);

    $file_name   = time() . "_" . basename($_FILES["material_file"]["name"]);
    $target_file = $target_dir . $file_name;

    if (move_uploaded_file($_FILES["material_file"]["tmp_name"], $target_file)) {
        $sql = "INSERT INTO materials (title, display_name, file_path, date_uploaded)
                VALUES ('$title_safe', '$display_name_safe', '$target_file', NOW())";
        if ($conn->query($sql) === TRUE) {
            echo "<script>
                alert('✅ Quest Material successfully forged!\\n\\nFile Name: $display_name\\nSubject: $title\\nThe material is now ready for quiz generation.');
                window.location.href = 'materials.php';
            </script>";
        } else {
            echo "<script>alert('❌ Database error: " . addslashes($conn->error) . "'); history.back();</script>";
        }
    }
}

$conn->close();
?>