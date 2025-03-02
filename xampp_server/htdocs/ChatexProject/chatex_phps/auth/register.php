<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../db.php"; // ../ egyszeres visszalépést tesz

//formátum stb. ellenőrzés mert ha pl.: szimuláljuk az adatokat tudjuk hol a hiba, jelszó visszaállító email küldése!

function normalizeEmail($email)
{
    // Gmail esetén: a pontokat és a + utáni részt eltávolítjuk
    if (strpos($email, '@gmail.com') !== false) {
        $emailParts = explode('@', $email);
        $localPart = str_replace('.', '', $emailParts[0]); // Pontok eltávolítása
        $localPart = explode('+', $localPart)[0]; // + utáni rész eltávolítása
        return $localPart . '@gmail.com';
    }
    return $email; // Más e-mail szolgáltatóknál nincs változás
}

// JSON adatok fogadása
$userData = json_decode(file_get_contents("php://input"), true);

if ($userData === null) {  // Ha a JSON hibás
    echo json_encode(["message" => "Hibás JSON formátum!"]);
    http_response_code(400);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405); // Metódus nem engedélyezett
    echo json_encode(["message" => "Helytelen HTTP metódus, csak POST engedélyezett."]);
    exit();
}

// Ellenőrizzük, hogy minden szükséges mező megvan-e
if (!isset($userData['username'], $userData['email'], $userData['password'])) {
    http_response_code(400); // Hibás kérés
    echo json_encode(["message" => "Hiányzó adatok! Küldd el a username, email és password mezőket."]);
    exit();
}



// Adatok kinyerése
$username = trim($userData['username']);
$email = normalizeEmail(trim($userData['email']));
$password = trim($userData['password']);
$password_hash = password_hash($password, PASSWORD_DEFAULT);

// Ellenőrizzük, hogy az e-mail formátuma helyes-e
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400); // Hibás kérés
    echo json_encode(["message" => "Érvénytelen email cím."]);
    exit();
}

// Ellenőrizzük, hogy az email cím már létezik-e az adatbázisban
$checkStmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$checkStmt->bind_param("s", $email);
$checkStmt->execute();
$checkStmt->store_result();

if ($checkStmt->num_rows > 0) {
    http_response_code(409); // Konfliktus
    echo json_encode(["message" => "Ez az email cím már foglalt."]);
    exit();
}

// Felhasználó beszúrása az adatbázisba stmt = STATEMENT (állítás)
$stmt = $conn->prepare("INSERT INTO users (username, email, password_hash, created_at) VALUES (?, ?, ?, NOW())");
if ($stmt === false) {
    http_response_code(500); // Belső szerverhiba
    echo json_encode(["message" => "SQL előkészítési hiba."]);
    exit();
}

$stmt->bind_param("sss", $username, $email, $password_hash);

// Lekérdezés végrehajtása és válasz küldése
if ($stmt->execute()) {
    http_response_code(201); // Erőforrás létrehozva
    echo json_encode(["message" => "User registered successfully."]);
} else {
    http_response_code(500); // Belső szerverhiba
    echo json_encode(["message" => "User registration failed."]);
}

$stmt->close();
$conn->close();
