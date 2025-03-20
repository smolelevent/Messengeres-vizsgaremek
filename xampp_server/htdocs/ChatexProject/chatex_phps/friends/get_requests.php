<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../db.php";

// Ellenőrizzük a felhasználó azonosítóját
$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["user_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó paraméter!"]);
    exit;
}

$user_id = intval($data["user_id"]); // Bejelentkezett felhasználó ID-ja

// Lekérdezzük az összes függőben lévő barátjelölést
$query = "
    SELECT fr.id, u.username, u.profile_picture, fr.sender_id 
    FROM friend_requests fr
    JOIN users u ON fr.sender_id = u.id
    WHERE fr.receiver_id = ? AND fr.status = 'pending'
";

$stmt = $conn->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$friendRequests = [];
while ($row = $result->fetch_assoc()) {
    $friendRequests[] = $row;
}

echo json_encode([
    "success" => true,
    "requests" => $friendRequests,
]);

$stmt->close();
$conn->close();
