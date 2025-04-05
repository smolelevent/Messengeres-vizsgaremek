<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php";

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["user_id"])) {
    http_response_code(400);
    echo json_encode(["error" => "Hiányzó user azonosító!"]);
    exit;
}

$user_id = intval($data["user_id"]);

$query = "
    SELECT 
        c.chat_id,
        c.is_group,
        u.id AS friend_id,
        u.username AS friend_name,
        u.profile_picture AS friend_profile_picture,
        u.last_seen AS friend_last_seen,
        u.status,
        u.signed_in,
        (
            SELECT m.message_text
            FROM messages m
            WHERE m.chat_id = c.chat_id
            ORDER BY m.sent_at DESC
            LIMIT 1
        ) AS last_message,

        (
            SELECT m.sent_at
            FROM messages m
            WHERE m.chat_id = c.chat_id
            ORDER BY m.sent_at DESC
            LIMIT 1
        ) AS last_message_time

    FROM chats c
    INNER JOIN chat_members cm ON cm.chat_id = c.chat_id
    INNER JOIN chat_members other_cm ON other_cm.chat_id = c.chat_id AND other_cm.user_id != ?
    INNER JOIN users u ON u.id = other_cm.user_id

    WHERE cm.user_id = ? AND c.is_group = 0
    ORDER BY last_message_time DESC
";

$stmt = $conn->prepare($query);
$stmt->bind_param("ii", $user_id, $user_id);
$stmt->execute();
$result = $stmt->get_result();

$chatList = [];

while ($row = $result->fetch_assoc()) {
    $chatList[] = $row;
}

echo json_encode($chatList);
