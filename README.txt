Ahhoz hogy megfelelően fusson a program ahhoz a következők kellenek:

- Android Emulator, ajánlott a legmagasabb CPU core szám, és a Hardware-es renderelés, reális Android Api verzióval (pl.: Android 14)

- XAMPP szerver ami a Messengeres-Vizsgaremek mappában található egy xampp_server mappában (érdemes File Explorelben megnyitni) majd futtatni a mappa alján található setup_xampp.bat-ot amin végig kell menni hogy frissítse a path-ot!

2. xampp-control.exe futttatása és az Apache szervert, illetve a MySQL service-t el kell indítani!!

utána már majdnem kész, annyi kell már csak hogy a preferált IDE-ben elindítani terminálon keresztűl az ezen az elérési úton található parancsot:

xampp_server\htdocs\ChatexProject\chatex_phps> php server_run.php

FONTOS: először el kell navigálni a chatex_phps mappába és utána futtatni a parancsot, és csak a XAMPP futtatása után!!!!



HA az IDE kér valami extension letöltését pl.: Dart, Flutter le kell telepíteni! és csak utána lehet futtatni a main.dart-ot akár F5-el (vs code esetében) akár a main.dart-ban szereplő Run|Debug|Profile gombok közül a Run-t!!!


Github repo letöltése: a megkapott Github repositoryt érdemes klónozni (nem letölteni zip állományban) mivel hallottam már olyanról hogy nem tartalmazott egy bizonyos .bat-ot az xampp_server!!!!!


A VIZSGÁHOZ SZÜKSÉGES CSATOLMÁNYOK:
- dump fájl (egyeb_vizsgahoz_szukseges_csatolmanyok -> adatbazis_dump mappában található)
(mind a kettő fájlt az xampp indítása után, importálni kell ha szükséges)
- mellékelve van még az xampp szerver import-ja is 127_0_0_1.sql néven 

- forráskód (Chatex mappa -> lib mappa)

- adatbázis modell diagram (egyeb_vizsgahoz_szukseges_csatolmanyok -> adatbazis_modell_diagram mappában található)

- dokumentáció (Chatex dokumentáció mappában)
- pdf formában is

- tesztekhez végzett kód (Chatex mappa -> integration_tests mappa és test mappa)

- teszteredmények dokumentációja (Chatex dokumentáció mappában)

- az alkalmazás telepítő készlete (telepito_keszlet mappában található .apk fájlformátummal)
    - flutter install paranccsal lesz telepíthető a Chatex mappán belül (terminálon keresztűl)





