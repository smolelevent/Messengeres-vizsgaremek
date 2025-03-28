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
$receiverIds = $data["receiver_ids"]; // Tömb

if (!is_array($receiverIds) || count($receiverIds) === 0) {
    echo json_encode(["success" => false, "message" => "Nem megfelelő címzettek!"]);
    exit;
}

$isGroup = count($receiverIds) >= 2 ? 1 : 0;
$chatId = null;

if ($isGroup === 0) {
    // 👥 Privát chat: létezik-e már ilyen páros?
    $receiverId = intval($receiverIds[0]);

    $query = "
        SELECT c.chat_id
        FROM chats c
        JOIN chat_members cm1 ON c.chat_id = cm1.chat_id AND cm1.user_id = ?
        JOIN chat_members cm2 ON c.chat_id = cm2.chat_id AND cm2.user_id = ?
        WHERE c.is_group = 0
        GROUP BY c.chat_id
        HAVING COUNT(DISTINCT cm1.user_id) = 1 AND COUNT(DISTINCT cm2.user_id) = 1
    ";

    $stmt = $conn->prepare($query);
    $stmt->bind_param("ii", $senderId, $receiverId);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        echo json_encode(["success" => true, "message" => "Már létező chat", "chat_id" => $row["chat_id"]]);
        exit;
    }
}

// 💬 Új chat létrehozása
$groupName = $isGroup ? $data["group_name"] ?? "Új csoport" : null;
$groupImage = $isGroup ? $data["group_profile_picture"] ?? null : null;

$insertChat = $conn->prepare("INSERT INTO chats (is_group, group_name, group_profile_picture) VALUES (?, ?, ?)");
$insertChat->bind_param("iss", $isGroup, $groupName, $groupImage);
$insertChat->execute();
$chatId = $conn->insert_id;

// 📥 Tagok hozzáadása
$members = array_merge([$senderId], $receiverIds);

$insertMember = $conn->prepare("INSERT INTO chat_members (chat_id, user_id) VALUES (?, ?)");
foreach ($members as $memberId) {
    $insertMember->bind_param("ii", $chatId, $memberId);
    $insertMember->execute();
}

echo json_encode(["success" => true, "message" => "Chat létrehozva!", "chat_id" => $chatId]);
