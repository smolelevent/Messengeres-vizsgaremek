<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require_once __DIR__ . "/../db.php"; // Adatbázis kapcsolat
require_once __DIR__ . '/../vendor/autoload.php'; // PHPMailer betöltése

// JSON adatok beolvasása
$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["email"])) {
    echo json_encode(["success" => false, "message" => "Email megadása kötelező."]);
    exit();
}

$email = $data["email"];

// Megnézzük, hogy létezik-e az e-mail az adatbázisban
$stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $userId = $row["id"];

    // Token generálása és lejárati idő beállítása
    $token = bin2hex(random_bytes(20));
    $expires = date("Y-m-d H:i:s", strtotime("+15 minutes"));

    // Token mentése az adatbázisba
    $stmt = $conn->prepare("UPDATE users SET password_reset_token = ?, password_reset_expires = ? WHERE id = ?");
    $stmt->bind_param("ssi", $token, $expires, $userId);
    $stmt->execute();

    // Jelszó visszaállító link
    $resetLink = "http://localhost/ChatexProject/chatex_phps/reset_password/open_reset_window.php?token=$token";

    // **📧 PHPMailer konfigurálása és email küldés**
    $mail = new PHPMailer(true);

    try {
        // SMTP beállítások
        $mail->isSMTP();
        $mail->Host = 'smtp.gmail.com'; // SMTP szerver (pl. Gmail)
        $mail->SMTPAuth = true;
        $mail->Username = 'chatexfejlesztok@gmail.com'; // SMTP e-mail címed
        $mail->Password = 'uvatzwfcrjlcujrs'; // SMTP jelszó vagy App Password
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
        $mail->Port = 587;
        $mail->CharSet = 'UTF-8';
        $mail->Encoding = 'base64';

        // Feladó és címzett
        $mail->setFrom('chatexfejlesztok@gmail.com', 'Chatex support (no reply)');
        $mail->addAddress($email);

        // E-mail tartalma
        $mail->isHTML(true);
        $mail->Subject = "Jelszó visszaállítás";
        $mail->Body = "<h1>Kattints az alábbi linkre a jelszó visszaállításához:</h1>
                       <p><a href='$resetLink' target='_blank'>$resetLink</a></p>
                       <h2>Ez a link 15 percig érvényes.</h2>
                       <p>Chatex</p>";

        // E-mail küldés
        if ($mail->send()) {
            echo json_encode(["success" => true, "message" => "Helyreállító e-mail elküldve."]);
        } else {
            echo json_encode(["success" => false, "message" => "E-mail küldése sikertelen."]);
        }
    } catch (Exception $e) {
        echo json_encode(["success" => false, "message" => "E-mail hiba: {$mail->ErrorInfo}"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Nincs ilyen email című felhasználó!"]);
}

$stmt->close();
$conn->close();
