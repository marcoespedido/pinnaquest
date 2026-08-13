<?php
// login.php - FIXED: Sets $_SESSION['user_name'] so Synchro-Quiz and other pages work
session_start();
include('db.php');
 
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['email'], $_POST['password'], $_POST['role'])) {
        $email    = mysqli_real_escape_string($conn, $_POST['email']);
        $password = mysqli_real_escape_string($conn, $_POST['password']);
        $role     = mysqli_real_escape_string($conn, $_POST['role']);
 
        $sql    = "SELECT * FROM users WHERE email='$email' AND role='$role'";
        $result = $conn->query($sql);
 
        if ($result->num_rows > 0) {
            $user = $result->fetch_assoc();
 
            if (password_verify($password, $user['password'])) {
                $_SESSION['user_id']   = $user['id'];
                $_SESSION['role']      = $user['role'];
                // FIX: Save full_name so all pages (synchro, dashboard, etc.) can read it
                $_SESSION['user_name'] = $user['full_name'];
 
                if ($user['role'] == 'student') {
                    header("Location: studentdashboard.php");
                } else {
                    header("Location: teacherdashboard.php");
                }
                exit();
            } else {
                echo "<script>alert('Invalid password!'); history.back();</script>";
            }
        } else {
            echo "<script>alert('No user found with that email and role!'); history.back();</script>";
        }
    } else {
        echo "<script>alert('Missing required fields!'); history.back();</script>";
    }
}
?>