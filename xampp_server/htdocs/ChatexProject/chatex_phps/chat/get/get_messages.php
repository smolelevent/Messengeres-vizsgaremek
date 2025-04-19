<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . '/../../db.php';

$data = json_decode(file_get_contents("php://input"), true);
$chatId = intval($data['chat_id']);

$query = $conn->prepare("SELECT * FROM messages WHERE chat_id = ? ORDER BY sent_at ASC");
$query->bind_param("i", $chatId);
$query->execute();
$result = $query->get_result();

$messages = [];

while ($row = $result->fetch_assoc()) {
    $messageId = intval($row['message_id']);

    $attachmentQuery = $conn->prepare("SELECT file_name, download_url, file_type FROM message_attachments WHERE message_id = ?");
    $attachmentQuery->bind_param("i", $messageId);
    $attachmentQuery->execute();
    $attachmentResult = $attachmentQuery->get_result();

    $attachments = [];
    while ($attachment = $attachmentResult->fetch_assoc()) {
        $attachments[] = $attachment;
    }

    if (isset($row['message_text']) && trim($row['message_text']) === '') {
        $row['message_text'] = null;
    }

    $row['attachments'] = $attachments;

    // // 📌 Típus besorolása előző mentés
    // if (!empty($row['message_text'])) {
    //     $row['message_type'] = 'text';
    // } elseif (!empty($attachments)) {
    //     $firstType = $attachments[0]['file_type'] ?? 'file';
    //     $row['message_type'] = $firstType === 'image' ? 'image' : 'file';
    // } else {
    //     $row['message_type'] = 'text';
    // }

    $hasText = !empty($row['message_text']);
    $hasAttachments = !empty($attachments);

    if ($hasAttachments) {
        $firstType = $attachments[0]['file_type'] ?? 'file';
        $row['message_type'] = $firstType === 'image' ? 'image' : 'file';
    } elseif ($hasText) {
        $row['message_type'] = 'text';
    } else {
        $row['message_type'] = 'text'; // fallback, ha se szöveg, se csatolmány nincs
    }

    $messages[] = $row;
}

echo json_encode(["messages" => $messages]);
