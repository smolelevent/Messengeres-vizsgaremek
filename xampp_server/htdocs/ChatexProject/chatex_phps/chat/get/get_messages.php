<?php

require __DIR__ . '/../../db.php';

$data = json_decode(file_get_contents("php://input"), true);
$chatId = intval($data['chat_id']);

$query = $conn->prepare("SELECT sender_id, message_text, sent_at FROM messages WHERE chat_id = ? ORDER BY sent_at ASC");
$query->bind_param("i", $chatId);
$query->execute();
$result = $query->get_result();

$messages = [];
while ($row = $result->fetch_assoc()) {
    $messages[] = $row;
}

echo json_encode(["messages" => $messages]);
