<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php";

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["user_id"]) || !isset($data["friend_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó paraméterek!"]);
    exit;
}

$user_id = intval($data["user_id"]);
$friend_id = intval($data["friend_id"]); // Akinek küldeni szeretné a jelölést

// Barátjelölés mentése a `friend_requests` táblába (pending státusz)
$query = "INSERT INTO friend_requests (sender_id, receiver_id, status, created_at) VALUES (?, ?, 'pending', NOW())";
$stmt = $conn->prepare($query);
$stmt->bind_param("ii", $user_id, $friend_id);

if ($stmt->execute()) {
    echo json_encode([
        "success" => true,
        "message" => "Barátjelölés elküldve!"
    ]);
} else {
    echo json_encode(["success" => false, "message" => "Hiba történt a barátjelölés során!"]);
}

$stmt->close();
$conn->close();
