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
        c.group_name,
        c.group_profile_picture,
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
    WHERE cm.user_id = ? AND c.is_group = 1
    ORDER BY last_message_time DESC
";

$stmt = $conn->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$chatList = [];

while ($row = $result->fetch_assoc()) {
    $chatList[] = $row;
}

echo json_encode($chatList);
