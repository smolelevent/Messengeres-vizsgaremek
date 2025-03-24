<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php";

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["request_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó adat!"]);
    exit;
}

$request_id = intval($data["request_id"]);
$query = "DELETE FROM friend_requests WHERE id = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $request_id);
$success = $stmt->execute();

echo json_encode(["success" => $success]);
