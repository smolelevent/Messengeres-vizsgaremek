<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . '/../db.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["user_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó felhasználói ID"]);
    exit();
}

$userId = $data["user_id"];

$stmt = $conn->prepare("SELECT username, profile_picture FROM users WHERE id = ?");
$stmt->bind_param("i", $userId);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    echo json_encode([
        "success" => true,
        "username" => $user["username"],
        "profile_picture" => $user["profile_picture"] ?: "http://10.0.2.2/ChatexProject/profile_pictures/skibidi_joszeff.jpg"
    ]);
} else {
    echo json_encode(["success" => false, "message" => "Felhasználó nem található."]);
}

$stmt->close();
$conn->close();
