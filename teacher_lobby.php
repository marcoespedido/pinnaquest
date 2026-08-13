<?php
session_start();
$conn = new mysqli("localhost", "root", "", "pinnaquest_db");

// 1. Inayos ang $_GET['room'] (dahil room=$room_code ang galing sa process.php)
$room_code = isset($_GET['room']) ? $conn->real_escape_string($_GET['room']) : '';

// 2. Inayos ang query: 'title' imbes na 'room_name' para mag-match sa database natin
$session_query = $conn->query("SELECT id, title FROM synchro_sessions WHERE room_code = '$room_code'");

if (!$session_query || $session_query->num_rows == 0) { 
    die("Invalid Room Code. Please go back and try again."); 
}

$session = $session_query->fetch_assoc();
$session_id = $session['id'];

// Listahan ng avatars para sa mapping
$avatars = [
    'gamer_girl' => '1a.JPG', 
    'blue_robot' => '2a.JPG', 
    'gorilla_vr'  => '3a.JPG', 
    'grey_cat'    => '4a.JPG', 
    'monkey_cap'  => '5a.JPG', 
    'astronaut'   => '6a.JPG', 
    'bear_angry'  => '7a.JPG', 
    'bear_bee'    => '8a.JPG'
];
?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>PinnaQuest Lobby | <?php echo htmlspecialchars($room_code); ?></title>
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@700;800&family=Inter:wght@400;600&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
   <style>
    @import url('https://fonts.googleapis.com/css2?family=Luckiest+Guy&family=Press+Start+2P&family=Lexend:wght@700;800&display=swap');

    body { 
        font-family: 'Lexend', sans-serif; 
        background: radial-gradient(circle, #6366f1 0%, #4338ca 100%); 
        color: white; 
        margin: 0; 
        display: flex; 
        flex-direction: column; 
        align-items: center; 
        min-height: 100vh; 
        padding: 50px; 
    }
    
    .lobby-header { 
        background: white; 
        color: #1a202c; 
        padding: 25px 45px; 
        border-radius: 30px; 
        display: flex; 
        align-items: center; 
        box-shadow: 0 15px 0px #c7d2fe; 
        margin-bottom: 50px; 
        width: 100%; 
        max-width: 950px; 
        border: 4px solid #4338ca;
    }

    .code-box { 
        text-align: center; 
        border-right: 3px dashed #e2e8f0; 
        padding-right: 40px; 
        margin-right: 40px; 
    }

    .code-label { 
        font-size: 14px; 
        color: #6366f1; 
        text-transform: uppercase; 
        font-weight: 800;
        letter-spacing: 1px;
    }

    .room-code { 
        font-family: 'Luckiest Guy', cursive; 
        font-size: 42px; 
        color: #1a202c; 
        margin-top: 10px;
        text-shadow: 2px 2px #cbd5e0;
    }

    .quest-title-text {
        font-family: 'Luckiest Guy', cursive; 
        font-size: 32px; 
        color: #4338ca; 
        letter-spacing: 2px;
        margin: 0;
    }

    .status-text { 
        font-family: 'Luckiest Guy', cursive; 
        font-size: 36px; 
        color: #f7f6f6; 
        text-shadow: 3px 3px #000;
        margin-bottom: 30px;
        animation: pulse 1.5s infinite;
    }
    
    @keyframes pulse {
        0% { transform: scale(1); filter: brightness(1); }
        50% { transform: scale(1.05); filter: brightness(1.2); }
        100% { transform: scale(1); filter: brightness(1); }
    }

    /* Participant Grid Style */
    .participant-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
        gap: 20px;
        width: 100%;
        max-width: 1000px;
        margin-bottom: 40px;
    }

    .student-card { 
        background: #ffffff; 
        color: #4338ca;
        padding: 20px; 
        border-radius: 20px; 
        text-align: center; 
        box-shadow: 0 8px 0px #312e81; 
        transition: transform 0.2s;
        border: 3px solid #1a202c;
    }
    .student-card:hover { transform: translateY(-5px); }

    .student-avatar-img {
        width: 80px;
        height: 80px;
        border-radius: 15px;
        object-fit: cover;
        background: #f1f5f9;
        border: 2px solid #e2e8f0;
    }

    .student-name { 
        font-family: 'Luckiest Guy', sans-serif; 
        font-size: 18px; 
        margin-top: 10px; 
        color: #1a202c;
        text-transform: uppercase;
    }

    .btn-start {
        background: #ffde59;
        color: #1a202c;
        border: 4px solid #1a202c;
        padding: 15px 40px;
        font-family: 'Luckiest Guy', cursive;
        font-size: 24px;
        border-radius: 20px;
        cursor: pointer;
        box-shadow: 0 8px 0px #b29a3e;
        display: none;
    }
    .btn-start:active { transform: translateY(4px); box-shadow: 0 4px 0px #b29a3e; }
</style>
</head>
<body>

  <div class="lobby-header">
    <div class="code-box">
        <div class="code-label">READY YOUR GEARS! JOIN CODE:</div>
        <div class="room-code"><?php echo $room_code; ?></div>
    </div>
    <div style="flex:1;">
        <p style="margin:0; font-size:12px; color:#718096; font-weight:bold; text-transform:uppercase;">Current Quest:</p>
        <h1 class="quest-title-text"><?php echo htmlspecialchars($session['title']); ?></h1>
        <div style="font-size:14px; color:#6366f1; font-weight:600;">Waiting for participants to enter...</div>
    </div>
</div>

    <div class="status-text" id="statusMessage">Waiting for participants...</div>

    <div class="participant-grid" id="participantGrid"></div>

    <button class="btn-start" id="startQuizBtn">Start Quest <i class="fa-solid fa-arrow-right"> </i></button>
    
<script>
        const sessionId = <?php echo $session_id; ?>;
        const avatarMap = <?php echo json_encode($avatars); ?>;
        const grid = document.getElementById('participantGrid');
        const statusMsg = document.getElementById('statusMessage');
        const startBtn = document.getElementById('startQuizBtn');

        function checkParticipants() {
            fetch(`get_participants.php?session_id=${sessionId}`)
                .then(response => response.json())
                .then(data => {
                    let newHTML = ''; 
                    const currentCount = data.length;

                    if (currentCount > 0) {
                        statusMsg.innerText = `${currentCount} Adventurer${currentCount > 1 ? 's' : ''} Joined!`;
                        startBtn.style.display = 'block'; 
                        
                        data.forEach(student => {
                            const avatarFile = avatarMap[student.avatar_key] || 'default.jpg';
                            
                            newHTML += `
                                <div class="student-card">
                                    <img src="${avatarFile}" class="student-avatar-img" alt="Avatar">
                                    <div class="student-name">${student.nickname}</div>
                                </div>
                            `;
                        });

                        grid.innerHTML = newHTML;

                    } else {
                        statusMsg.innerText = "Waiting for participants...";
                        grid.innerHTML = ''; 
                        startBtn.style.display = 'none';
                    }
                })
                .catch(err => console.error("Error fetching participants:", err));
        }

        // START QUEST LOGIC
        startBtn.addEventListener('click', function() {
            if (confirm("Are you sure you want to start the quest?")) {
                fetch('start_session.php', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: `session_id=${sessionId}`
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Kapag success ang update sa DB, lipat si Teacher sa monitor screen
                        window.location.href = "teacher_quiz_monitor.php?session_id=" + sessionId;
                    } else {
                        alert("Failed to start the quest. Try again.");
                    }
                })
                .catch(err => console.error("Error starting session:", err));
            }
        });

        setInterval(checkParticipants, 2000);
        checkParticipants();
    </script>
</body>
</html>