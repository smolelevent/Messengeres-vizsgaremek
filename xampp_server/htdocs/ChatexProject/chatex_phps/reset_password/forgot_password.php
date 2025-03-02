<?php
// // Include the Autoloader (see "Libraries" for install instructions)
// require 'vendor/autoload.php';

// // Use the Mailgun class from mailgun/mailgun-php v4.2
// use Mailgun\Mailgun;

// // Instantiate the client.
// $mg = Mailgun::create(getenv('API_KEY') ?: 'API_KEY');
// // When you have an EU-domain, you must specify the endpoint:
// // $mg = Mailgun::create(getenv('API_KEY') ?: 'API_KEY', 'https://api.eu.mailgun.net'); 

// // Compose and send your message.
// $result = $mg->messages()->send(
//     'sandbox286ca62c5a524a109ede274a8c80e81e.mailgun.org',
//     [
//         'from' => 'Mailgun Sandbox <postmaster@sandbox286ca62c5a524a109ede274a8c80e81e.mailgun.org>',
//         'to' => 'Kiss Levente <chatexfejlesztok@gmail.com>',
//         'subject' => 'Hello Kiss Levente',
//         'text' => 'Congratulations Kiss Levente, you just sent an email with Mailgun! You are truly awesome!'
//     ]
// );

// print_r($result->getMessage());



header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once 'db.php'; // Adatbázis kapcsolat

// JSON adatok beolvasása
$data = json_decode(file_get_contents("php://input"), true);

// Ellenőrizzük, hogy az e-mail meg van-e adva
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
    $row = $result->fetch_assoc(); //key-value párok, az tábla oszlopait alakítja át key-ekké
    $userId = $row["id"];

    // Ha a felhasználó létezik, akkor létrehozunk egy helyreállító token-t
    $token = bin2hex(random_bytes(10)); // Véletlenszerű token generálása
    $expires = date("Y-m-d H:i:s", strtotime("+1 hour")); // A token 1 órán belül lejár - jelenlegi idő + 1 óra

    // Token és lejárati idő mentése az adatbázisba
    $stmt = $conn->prepare("UPDATE users SET password_reset_token = ?, password_reset_expires = ? WHERE id = ?");
    $stmt->bind_param("ssi", $token, $expires, $userId);
    $stmt->execute();

    $resetLink = "http://localhost/ChatexProject/reset_password_form.php?token=$token";

    $subject = "Jelszó visszaállítás";
    $message = "Kattints a következő linkre a jelszó visszaállításához: $resetLink";
    $headers = "From: no-reply@chatex.com\r\nContent-Type: text/plain; charset=UTF-8";

    if (mail($email, $subject, $message, $headers)) {
        echo json_encode(["success" => true, "message" => "Helyreállító e-mail elküldve."]);
    } else {
        echo json_encode(["success" => false, "message" => "E-mail küldése sikertelen."]);
    }
} else {
    // Ha az e-mail nem létezik az adatbázisban, hibaüzenetet küldünk
    echo json_encode(["success" => false, "message" => "Ez az e-mail nincs regisztrálva."]);
}

$stmt->close();
$conn->close();
