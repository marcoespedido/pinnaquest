<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>PinnaQuest | Login & Register</title>
    <link
      href="https://fonts.googleapis.com/css2?family=Lexend:wght@400;700;800&family=Inter:wght@400;500&display=swap"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <style>
      :root {
        --primary-green: #1db968;
        --teacher-blue: #4a90e2;
        --accent-orange: #f6ad55;
        --text-dark: #2d3748;
        --text-light: #718096;
        --bg-light: #f9fbfb;
      }
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }
      body {
        font-family: "Inter", sans-serif;
        background-color: var(--bg-light);
        color: var(--text-dark);
        min-height: 100vh;
        display: flex;
        flex-direction: column;
      }
      .navbar {
        width: 100%;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 5px 80px;
      }
      .logo {
        display: flex;
        align-items: center;
        gap: 12px;
        text-decoration: none;
        font-family: "Lexend", sans-serif;
        font-weight: 700;
        font-size: 24px;
        color: #1a4d36;
      }
      .logo img {
        height: 60px;
        width: auto;
        mix-blend-mode: multiply;
      }
      .auth-container {
        flex: 1;
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 40px 20px;
      }
      .auth-card {
        background: white;
        padding: 40px;
        border-radius: 24px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.05);
        width: 100%;
        max-width: 450px;
        text-align: center;
        border: 1px solid #edf2f7;
      }
      .role-selector {
        display: flex;
        background: #f1f5f9;
        padding: 5px;
        border-radius: 12px;
        margin-bottom: 25px;
      }
      .role-btn {
        flex: 1;
        padding: 10px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 600;
        transition: 0.3s;
        background: transparent;
        color: var(--text-light);
      }
      .role-btn.active {
        background: white;
        color: var(--text-dark);
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }
      .form-group {
        text-align: left;
        margin-bottom: 15px;
      }
      .form-group label {
        display: block;
        font-weight: 600;
        margin-bottom: 8px;
        font-size: 0.9rem;
      }
      .form-group input {
        width: 100%;
        padding: 12px;
        border: 2px solid #edf2f7;
        border-radius: 10px;
        outline: none;
      }
      .password-wrapper {
        position: relative;
      }
      .password-wrapper input {
        padding-right: 42px;
      }
      .toggle-password {
        position: absolute;
        top: 50%;
        right: 14px;
        transform: translateY(-50%);
        cursor: pointer;
        color: var(--text-light);
        font-size: 16px;
        user-select: none;
        transition: color 0.2s;
      }
      .toggle-password:hover {
        color: var(--primary-green);
      }
      .auth-btn {
        width: 100%;
        padding: 14px;
        border: none;
        border-radius: 12px;
        font-size: 1rem;
        font-weight: 700;
        color: white;
        cursor: pointer;
        margin-top: 10px;
        transition: 0.3s;
      }
      .btn-student {
        background: var(--primary-green);
      }
      .btn-teacher {
        background: var(--teacher-blue);
      }
      .hidden {
        display: none;
      }
      .switch-text {
        margin-top: 20px;
        font-size: 0.9rem;
        color: var(--text-light);
      }
      .switch-text a {
        color: var(--primary-green);
        font-weight: 700;
        text-decoration: none;
      }
    </style>
  </head>
  <body>
    <nav class="navbar">
      <div class="logo">
        <img src="pinnaquest logo.JPG" alt="PinnaQuest Logo" />
      </div>
    </nav>

    <div class="auth-container">
      <div class="auth-card">
        <h2 id="form-title">Welcome Back!</h2>
        <p id="form-subtitle">Choose your role to continue your quest.</p>

        <div class="role-selector">
          <button class="role-btn active" onclick="setRole('student')">
            Student
          </button>
          <button class="role-btn" onclick="setRole('teacher')">Teacher</button>
        </div>

        <!-- Login Form -->
        <form action="login.php" method="POST" id="auth-form">
    <div id="register-fields" class="hidden">
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="fullname" id="fullname-input" placeholder="Juan Dela Cruz" />
        </div>
    </div>

    <div id="login-fields">
        <div class="form-group">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="name@example.com" required />
        </div>
        <div class="form-group">
            <label>Password</label>
            <div class="password-wrapper">
                <input type="password" name="password" id="passwordInput" placeholder="••••••••" required />
                <span class="toggle-password" id="togglePassword" onclick="togglePasswordVisibility()">
                    <i class="fa-solid fa-eye" id="toggleIcon"></i>
                </span>
            </div>
        </div>
    </div>

    <input type="hidden" name="role" id="role-input" value="student" />
    <button type="submit" class="auth-btn btn-student" id="main-btn">
        Login as Student
    </button>
</form>

        <div class="switch-text">
          <span id="toggle-msg">Don't have an account?</span>
          <a href="#" id="toggle-link" onclick="toggleMode()"
            >Create one here</a
          >
        </div>
      </div>
    </div>

    <script>
      function togglePasswordVisibility() {
        const input = document.getElementById("passwordInput");
        const icon = document.getElementById("toggleIcon");
        if (input.type === "password") {
          input.type = "text";
          icon.classList.remove("fa-eye");
          icon.classList.add("fa-eye-slash");
        } else {
          input.type = "password";
          icon.classList.remove("fa-eye-slash");
          icon.classList.add("fa-eye");
        }
      }

      let currentRole = "student";
      let isLoginMode = true;

      function setRole(role) {
        currentRole = role;
        document.querySelectorAll(".role-btn").forEach((btn) => {
          btn.classList.toggle("active", btn.innerText.toLowerCase() === role);
        });
        document.getElementById("role-input").value = currentRole;
        updateUI();
      }

      function toggleMode() {
        isLoginMode = !isLoginMode;
        updateUI();
      }

      function updateUI() {
    const title = document.getElementById("form-title");
    const mainBtn = document.getElementById("main-btn");
    const regFields = document.getElementById("register-fields");
    const fullNameInput = document.getElementById("fullname-input"); // Kunin ang input element
    const toggleMsg = document.getElementById("toggle-msg");
    const toggleLink = document.getElementById("toggle-link");
    const authForm = document.getElementById("auth-form");

    if (isLoginMode) {
        title.innerText = "Welcome Back!";
        toggleMsg.innerText = "Don't have an account?";
        toggleLink.innerText = "Create one here";
        regFields.classList.add("hidden");
        fullNameInput.required = false; // Alisin ang required kapag login
        authForm.action = "login.php";
    } else {
        title.innerText = "Join PinnaQuest";
        toggleMsg.innerText = "Already a member?";
        toggleLink.innerText = "Login here";
        regFields.classList.remove("hidden");
        fullNameInput.required = true; // Gawing required kapag registration
        authForm.action = "register.php";
    }

    mainBtn.innerText = `${isLoginMode ? "Login" : "Register"} as ${currentRole.charAt(0).toUpperCase() + currentRole.slice(1)}`;
    mainBtn.className = `auth-btn btn-${currentRole}`;
}
    </script>
  </body>
</html>