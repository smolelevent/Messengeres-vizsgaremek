<?php
require_once __DIR__ . '/../../db.php';

$data = json_decode(file_get_contents("php://input"), true);
$chatId = intval($data["chat_id"]);
$userId = intval($data["user_id"]);

$stmt = $conn->prepare("
    UPDATE messages
    SET is_read = 1
    WHERE chat_id = ? AND receiver_id = ? AND is_read = 0
");
$stmt->bind_param("ii", $chatId, $userId);
$stmt->execute();

echo json_encode(["success" => true]);
