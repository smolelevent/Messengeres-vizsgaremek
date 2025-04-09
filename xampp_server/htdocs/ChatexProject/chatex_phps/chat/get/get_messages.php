<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . '/../../db.php';

$data = json_decode(file_get_contents("php://input"), true);
$chatId = intval($data['chat_id']);

$query = $conn->prepare("SELECT chat_id, sender_id, receiver_id, message_text, message_type, message_file, sent_at, is_read FROM messages WHERE chat_id = ? ORDER BY sent_at ASC");
$query->bind_param("i", $chatId);
$query->execute();
$result = $query->get_result();

$messages = [];
while ($row = $result->fetch_assoc()) {
    // Hozzáadjuk a letöltési linket
    if ($row['message_type'] === 'file') {
        $row['download_url'] = "http://10.0.2.2/ChatexProject/uploads/files/" . $row['message_file'];
    } elseif ($row['message_type'] === 'image') {
        $row['download_url'] = "http://10.0.2.2/ChatexProject/uploads/media/" . $row['message_file'];
    }

    $messages[] = $row;
}

echo json_encode(["messages" => $messages]);
