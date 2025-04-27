<?php
//ez a php fájl építi fel a jelszó helyreállításhoz továbbító html-t amit az emailben küldtünk a felhasználónak!

//bekéri a felhasználó tokenjét (15 percig érvényes) és ha nem az akkor egyből visszatér egy string-el!
$token = $_GET['token'] ?? '';
if (!$token) {
    die("Érvénytelen token.");
}
?>

<!DOCTYPE html>
<html lang="hu">

<head>
    <meta charset="UTF-8">
    <title>Jelszó visszaállítása</title>
    <script>
        //alapszintű JavaScript alkalmazása
        //FONTOS, HA A FELHASZNÁLÓNAK LE VAN TILTVA A FELUGRÓ ABLAK AKKOR NEM FOG MEGJELENNI!
        window.onload = function() {
            //ennyit vonunk ki a képernyőből hogy középre legyen igazítva (sajnos csak Full HD-n)
            let width = 502;
            let height = 458;

            //középre helyezés Full HD képernyőn (1920x1080)
            let left = (screen.width - width) / 2;
            let top = (screen.height - height) / 2;

            //url a tényleges jelszó helyreállításhoz, mivel ez az oldal csak egy átírányító oldal, ami csak egy pillanatig jelenik meg!
            let url = "reset_password_form.php?token=<?php echo htmlspecialchars($token); ?>";

            //Új ablak megnyitása középen
            window.open(url, "JelszóVisszaállítás", `width=${width},height=${height},left=${left},top=${top},scrollbars=no,resizable=no`);
            window.close(); //A közvetítő oldalt bezárja
        };
    </script>
</head>

<body>
    <!-- Ezt fogja kiírni a közvetítő oldal, ha nem tudta megjeleníteni az átírányítással az oldalt! -->
    <p>Ha az új ablak nem nyílt meg, <a href="reset_password_form.php?token=<?php echo htmlspecialchars($token); ?>" target="_blank">kattints ide</a>.</p>
</body>

</html>