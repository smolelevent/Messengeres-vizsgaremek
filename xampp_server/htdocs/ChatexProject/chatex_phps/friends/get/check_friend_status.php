<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php";

$data = json_decode(file_get_contents("php://input"), true);

$user_id = intval($data["user_id"]);
$friend_id = intval($data["friend_id"]);

$query = "SELECT * FROM friends WHERE (user_id = ? AND friend_id = ?) OR (user_id = ? AND friend_id = ?)";
$stmt = $conn->prepare($query);
$stmt->bind_param("iiii", $user_id, $friend_id, $friend_id, $user_id);
$stmt->execute();

$result = $stmt->get_result();
if ($result->num_rows > 0) {
    echo json_encode(["success" => true, "message" => "already_friends"]);
    exit;
}

$query = "SELECT * FROM friend_requests WHERE ((sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)) AND status = 'pending'";
$stmt = $conn->prepare($query);
$stmt->bind_param("iiii", $user_id, $friend_id, $friend_id, $user_id);
$stmt->execute();

$result = $stmt->get_result();
if ($result->num_rows > 0) {
    echo json_encode(["success" => true, "message" => "pending_request"]);
    exit;
}

echo json_encode(["success" => true, "message" => "can_send"]);
