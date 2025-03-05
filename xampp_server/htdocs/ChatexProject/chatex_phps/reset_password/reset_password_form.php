<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../db.php";

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $token = $_POST["token"] ?? '';
    $newPassword = $_POST["new_password"] ?? '';

    if (!$token || !$newPassword) {
        die("Érvénytelen kérés.");
    }

    // Token ellenőrzése és lejárati idő vizsgálata
    $stmt = $conn->prepare("SELECT id FROM users WHERE password_reset_token = ? AND password_reset_expires > NOW()");
    $stmt->bind_param("s", $token);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $userId = $row["id"];

        // Jelszó hashelése és frissítése
        $hashedPassword = password_hash($newPassword, PASSWORD_BCRYPT);
        $stmt = $conn->prepare("UPDATE users SET password = ?, password_reset_token = NULL, password_reset_expires = NULL WHERE id = ?");
        $stmt->bind_param("si", $hashedPassword, $userId);
        $stmt->execute();

        echo "Jelszó sikeresen frissítve!";
    } else {
        echo "Érvénytelen vagy lejárt token.";
    }

    $stmt->close();
    $conn->close();
} else {
    // Token lekérése URL-ből
    $token = $_GET["token"] ?? '';
    if (!$token) {
        die("Érvénytelen token.");
    }

    // Egyszerű HTML űrlap
    echo '<form method="POST">
            <input type="hidden" name="token" value="' . htmlspecialchars($token) . '">
            <label>Új jelszó:</label>
            <input type="password" name="new_password" required>
            <button type="submit">Jelszó visszaállítása</button>
          </form>';
}
