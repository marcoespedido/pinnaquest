<?php
session_start();
$conn = new mysqli("localhost", "root", "", "pinnaquest_db");

// Kunin ang info ng student mula sa session
$user_initial = isset($_SESSION['user_name']) ? strtoupper(substr($_SESSION['user_name'], 0, 1)) : 'Q';
$user_full_name = isset($_SESSION['user_name']) ? $_SESSION['user_name'] : 'Guest Student';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>PinnaQuest | Synchro-Quiz Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <style>
        :root {
            --brand-green: #1db968;
            --brand-dark-green: #1a4d2e;
            --soft-green: #f0fff4;
            --sidebar-white: #ffffff;
            --text-dark: #1a202c;
            --text-gray: #718096;
            --border-color: #f1f5f9;
            --synchro-purple: #6366f1; 
            --icon-materials: #3b82f6; 
            --icon-quizzes: #f59e0b;   
            --icon-leaderboard: #10b981;
        }

        .persona-link-style { color: #94a3b8 !important; }
        .persona-link-style:hover { background-color: #f0f7ff !important; color: #3b82f6 !important; }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: "Inter", sans-serif;
            background: #fcfdfa;
            display: flex;
            min-height: 100vh;
        }

        /* --- SIDEBAR --- */
        .sidebar {
            width: 260px;
            background: var(--sidebar-white);
            height: 100vh;
            display: flex;
            flex-direction: column;
            padding: 30px 20px;
            position: fixed;
            border-right: 1px solid var(--border-color);
            z-index: 1000;
        }

        .logo-box { margin-bottom: 40px; text-align: center; }
        .logo-box img { width: 180px; transition: 0.3s; cursor: pointer; }
        .logo-box img:hover { transform: scale(1.08); }

        .menu-heading {
            font-size: 11px; font-weight: 700; color: #cbd5e0;
            text-transform: uppercase; margin: 20px 0 10px 10px; letter-spacing: 0.05em;
        }

        .nav-link {
            display: flex; align-items: center; gap: 15px; padding: 14px 18px;
            text-decoration: none; color: var(--text-gray); font-weight: 500;
            font-size: 14px; border-radius: 12px; margin-bottom: 5px; transition: 0.2s;
        }

        .nav-link.active { background-color: var(--brand-green); color: white !important; }
        .nav-link.active i { color: white !important; text-shadow: none !important; }
        .nav-link:hover:not(.active) { background: var(--soft-green); color: var(--brand-green); }

        /* ICON COLORING */
        .nav-link i.fa-house { color: var(--brand-green); text-shadow: 0 0 8px rgba(29, 185, 104, 0.4); }
        .nav-link i.fa-file-invoice { color: var(--icon-materials); text-shadow: 0 0 8px rgba(59, 130, 246, 0.4); }
        .nav-link i.fa-brain { color: var(--icon-quizzes); text-shadow: 0 0 8px rgba(245, 158, 11, 0.4); }
        .nav-link i.fa-bolt-lightning { color: var(--synchro-purple); text-shadow: 0 0 8px rgba(99, 102, 241, 0.4); }
        .nav-link i.fa-trophy { color: var(--icon-leaderboard); text-shadow: 0 0 8px rgba(16, 185, 129, 0.4); }
        .nav-link i.fa-user-astronaut { color: #3b82f6; text-shadow: 0 0 8px rgba(59, 130, 246, 0.3); }

        /* --- MAIN CONTENT --- */
        .main {
            flex: 1;
            margin-left: 260px;
            padding: 30px 50px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .portal-card {
            background: white;
            padding: 50px;
            border-radius: 28px;
            text-align: center;
            max-width: 600px;
            width: 100%;
            border: 1px solid var(--border-color);
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        }

        /* --- ANIMATED PORTAL ICON --- */
        .portal-icon {
            width: 80px;
            height: 80px;
            background: #f5f3ff;
            color: var(--synchro-purple);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 35px;
            margin: 0 auto 25px;
            box-shadow: 0 0 20px rgba(99, 102, 241, 0.15);
            animation: pulse-purple 2s infinite;
        }

        @keyframes pulse-purple {
            0% { box-shadow: 0 0 0 0 rgba(99, 102, 241, 0.4); }
            70% { box-shadow: 0 0 0 15px rgba(99, 102, 241, 0); }
            100% { box-shadow: 0 0 0 0 rgba(99, 102, 241, 0); }
        }

        .portal-card h2 { font-family: 'Lexend', sans-serif; font-size: 28px; color: var(--brand-dark-green); margin-bottom: 10px; }
        .portal-card p { color: var(--text-gray); margin-bottom: 30px; line-height: 1.6; font-size: 15px; }

        .input-group { display: flex; gap: 10px; justify-content: center; }
        .input-group input {
            padding: 15px;
            width: 200px;
            border-radius: 12px;
            border: 2px solid #ede9fe;
            outline: none;
            font-size: 20px;
            font-weight: 800;
            text-align: center;
            text-transform: uppercase;
            font-family: 'Lexend', sans-serif;
            transition: 0.3s;
        }
        .input-group input:focus { border-color: var(--synchro-purple); box-shadow: 0 0 10px rgba(99, 102, 241, 0.1); }

        .btn-join {
            background: var(--synchro-purple);
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 12px;
            font-weight: 700;
            font-family: 'Lexend', sans-serif;
            cursor: pointer;
            transition: 0.3s;
            box-shadow: 0 4px 0 #4f46e5;
        }
        .btn-join:hover { background: #4f46e5; transform: translateY(-2px); }
        .btn-join:active { transform: translateY(2px); box-shadow: 0 1px 0 #4f46e5; }

        /* FOOTER & LOGOUT */
        .sidebar-footer { margin-top: auto; }
        .user-profile-bottom {
            background: #f8fafc; padding: 15px; border-radius: 16px;
            display: flex; align-items: center; gap: 12px; margin-bottom: 10px;
        }
        .avatar {
            width: 35px; height: 35px; background: var(--brand-green);
            border-radius: 8px; color: white; display: flex;
            align-items: center; justify-content: center; font-weight: 800;
        }
        .logout-link {
            display: flex; align-items: center; gap: 10px; text-decoration: none;
            color: var(--text-gray); font-size: 13px; font-weight: 600; padding: 10px 15px;
        }
        .logout-link:hover { color: #e53e3e; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="logo-box">
            <img src="pinnaquest logo.JPG" alt="PinnaQuest" />
        </div>

        <p class="menu-heading">Menu</p>
        <nav>
            <a href="studentdashboard.php" class="nav-link">
                <i class="fa-solid fa-house"></i> Dashboard
            </a>
            <a href="materials.php" class="nav-link">
                <i class="fa-solid fa-file-invoice"></i> Materials
            </a>
            <a href="quizzes.php" class="nav-link">
                <i class="fa-solid fa-brain"></i> Quizzes
            </a>
            <a href="synchro_portal.php" class="nav-link active">
                <i class="fa-solid fa-bolt-lightning"></i> Synchro-Quiz
            </a>
            <a href="leaderboard.php" class="nav-link">
                <i class="fa-solid fa-trophy"></i> Mission Map
            </a>
            <a href="javascript:void(0)" class="nav-link persona-link-style" onclick="openPersona()">
                <i class="fa-solid fa-user-astronaut"></i> Quest Persona
            </a>
            <a href="account_settings.php" class="nav-link"><i class="fa-solid fa-gear" style="color:#f59e0b"></i> Account Settings</a>
        </nav>

        <div class="sidebar-footer">
            <div class="user-profile-bottom">
                <div class="avatar" id="side-avatar"><?php echo $user_initial; ?></div>
                <div class="user-details">
                    <h4 id="side-name" style="font-size: 13px; font-weight: 700; color: #2d3748;"><?php echo htmlspecialchars($user_full_name); ?></h4>
                    <p style="font-size: 11px; color: var(--text-gray);">Student</p>
                </div>
            </div>
            <a href="logout.php" class="logout-link">
                <i class="fa-solid fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <div class="main">
        <div class="portal-card">
            <div class="portal-icon">
                <i class="fa-solid fa-bolt"></i>
            </div>
            <h2>Synchro-Quiz Portal</h2>
            <p>Joining a live classroom quest? Enter the party code provided by your teacher to begin the real-time challenge.</p>
            
            <form action="process_join.php" method="POST" class="input-group">
                <input type="text" name="room_code" placeholder="PQ-000000" maxlength="9" required autocomplete="off">
                <button type="submit" class="btn-join">JOIN QUEST</button>
            </form>
        </div>
    </div>

    <script>
        function openPersona() {
            alert("Edit Persona feature coming soon to this panel!");
        }
        const roomInput = document.querySelector('input[name="room_code"]');
roomInput.addEventListener('input', function() {
    this.value = this.value.toUpperCase();
    
    // Optional: Auto-add "PQ-" kung nakalimutan ng student
    if(this.value.length > 0 && !this.value.startsWith('PQ-')) {
        this.value = 'PQ-' + this.value;
    }
});
    </script>
</body>
</html>