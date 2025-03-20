<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../db.php";

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["user_id"]) || !isset($data["friend_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó paraméterek!"]);
    exit;
}

$user_id = intval($data["user_id"]); // Jelenlegi felhasználó ID-ja
$friend_id = intval($data["friend_id"]); // Akinek küldeni szeretné a jelölést

// Nem küldhetünk magunknak barátkérést!
if ($user_id === $friend_id) {
    echo json_encode(["success" => false, "message" => "Saját magadat nem jelölheted be!"]);
    exit;
}

// Ellenőrizzük, hogy létezik-e mindkét felhasználó a `users` táblában
$query = "SELECT id FROM users WHERE id IN (?, ?)";
$stmt = $conn->prepare($query);
$stmt->bind_param("ii", $user_id, $friend_id);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows < 2) {
    echo json_encode(["success" => false, "message" => "Felhasználó nem található!"]);
    exit;
}

// Ellenőrizzük, hogy már barátok-e
$query = "SELECT * FROM friends WHERE (user_id = ? AND friend_id = ?) OR (user_id = ? AND friend_id = ?)";
$stmt = $conn->prepare($query);
$stmt->bind_param("iiii", $user_id, $friend_id, $friend_id, $user_id);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    echo json_encode(["success" => false, "message" => "Már barátok vagytok!"]);
    exit;
}

// Ellenőrizzük, hogy van-e már függőben lévő kérelem
$query = "SELECT * FROM friend_requests WHERE sender_id = ? AND receiver_id = ? AND status = 'pending'";
$stmt = $conn->prepare($query);
$stmt->bind_param("ii", $user_id, $friend_id);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    echo json_encode(["success" => false, "message" => "Már küldtél barátjelölést!"]);
    exit;
}

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
