<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
include '../db.php';

$data = json_decode(file_get_contents("php://input"), true);
$profile_picture = $data['profile_picture'];

$stmt = $pdo->prepare("UPDATE users SET profile_picture = ? WHERE id = ?");
$stmt->execute([$profile_picture, $user_id]);

echo json_encode(["status" => "success"]);
