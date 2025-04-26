<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php";

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['email']) || !isset($data['user_id'])) {
    echo json_encode(["status" => "error", "message" => "Hiányzó adatok"]);
    exit();
}

$user_id = intval($data['user_id']);
$email = trim($data['email']);

// Email validálás PHP oldalon is!
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode([
        "status" => "error",
        "message" => "Érvénytelen email formátum!"
    ]);
    exit();
}

// Adatbázis frissítés
$stmt = $conn->prepare("UPDATE users SET email = ? WHERE id = ?");
$stmt->bind_param("si", $email, $user_id);

if ($stmt->execute()) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Nem sikerült frissíteni az email címet!"
    ]);
}
