<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php";

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["sender_id"]) || !isset($data["receiver_ids"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó adatok!"]);
    exit;
}

$senderId = intval($data["sender_id"]);
$receiverIds = $data["receiver_ids"];

if (!is_array($receiverIds) || count($receiverIds) != 1) {
    echo json_encode(["success" => false, "message" => "Csak egy felhasználó jelölhető ki!"]);
    exit;
}

$receiverId = intval($receiverIds[0]);

// Megnézzük, van-e már ilyen privát chat
$query = "
    SELECT c.chat_id
    FROM chats c
    JOIN chat_members cm1 ON c.chat_id = cm1.chat_id AND cm1.user_id = ?
    JOIN chat_members cm2 ON c.chat_id = cm2.chat_id AND cm2.user_id = ?
    WHERE c.is_group = 0
    GROUP BY c.chat_id
";

$stmt = $conn->prepare($query);
$stmt->bind_param("ii", $senderId, $receiverId);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode(["success" => true, "message" => "Már létezik a chat!", "chat_id" => $row["chat_id"]]);
    exit;
}

// Ha nem létezik, létrehozzuk
$insertChat = $conn->prepare("INSERT INTO chats (is_group) VALUES (0)");
$insertChat->execute();
$chatId = $conn->insert_id;

// Tagok hozzáadása
$insertMember = $conn->prepare("INSERT INTO chat_members (chat_id, user_id) VALUES (?, ?)");
foreach ([$senderId, $receiverId] as $memberId) {
    $insertMember->bind_param("ii", $chatId, $memberId);
    $insertMember->execute();
}

$friendQuery = $conn->prepare("SELECT username, profile_picture FROM users WHERE id = ?");
$friendQuery->bind_param("i", $receiverId);
$friendQuery->execute();
$friendResult = $friendQuery->get_result();
$friendData = $friendResult->fetch_assoc();


echo json_encode([
    "success" => true,
    "message" => "Chat létrehozva!",
    "chat_id" => $chatId,
    "friend_name" => $friendData["username"],
    "friend_profile_picture" => $friendData["profile_picture"]
]);
