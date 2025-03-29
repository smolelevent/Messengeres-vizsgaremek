<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . '/../db.php';
require_once __DIR__ . '/../vendor/autoload.php';

use Firebase\JWT\JWT;

$userData = json_decode(file_get_contents("php://input"), true);

$email = trim($userData['email']);
$password = trim($userData['password']);

$stmt = $conn->prepare("SELECT id, preferred_lang, profile_picture, username, email, password_hash FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();

$result = $stmt->get_result();

$user = $result->fetch_assoc();

if (!$user || !password_verify($password, $user["password_hash"])) {
    http_response_code(401); // 401 = Unauthorized
    echo json_encode(["message" => "Hibás email vagy jelszó!"]);
    exit();
}

$conn->query("UPDATE users SET is_online = 1, last_seen = NOW() WHERE id = " . intval($user['id']));

// JWT token létrehozása
$issued_at = time();
$expiration_time = $issued_at + (60 * 60 * 24); // 24 óra
$payload = [
    "iat" => $issued_at,
    "exp" => $expiration_time,
    "id" => $user["id"],
    "preferred_lang" => $user["preferred_lang"],
    "profile_picture" => $user["profile_picture"],
    "username" => $user["username"],
    "email" => $user["email"],
    "password_hash" => $user["password_hash"]
];

$secret_key = "chatex";

$jwt = JWT::encode($payload, $secret_key, 'HS256');

http_response_code(200); // 200 = OK 
echo json_encode([
    "message" => "Sikeres bejelentkezés",
    "success" => true,
    "token" => $jwt,
    "id" => $user["id"],
    "preferred_lang" => $user["preferred_lang"],
    "profile_picture" => trim($user["profile_picture"], "'\""),
    "username" => $user["username"],
    "email" => $user["email"],
    "password_hash" => $user["password_hash"]
]);

$stmt->close();
$conn->close();
