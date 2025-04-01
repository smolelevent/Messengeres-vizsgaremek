<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../db.php";

function normalizeEmail($email) //TODO: letesztelni hogy működik e egyáltalán
{
    // Gmail esetén: a pontokat és a + utáni részt eltávolítjuk
    if (strpos($email, '@gmail.com') !== false) {
        $emailParts = explode('@', $email);
        $localPart = str_replace('.', '', $emailParts[0]); // Pontok eltávolítása
        $localPart = explode('+', $localPart)[0]; // + utáni rész eltávolítása
        return $localPart . '@gmail.com';
    }
    return $email; // Más e-mail szolgáltatóknál nincs változás
}

$userData = json_decode(file_get_contents("php://input"), true);

$username = trim($userData['username']);
$email = normalizeEmail(trim($userData['email']));
$password = trim($userData['password']);
$password_hash = password_hash($password, PASSWORD_DEFAULT);
$language = $userData['language'];

// Ellenőrizzük, hogy az e-mail formátuma helyes-e
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400); // Hibás kérés
    echo json_encode(["message" => "Érvénytelen email cím!"]);
    exit();
}

$checkStmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$checkStmt->bind_param("s", $email);
$checkStmt->execute();
$checkStmt->store_result();

if ($checkStmt->num_rows > 0) {
    http_response_code(409); // Konfliktus
    echo json_encode(["message" => "Ezzel az emailel már létezik felhasználó!"]);
    exit();
}

$stmt = $conn->prepare("INSERT INTO users (preferred_lang, username, email, password_hash, created_at) VALUES (?, ?, ?, ?, NOW())");
if ($stmt === false) {
    http_response_code(500); // Belső szerverhiba
    echo json_encode(["message" => "SQL előkészítési hiba."]);
    exit();
}

$stmt->bind_param("ssss", $language, $username, $email, $password_hash);

if ($stmt->execute()) {
    http_response_code(201); // Erőforrás létrehozva
    echo json_encode([
        "message" => "Sikeres regisztráció!",
        "username" => $username,
        "email" => $email,
        "password_hash" => $password_hash,
        "preferred_lang" => $language
    ]);
} else {
    http_response_code(500); // Belső szerverhiba
    echo json_encode(["message" => "Sikertelen regisztráció!"]);
}

$stmt->close();
$conn->close();
