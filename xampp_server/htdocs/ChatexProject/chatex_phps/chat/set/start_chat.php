<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php";

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["sender_id"]) || !isset($data["receiver_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó adatok!"]);
    exit;
}

$senderId = intval($data["sender_id"]);
$receiverId = intval($data["receiver_id"]);

// Ha nem létezik, létrehozzuk
$insertChat = $conn->prepare("INSERT INTO chats (is_group) VALUES (0)");
$insertChat->execute();
$chatId = $conn->insert_id;

// Két tag hozzáadása
$insertMember = $conn->prepare("INSERT INTO chat_members (chat_id, user_id) VALUES (?, ?)");
$insertMember->bind_param("ii", $chatId, $senderId);
$insertMember->execute();

$insertMember->bind_param("ii", $chatId, $receiverId);
$insertMember->execute();

$friendQuery = $conn->prepare("SELECT username, profile_picture, status, signed_in, last_seen FROM users WHERE id = ?");
$friendQuery->bind_param("i", $receiverId);
$friendQuery->execute();
$friendResult = $friendQuery->get_result();
$friendData = $friendResult->fetch_assoc();


echo json_encode([
    "success" => true,
    "message" => "Chat létrehozva!",
    "chat_id" => $chatId,
    "friend_name" => $friendData["username"],
    "friend_profile_picture" => $friendData["profile_picture"],
    "status" => $friendData["status"],
    "signed_in" => $friendData["signed_in"],
    "last_seen" => $friendData["last_seen"],
]);
