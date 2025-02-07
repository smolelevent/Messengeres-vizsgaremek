<?php
require 'db.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST['email'];
    $password = $_POST['password'];

    $stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if ($user && password_verify($password, $user["password_hash"])) {
        echo json_encode(["message" => "Sikeres bejelentkezés!", "user_id" => $user["id"]]);
    } else {
        echo json_encode(["error" => "Hibás bejelentkezési adatok!"]);
    }
}
?>