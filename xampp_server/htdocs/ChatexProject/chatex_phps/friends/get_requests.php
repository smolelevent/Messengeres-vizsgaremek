<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../db.php";

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['user_id'])) {
    echo json_encode(["error" => "Hiányzó user_id"]);
    http_response_code(400);
    exit();
}

$user_id = intval($data['user_id']);

$sql =
    // "SELECT u.username, u.profile_picture 
    //         FROM friend_requests fr
    //         JOIN users u ON fr.sender_id = u.id
    //         WHERE fr.receiver_id = ? AND fr.status = 'pending'";

    "SELECT username, profile_picture FROM users JOIN friend_requests ON friend_requests.sender_id = users.id WHERE friend_requests.receiver_id = ? AND friend_requests.status = 'pending'";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$requests = [];
while ($row = $result->fetch_assoc()) {
    $requests[] = [
        "username" => $row["username"],
        "profile_picture" => $row["profile_picture"] ?? null
    ];
}

echo json_encode(["requests" => $requests]);
