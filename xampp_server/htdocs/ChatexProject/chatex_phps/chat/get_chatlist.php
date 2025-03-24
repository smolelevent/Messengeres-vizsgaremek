<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include __DIR__ . "/../db.php";

$userData = json_decode(file_get_contents("php://input"), true);

if (!isset($userData['id'])) {
    http_response_code(400);
    echo json_encode(["error" => "Hiányzó user id!"]);
    exit();
}

$user_id = intval($userData['id']); // Azonosító, szám formátumba alakítása

$query = "
    SELECT 
        u.id AS friend_id,
        u.username AS friend_name,
        u.profile_picture AS friend_profile_picture,
        m.message_text AS last_message,
        m.sent_at AS last_message_time
    FROM messages m
    JOIN users u ON 
        (m.sender_id = u.id AND m.receiver_id = ?) 
        OR (m.receiver_id = u.id AND m.sender_id = ?)
    WHERE m.sent_at = (
        SELECT MAX(m2.sent_at) 
        FROM messages m2 
        WHERE (m2.sender_id = m.sender_id AND m2.receiver_id = m.receiver_id) 
        OR (m2.sender_id = m.receiver_id AND m2.receiver_id = m.sender_id)
    )
    GROUP BY u.id
    ORDER BY last_message_time DESC";

// Előkészített lekérdezés (Prepared Statement)
$stmt = $conn->prepare($query);

if (!$stmt) {
    http_response_code(500);
    echo json_encode(["error" => "Lekérdezés előkészítési hiba: " . $conn->error]);
    exit();
}

// Paraméterek kötése és végrehajtás
$stmt->bind_param("ii", $user_id, $user_id);
$stmt->execute();

// Eredmény lekérése
$result = $stmt->get_result();
$chatList = [];

while ($row = $result->fetch_assoc()) {
    $chatList[] = $row;
}

$stmt->close();

echo json_encode($chatList);
