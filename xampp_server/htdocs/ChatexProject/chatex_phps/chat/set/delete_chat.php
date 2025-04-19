<?php
require_once __DIR__ . '/../../db.php';

$data = json_decode(file_get_contents("php://input"), true);
$chatId = intval($data['chat_id']);
$userId = intval($data['user_id']);

// Ellenőrizzük, hogy a user benne van-e a chatben
$stmt = $conn->prepare("SELECT COUNT(*) as cnt FROM chat_members WHERE chat_id = ? AND user_id = ?");
$stmt->bind_param("ii", $chatId, $userId);
$stmt->execute();
$result = $stmt->get_result()->fetch_assoc();

if ($result['cnt'] == 0) { //ha nincs egyetlen olyan rekord ahol a megadott adatok szerepelnek
    echo json_encode(["success" => false, "error" => "Nincs jogosultságod törölni ezt a chatet."]);
    exit;
}

$stmt = $conn->prepare("DELETE FROM chats WHERE chat_id = ?");
$stmt->bind_param("i", $chatId);
$success = $stmt->execute();

echo json_encode(["success" => $success]);
