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

$user_id = intval($data["user_id"]);
$friend_id = intval($data["friend_id"]); // Akinek küldeni szeretné a jelölést

// // Ellenőrizzük, hogy már barátok-e
// $query = "SELECT * FROM friends WHERE (user_id = ? AND friend_id = ?) OR (user_id = ? AND friend_id = ?)";
// $stmt = $conn->prepare($query);
// $stmt->bind_param("iiii", $user_id, $friend_id, $friend_id, $user_id);
// $stmt->execute();
// $friendResult = $stmt->get_result();

// if ($friendResult->num_rows > 0) { //TODO: ezt lekezelni!!
//     echo json_encode(["success" => false, "message" => "Már barátok vagytok!"]);
//     exit;
// } else {
//     echo json_encode(["success" => true, "message" => "Lehet barátkérést küldeni!"]);
// }

// // Ellenőrizzük, hogy van-e már függőben lévő kérelem
// $query = "SELECT * FROM friend_requests WHERE ((sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)) AND status = 'pending'";
// $stmt = $conn->prepare($query);
// $stmt->bind_param("iiii", $user_id, $friend_id, $friend_id, $user_id);
// $stmt->execute();
// $requestResult = $stmt->get_result();

// if ($requestResult->num_rows > 0) {
//     echo json_encode(["success" => false, "message" => "Már küldtél barátjelölést!"]);
//     exit;
// }

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

//echo json_encode(["success" => true, "message" => "Lehet barátkérést küldeni!"]);

$stmt->close();
$conn->close();
