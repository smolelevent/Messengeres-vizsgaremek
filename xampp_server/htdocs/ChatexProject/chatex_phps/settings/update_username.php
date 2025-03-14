<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include '../db.php'; // Az adatbázis kapcsolatot biztosító fájl

// JSON adatok beolvasása
$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['username']) || !isset($data['user_id'])) {
    echo json_encode(["status" => "error", "message" => "Hiányzó adatok"]);
    exit();
}

$username = trim($data['username']); // Felhasználónév megtisztítása
$user_id = intval($data['user_id']); // Biztonságos integer konverzió

// Adatbázis lekérdezés előkészítése és végrehajtása
$query = "UPDATE users SET username = ? WHERE id = ?";
$stmt = $conn->prepare($query);

if ($stmt) {
    $stmt->bind_param("si", $username, $user_id);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Felhasználónév frissítve"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Hiba a frissítés során"]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Adatbázis hiba"]);
}

$conn->close();
