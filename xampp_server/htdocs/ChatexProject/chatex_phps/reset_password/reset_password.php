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
    $expires = date("Y-m-d H:i:s", strtotime("+1 hour"));

    // Token mentése az adatbázisba
    $stmt = $conn->prepare("UPDATE users SET password_reset_token = ?, password_reset_expires = ? WHERE id = ?");
    $stmt->bind_param("ssi", $token, $expires, $userId);
    $stmt->execute();

    // Jelszó visszaállító link
    $resetLink = "http://localhost/ChatexProject/chatex_phps/reset_password/reset_password_form.php?token=$token";

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
        $mail->setFrom('no-reply@chatex.com', 'Chatex Support');
        $mail->addAddress($email);

        // E-mail tartalma
        $mail->isHTML(true);
        $mail->Subject = "Jelszó visszaállítás";
        $mail->Body = "<p>Kattints az alábbi linkre a jelszó visszaállításához:</p>
                       <p><a href='$resetLink'>$resetLink</a></p>
                       <p>Ez a link 1 óráig érvényes.</p>";


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
    echo json_encode(["success" => false, "message" => "Ez az e-mail nincs regisztrálva."]);
}

$stmt->close();
$conn->close();


// header("Content-Type: application/json");
// header("Access-Control-Allow-Origin: *");
// header("Access-Control-Allow-Methods: POST");
// header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// use PHPMailer\PHPMailer\PHPMailer;
// use PHPMailer\PHPMailer\Exception;

// require '../vendor/autoload.php'; // PHPMailer betöltése
// require_once 'db.php'; // Adatbázis kapcsolat

// // JSON adatok beolvasása
// $data = json_decode(file_get_contents("php://input"), true);

// // Ellenőrizzük, hogy az e-mail meg van-e adva
// if (!isset($data["email"])) {
//     echo json_encode(["success" => false, "message" => "Email megadása kötelező."]);
//     exit();
// }

// $email = $data["email"];

// // Megnézzük, hogy létezik-e az e-mail az adatbázisban
// $stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
// $stmt->bind_param("s", $email);
// $stmt->execute();
// $result = $stmt->get_result();

// if ($result->num_rows > 0) {
//     $row = $result->fetch_assoc(); //key-value párok, az tábla oszlopait alakítja át key-ekké
//     $userId = $row["id"];

//     // Ha a felhasználó létezik, akkor létrehozunk egy helyreállító token-t
//     $token = bin2hex(random_bytes(10)); // Véletlenszerű token generálása
//     $expires = date("Y-m-d H:i:s", strtotime("+1 hour")); // A token 1 órán belül lejár - jelenlegi idő + 1 óra

//     // Token és lejárati idő mentése az adatbázisba
//     $stmt = $conn->prepare("UPDATE users SET password_reset_token = ?, password_reset_expires = ? WHERE id = ?");
//     $stmt->bind_param("ssi", $token, $expires, $userId);
//     $stmt->execute();

//     $resetLink = "http://localhost/ChatexProject/reset_password_form.php?token=$token";

//     $subject = "Jelszó visszaállítás";
//     $message = "Kattints a következő linkre a jelszó visszaállításához: $resetLink";
//     $headers = "From: no-reply@chatex.com\r\nContent-Type: text/plain; charset=UTF-8";

//     if (mail($email, $subject, $message, $headers)) {
//         echo json_encode(["success" => true, "message" => "Helyreállító e-mail elküldve."]);
//     } else {
//         echo json_encode(["success" => false, "message" => "E-mail küldése sikertelen."]);
//     }
// } else {
//     // Ha az e-mail nem létezik az adatbázisban, hibaüzenetet küldünk
//     echo json_encode(["success" => false, "message" => "Ez az e-mail nincs regisztrálva."]);
// }

// $stmt->close();
// $conn->close();
