<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include '../db.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['profile_picture']) || !isset($data['user_id'])) {
    echo json_encode(["status" => "error", "message" => "Hiányzó adatok"]);
    exit();
}

$profile_picture = $data['profile_picture'];
$user_id = intval($data['user_id']); // Biztonságos integer konverzió

$query = "UPDATE users SET profile_picture = ? WHERE id = ?";
$stmt = $conn->prepare($query);

if ($stmt) {
    $stmt->bind_param("si", $profile_picture, $user_id);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Profilkép frissítve"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Hiba a frissítés során"]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Adatbázis hiba"]);
}

$conn->close();
