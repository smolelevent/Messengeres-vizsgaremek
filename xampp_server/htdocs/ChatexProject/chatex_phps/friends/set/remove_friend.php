<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php";

$data = json_decode(file_get_contents("php://input"), true);

// Ellenőrzés, hogy a szükséges adatok megvannak-e
if (!isset($data["user_id"], $data["friend_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó adatok!"]);
    exit;
}

$user_id = $data["user_id"];
$friend_id = $data["friend_id"];

// A kapcsolat törlése bármely irányban
$query = "DELETE FROM friends 
          WHERE (user_id = ? AND friend_id = ?) 
             OR (user_id = ? AND friend_id = ?)";

$stmt = $conn->prepare($query);
$stmt->bind_param("iiii", $user_id, $friend_id, $friend_id, $user_id);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Barát törölve!"]);
} else {
    echo json_encode(["success" => false, "message" => "Hiba a törlés közben!"]);
}
