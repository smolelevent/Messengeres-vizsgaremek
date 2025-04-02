<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
require_once __DIR__ . "/../db.php";

header("Content-Type: application/json; charset=UTF-8");

$data = json_decode(file_get_contents("php://input"), true);

$userId = intval($data["user_id"]);
$newStatus = trim($data["status"]);

$allowed = ["online", "offline"];
if (!in_array($newStatus, $allowed)) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Érvénytelen státusz!"]);
    exit;
}

$stmt = $conn->prepare("UPDATE users SET status = ? WHERE id = ?");
$stmt->bind_param("si", $newStatus, $userId);
$stmt->execute();

if ($stmt->affected_rows > 0) {
    echo json_encode(["success" => true, "message" => "Státusz frissítve!"]);
} else {
    echo json_encode(["success" => false, "message" => "Nem történt változás!"]);
}

$stmt->close();
$conn->close();
