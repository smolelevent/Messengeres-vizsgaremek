<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
include '../db.php';

$data = json_decode(file_get_contents("php://input"), true);
$username = $data['username'];

$stmt = $pdo->prepare("UPDATE users SET username = ? WHERE id = ?");
$stmt->execute([$username, $user_id]);

echo json_encode(["status" => "success"]);
