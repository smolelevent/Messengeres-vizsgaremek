<?php
require '../db_connect.php';

$data = json_decode(file_get_contents("php://input"));

$user_id = $data->user_id ?? null;

if (!$user_id) {
    echo json_encode(["success" => false, "error" => "Missing user ID"]);
    exit;
}

$query = "SELECT f.id, u.username, u.profile_picture
          FROM friends f
          JOIN users u ON (u.id = f.friend_id OR u.id = f.user_id)
          WHERE (f.user_id = ? OR f.friend_id = ?) AND u.id != ?";

$stmt = $conn->prepare($query);
$stmt->bind_param("iii", $user_id, $user_id, $user_id);
$stmt->execute();
$result = $stmt->get_result();

$friends = [];
while ($row = $result->fetch_assoc()) {
    $friends[] = $row;
}

echo json_encode(["success" => true, "friends" => $friends]);
?>
