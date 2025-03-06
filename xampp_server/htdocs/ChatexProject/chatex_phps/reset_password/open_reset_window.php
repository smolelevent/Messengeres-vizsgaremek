<?php
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
        window.onload = function() {
            let width = 502;
            let height = 458;

            // Középre helyezés Full HD képernyőn (1920x1080)
            let left = (screen.width - width) / 2;
            let top = (screen.height - height) / 2;

            let url = "reset_password_form.php?token=<?php echo htmlspecialchars($token); ?>";
            // Új ablak megnyitása középen
            window.open(url, "JelszóVisszaállítás", `width=${width},height=${height},left=${left},top=${top},scrollbars=no,resizable=no`);
            window.close(); // A közvetítő oldalt bezárja
        };
    </script>
</head>

<body>
    <p>Ha az új ablak nem nyílt meg, <a href="reset_password_form.php?token=<?php echo htmlspecialchars($token); ?>" target="_blank">kattints ide</a>.</p>
</body>

</html>