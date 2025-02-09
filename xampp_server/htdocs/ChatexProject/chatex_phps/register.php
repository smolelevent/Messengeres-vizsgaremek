<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Adatbázis kapcsolódási adatok
$servername = "localhost";
$username = "root"; // Alapértelmezett felhasználónév
$password = ""; // Alapértelmezett jelszó
$dbname = "dbchatex";

// Kapcsolódás az adatbázishoz
$conn = new mysqli($servername, $username, $password, $dbname);

// Kapcsolódási hiba ellenőrzése
if ($conn->connect_error) {
    die(json_encode(array("message" => "Connection failed: " . $conn->connect_error)));
}

// JSON adatok fogadása
$data = json_decode(file_get_contents("php://input"));

// Hibakezelés, ha a bejövő adatok érvénytelenek
if ($data === null || !isset($data->username) || !isset($data->email) || !isset($data->password)) {
    http_response_code(400); // Bad Request
    echo json_encode(array("message" => "Invalid input data."));
    exit();
}

// Adatok kinyerése
$username = $data->username;
$email = $data->email;
$password = $data->password;

// Jelszó hashelése
$password_hash = password_hash($password, PASSWORD_DEFAULT);

// SQL lekérdezés előkészítése
$stmt = $conn->prepare("INSERT INTO users (username, email, password_hash, created_at) VALUES (?, ?, ?, NOW())");
if ($stmt === false) {
    http_response_code(500); // Internal Server Error
    echo json_encode(array("message" => "Failed to prepare SQL statement."));
    exit();
}

$stmt->bind_param("sss", $username, $email, $password_hash);

// Lekérdezés végrehajtása és válasz küldése
if ($stmt->execute()) {
    echo json_encode(array("message" => "User registered successfully."));
} else {
    http_response_code(500); // Internal Server Error
    echo json_encode(array("message" => "User registration failed."));
}

// Kapcsolat bezárása
$stmt->close();
$conn->close();
