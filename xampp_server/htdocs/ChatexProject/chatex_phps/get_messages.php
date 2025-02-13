<?php
require 'db.php';

$sender_id = $_GET['sender_id'];
$receiver_id = $_GET['receiver_id'];

$stmt = $pdo->prepare("SELECT * FROM messages WHERE (sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?) ORDER BY sent_at ASC");
$stmt->execute([$sender_id, $receiver_id, $receiver_id, $sender_id]);

$messages = $stmt->fetchAll();
echo json_encode($messages);
?>