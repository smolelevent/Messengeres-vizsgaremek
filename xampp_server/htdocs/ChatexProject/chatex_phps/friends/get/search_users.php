<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php";

$data = json_decode(file_get_contents("php://input"), true);

if ($data['query'] == " ") {
    echo json_encode(["error" => "Hibás lekérdezés!"]);
    http_response_code(400);
    exit();
}

$query = "%" . $conn->real_escape_string($data['query']) . "%";

$sql = "SELECT id, username, profile_picture FROM users WHERE username LIKE ? LIMIT 10"; //limit 10 nem kell inkább scrollable, id se kell
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $query);
$stmt->execute();
$result = $stmt->get_result();

$users = [];
while ($row = $result->fetch_assoc()) {
    $users[] = [
        "id" => $row["id"],
        "username" => $row["username"],
        "profile_picture" => $row["profile_picture"]
    ];
}

echo json_encode($users);
