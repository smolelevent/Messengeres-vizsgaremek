<?php
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Ellenőrizzük, hogy az összes szükséges adat megérkezett-e
    if (isset($_POST['username']) && isset($_POST['email']) && isset($_POST['password'])) {
        $username = $_POST['username'];
        $email = $_POST['email'];
        $password = password_hash($_POST['password'], PASSWORD_BCRYPT);

        $stmt = $pdo->prepare("INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)");
        if ($stmt->execute([$username, $email, $password])) {
            echo json_encode(["message" => "Sikeres regisztráció!"]);
        } else {
            echo json_encode(["error" => "Hiba történt a regisztráció során."]);
        }

        // Itt elvégezheted az adatfeldolgozást, például a regisztrációt

        echo json_encode(["success" => true, "message" => "Sikerült"]);
    } else {
        // Ha valami adat hiányzik
        echo json_encode(["success" => false, "message" => "Hiányzó adatok!"]);
    }
} else {
    // Ha nem POST a kérés
    echo json_encode(["success" => false, "message" => "Nem megfelelő kérés"]);
}
?>



// require 'db.php';
// //header("Content-Type: application/json");
// if ($_SERVER["REQUEST_METHOD"] == "POST") {
// $username = $_POST['username'];
// $email = $_POST['email'];
// $password = password_hash($_POST['password'], PASSWORD_BCRYPT);

// $stmt = $pdo->prepare("INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)");
// if ($stmt->execute([$username, $email, $password])) {
// echo json_encode(["message" => "Sikeres regisztráció!"]);
// } else {
// echo json_encode(["error" => "Hiba történt a regisztráció során."]);
// }
// }
// echo "Sikerült";
?>