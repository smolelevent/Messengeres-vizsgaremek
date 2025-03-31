<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . '/../vendor/autoload.php';
require_once __DIR__ . '/../db.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

$data = json_decode(file_get_contents("php://input"), true);
$token = $data["token"] ?? "";

if (!$token) {
    echo json_encode(["success" => false, "message" => "Hiányzó token!"]);
    exit;
}

$secret_key = "chatex";

try {
    $decoded = JWT::decode($token, new Key($secret_key, 'HS256'));
    // Ha itt vagyunk, a token érvényes
    echo json_encode([
        "success" => true,
        "id" => $decoded->id,
        "preferred_lang" => $decoded->preferred_lang,
        "profile_picture" => $decoded->profile_picture,
        "username" => $decoded->username,
        "email" => $decoded->email,
        "password_hash" => $decoded->password_hash
    ]);
} catch (Exception $e) {
    echo json_encode(["success" => false, "message" => "Érvénytelen token: " . $e->getMessage()]);
}
