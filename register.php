<?php
include('db.php'); // Include the database connection file

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Get the form data and escape it to prevent SQL injection
    $full_name = mysqli_real_escape_string($conn, $_POST['full_name']);
    $email = mysqli_real_escape_string($conn, $_POST['email']);
    $password = mysqli_real_escape_string($conn, $_POST['password']);
    $role = $_POST['role']; // Get the role (student or teacher)

    // Hash the password before storing it in the database
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);

    // SQL query to insert the new user into the database
    $sql = "INSERT INTO users (full_name, email, password, role) VALUES ('$full_name', '$email', '$hashed_password', '$role')";

    // Execute the query and check if it's successful
    if ($conn->query($sql) === TRUE) {
        echo "Registration successful!";
        header("Location: loginpanel.php"); // Redirect to the login page after successful registration
        exit();
    } else {
        echo "Error: " . $conn->error; // If there's an error inserting the user, show it
    }
}
?>