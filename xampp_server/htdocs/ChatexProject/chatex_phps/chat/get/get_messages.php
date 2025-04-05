<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . '/../../db.php';

$data = json_decode(file_get_contents("php://input"), true);
$chatId = intval($data['chat_id']);

$query = $conn->prepare("SELECT chat_id, sender_id, receiver_id, message_text, sent_at FROM messages WHERE chat_id = ? ORDER BY sent_at ASC");
$query->bind_param("i", $chatId);
$query->execute();
$result = $query->get_result();

$messages = [];
while ($row = $result->fetch_assoc()) {
    $messages[] = $row;
}

echo json_encode(["messages" => $messages]);
