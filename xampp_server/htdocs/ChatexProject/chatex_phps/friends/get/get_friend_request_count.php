<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php";

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["user_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó felhasználói azonosító!"]);
    exit;
}

$user_id = intval($data["user_id"]);

// Függőben lévő barátjelölések számolása
$query = "SELECT COUNT(*) AS count FROM friend_requests WHERE receiver_id = ? AND status = 'pending'";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result()->fetch_assoc();

echo json_encode(["success" => true, "count" => $result["count"]]);

$stmt->close();
$conn->close();
