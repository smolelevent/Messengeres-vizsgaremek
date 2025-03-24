<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php";

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["request_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó adat!"]);
    exit;
}

$request_id = intval($data["request_id"]);

// 1. Lekérjük az adott requesthez tartozó user_id-ket
$query = "SELECT sender_id, receiver_id FROM friend_requests WHERE id = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $request_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(["success" => false, "message" => "Nincs ilyen kérés!"]);
    exit;
}

$row = $result->fetch_assoc();
$user1 = $row["receiver_id"]; // aki elfogadja
$user2 = $row["sender_id"];   // aki küldte

// 2. Kétirányú beszúrás a friends táblába
$insertQuery = "INSERT INTO friends (user_id, friend_id, created_at) VALUES (?, ?, NOW()), (?, ?, NOW())";
$insertStmt = $conn->prepare($insertQuery);
$insertStmt->bind_param("iiii", $user1, $user2, $user2, $user1);
$insertSuccess = $insertStmt->execute();

if (!$insertSuccess) {
    echo json_encode(["success" => false, "message" => "Nem sikerült felvenni barátnak."]);
    exit;
}

// 3. Töröljük a kérés rekordot
$deleteQuery = "DELETE FROM friend_requests WHERE id = ?";
$deleteStmt = $conn->prepare($deleteQuery);
$deleteStmt->bind_param("i", $request_id);
$deleteSuccess = $deleteStmt->execute();

if ($deleteSuccess) {
    echo json_encode(["success" => true, "message" => "Barátság létrejött!"]);
} else {
    echo json_encode(["success" => false, "message" => "Barát hozzáadva, de nem sikerült törölni a kérést."]);
}
