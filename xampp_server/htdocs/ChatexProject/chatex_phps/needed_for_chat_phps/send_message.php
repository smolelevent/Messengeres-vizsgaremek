<?php
require 'db.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $sender_id = $_POST['sender_id'];
    $receiver_id = $_POST['receiver_id'];
    $message = $_POST['message'];

    $stmt = $pdo->prepare("INSERT INTO messages (sender_id, receiver_id, message) VALUES (?, ?, ?)");
    if ($stmt->execute([$sender_id, $receiver_id, $message])) {
        echo json_encode(["message" => "Üzenet elküldve!"]);
    } else {
        echo json_encode(["error" => "Hiba történt!"]);
    }
}
?>