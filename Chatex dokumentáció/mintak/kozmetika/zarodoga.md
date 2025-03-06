# <center>SZAKDOLGOZAT</center>

<center>BUDAPESTI KOMPLEX SZAKKÉPZÉSI CENTRUM  </center>

<center>WEISS MANFRÉD SZAKGIMNÁZIUMA,  </center>

<center>SZAKKÖZÉPISKOLÁJA ÉS KOLLÉGIUMA</center>

### <center>SZELLAKOZMETIKA.HU</center>

#### <center>Készítette: Reucov Dávid szoftverfejlesztő</center>
#### <center>Témavezető: Kovács László Bálint </center>

##### <center>BUDAPEST</center>
##### <center>2023</center>

# <center>Tartalom</center>

- [TARTALOM](#tartalom)
- [BEVEZETÉS](#bevezetés)
   - [ZÁRÓDOLGOZATOM TÉMÁJA, MÉGIS MILYEN FUNKCIÓKAT FOGLAL MAGÁBA?](#záródolgozatom-témája-mégis-milyen-funkciókat-foglal-magába)
   - [MIÉRT PONT KUTYAKOZMETIKA?](#miért-pont-kutyakozmetika)
   - [MIÉRT ’SZELLAKOZMETIKA.HU’ A DOMAIN NÉV?](#miért-szellakozmetikahu-a-domain-név)
   - [KIKNEK SZÁNOM EZT A PROGRAMOT?](#kiknek-szánom-ezt-a-programot)
   - [DE MIBEN MÁSABB, MINT A TÖBBI?](#de-miben-másabb-mint-a-többi)
- [FEJLESZTŐI DOKUMENTÁCIÓ](#fejlesztői-dokumentáció)
   - [MILYEN SZOFTVEREKET HASZNÁLTAM AZ ELKÉSZÍTÉSÉHEZ?](#milyen-szoftvereket-használtam-az-elkészítéséhez)
   - [MILYEN PROGRAMOZÁSI NYELVEKET HASZNÁLTAM?](#milyen-programozási-nyelveket-használtam)
   - [FEJLESZTŐI HARDWARE / HARDVER (RÉSZLET)](#fejlesztői-hardware--hardver-részlet)
   - [AZ ADATBÁZIS](#az-adatbázis)
      - [A ‘latogatasok’ tábla](#a-latogatasok-tábla)
      - [A ‘bejelentkezesek’ tábla](#a-bejelentkezesek-tábla)
      - [A ‘felhasznalok’ tábla](#a-felhasznalok-tábla)
      - [A ‘kutya’ tábla](#a-kutya-tábla)
      - [A ‘blog’ tábla:](#a-blog-tábla)
      - [A ‘blog_komment’ tábla:](#a-blog_komment-tábla)
      - [A ‘idopont_foglalas’ tábla:](#a-idopont_foglalas-tábla)
      - [A ‘igenybevetel’ tábla:](#a-igenybevetel-tábla)
      - [A ‘szolgaltatasok’ tábla:](#a-szolgaltatasok-tábla)
      - [A ‘kepek’ tábla:](#a-kepek-tábla)
      - [A ’felhasznalok_archivum’ tábla](#a-felhasznalok_archivum-tábla)
   - [ALGORITMUSOK A WEBLAPON:](#algoritmusok-a-weblapon)
      - [Regisztráció](#regisztráció)
      - [Bejelentkezés](#bejelentkezés)
      - [Más felhasználók megtekintése](#más-felhasználók-megtekintése)
      - [Képek feltöltése](#képek-feltöltése)
   - [A WEBOLDAL DIZÁJN-JA](#a-weboldal-dizájn-ja)
   - [KAPCSOLATFELVÉTEL AZ ÜZEMELTETŐVEL](#kapcsolatfelvétel-az-üzemeltetővel)
- [TESZT DOKUMENTÁCIÓ](#teszt-dokumentáció)
   - [ÜRES PROFIL OLDAL LEZÁROLT TELEFON UTÁN](#üres-profil-oldal-lezárolt-telefon-után)
   - [ÜRES KÉPEK A GALÉRIÁBAN](#üres-képek-a-galériában)
   - [AZ IDŐPONTFOGLALÁS KIJÁTSZÁSA](#az-időpontfoglalás-kijátszása)
      - [Foglalt időpont](#foglalt-időpont)
      - [Nagyon előre tervezett időpontfoglalás](#nagyon-előre-tervezett-időpontfoglalás)
   - [FEJLESZTÉSI LEHETŐSÉGEK](#fejlesztési-lehetőségek)
- [FELHASZNÁLÓI DOKUMENTÁCIÓ](#felhasználói-dokumentáció)
   - [A WEBLAPOM CÉLJA, ÉS AMIT TE PROFITÁLHATSZ BELŐLE:](#a-weblapom-célja-és-amit-te-profitálhatsz-belőle)
   - [SZOFTVER ÉS HARDVER IGÉNY:](#szoftver-és-hardver-igény)
   - [HOGYAN TELEPÍTSD ÉS INDÍTSD EL?](#hogyan-telepítsd-és-indítsd-el)
   - [LEHETŐSÉGEID ISMERTETÉSE A WEBLAPON:](#lehetőségeid-ismertetése-a-weblapon)
   - [A KEZDŐLAP ÉS A MENÜ FEJLÉC, AVAGY A ’NAVIGÁCIÓD’](#a-kezdőlap-és-a-menü-fejléc-avagy-a-navigációd)
   - [„A KÉRT OLDAL NEM TALÁLHATÓ”](#a-kért-oldal-nem-található)
   - [DE MÉGIS HOGYAN REGISZTRÁLJ ÉS JELENTKEZZ BE?!](#de-mégis-hogyan-regisztrálj-és-jelentkezz-be)
      - [Első lépés: Regisztrálás](#első-lépés-regisztrálás)
      - [Második lépés: Bejelentkezés](#második-lépés-Bejelentkezés)
   - [A PROFIL OLDAL, MINDEN, AMI VELED KAPCSOLATOS](#a-profil-oldal-minden-ami-veled-kapcsolatos)
   - [A SAJÁT KUTYÁD / KUTYÁID HOZZÁADÁSA](#a-saját-kutyád-kutyáid-hozzáadása)
   - [ÚJ JELSZÓRA VAN SZÜKSÉG](#új-jelszóra-van-szükség)
   - [KÉPEID FELTÖLTÉSE](#képeid-feltöltése)
   - [A GALÉRIA](#a-galéria)
   - [A BLOG, KISKAPU A KÖZÖSSÉGEDHEZ](#a-blog-kiskapu-a-közösségedhez)
   - [ITT AZ IDŐ IDŐPONTOT FOGLALNOD!](#itt-az-idő-időpontot-foglalnod)
- [IRODALOMJEGYZÉK](#irodalomjegyzék)
- [ÖSSZEGZÉS](#összegzés)
- [KÖSZÖNETNYILVÁNÍTÁS](#köszönetnyilvánítás)

# BEVEZETÉS

## ZÁRÓDOLGOZATOM TÉMÁJA, MÉGIS MILYEN FUNKCIÓKAT FOGLAL MAGÁBA?

Záródolgozatnak valami életszerű weboldalra gondoltam, mint például egy kutyakozmetikát
kisegítő interakciós oldal. Hogy mit értek ezalatt? A felhasználó regisztráció után tud: időpontot
foglalni, képeket feltölteni, blog bejegyzéseket írni és azok alá megjegyzést tenni, opcionálisan
képpel és linkkel (hivatkozással egy másik weblap címre) együtt.

## MIÉRT PONT KUTYAKOZMETIKA?

Emlékeim szerint, egy derűs nyári napon, tavaly május elején, írásbeli érettségi kellős közepén
támadt egy ötletem. Elmentem sétálni a kedvenc játszóteremre, találtam egy plakátot, amin egy
kezdő friss diplomás, körülbelül 20 éves diplomás hölgy kutyákat kozmetikázott szakmai
tapasztalatért cserébe. A halogatás véget ért májusban, amikor felhívtam telefonon és elvittem
hozzá a kutyámat, majd kérdezősködött, hogy hol tanulok. Büszkén feleltem, hogy itt, a Weiss
Manfréd Technikumban, mint leendő szoftverfejlesztő, ezen hallatán megkérdezte, hogy tudok-
e neki egy weblapot készíteni, igent mondtam. Összedobtam WordPress segítségével egy
weblapot, sikeresen elkészítettem, amit kért. De legbelül, nem voltam megelégedve a
munkámmal, ha valami nagyon egyedi dizájnt / funkciót kért volna, nem tudtam volna
teljesíteni. Ezért maradtam még egy évet, hogy megtanuljam, hogyan kell használni a PHP-t és
MySQL-t a gyakorlatban, nemcsak felszínesen vagy érettségire bemagolva. Emellett érzem az
üzleti potenciált a weblapban, amit záródolgozatnak készítek. Sok kutyakozmetika van a
környéken, ahol lakom, egyiknél se láttam, hogy van-e weblap, mint elérhetőségi opció, így
elhatároztam, hogy 2023 tavaszát és nyarát diákmunka helyett így fogom tölteni.

## MIÉRT ’SZELLAKOZMETIKA.HU’ A DOMAIN NÉV?

A szakdolgozatom pár helyen hasonlít az előbb említett előző és egyben első ’projektemmel’.
Amikor a szerződést megírtuk a [szornyellakutyakozmetika.hu](szornyellakutyakozmetika.hu) weblaphoz, látványtervvel és
minden mással együtt, úgy gondoltam, hogy a sikeres weblapok, mindegy milyen célt szolgál,
rövid és frappáns domain névvel rendelkezik, első gondolatom az volt hogy le lehetne
rövidíteni ’szella’-ra (szörnyella → sz.ella pont nélkül) és a ’kutyakozmetika’ részre sincs
szükség, így is tudatva hogy ’ez nem egy a sok közül’ (akármi + kutyakozmetika.hu). Sajnos
valaki nem sokkal azelőtt hogy megvettem volna a domaint már megvette a’szella.hu’-t, ami
némi ellentmondást okozhat a leadott tématervemhez, mert ott ’szella.hu’ szerepelt.

## KIKNEK SZÁNOM EZT A PROGRAMOT?

Igazán? Mindenkinek, akinek van kutyája vagy szereti a kutyákat, legfőképpen a saját házi
kedvencét, legyen kicsi-nagy, jó-rossz, tarka-barka, idős, fiatal, az én weblapomon mindig lesz
hely mindegyik számára. Szeretném összehozni az embereket közösségekbe, blogon
írogathatunk egymásnak, és egy kényelmes interfészt adni a felhasználók és
kutyakozmetikusok kezébe, ahol életre való barátságok / kapcsolatok és üzleti lehetőségek
születhetnek.

## DE MIBEN MÁSABB, MINT A TÖBBI?

Kimondottan regisztrációhoz kötött a blog használata és a kutyakozmetikushoz való
időpontfoglalás, emellett tervezem egy webshoppal bővíteni, meg oktatási anyagokat /
kurzusokat is kiállítani, (egy engedéllyel rendelkező kutyakozmetikus szakmát oktatóval
természetesen, bankkártyás fizetéssel, a leendő weblap megrendelői igények szerint beépítve.)
De mégis kezdjük ott, hogy a legtöbb kutyakozmetikának nincs weblapja, ahogy látom
mostanság, vagy ha mégis, akkor a két végletében találhatjuk magunkat: az elit weblapok, mint
a zoldkutya.hu, dizájnban és funkcióban is remek, csak kissé lassan tölt be, erős, drága
számítógép nélkül és magas minőségű internet kapcsolat nincs sok esélye a felhasználónak /
látogatónak interakcióba lépni a weblappal. A másik véglet amikor vesznek egy olcsó tárhelyet
vagy egy ingyeneset és összetákolnak egy látogatókat elriasztóan rusnya statikus weboldalt.
Van egy harmadik opció is (ez is inkább az utóbbi véglethez tartozik szerintem): a
kutyakozmetikusok többsége, aki nem akar weblapozással egy percet sem törődni, inkább a
Facebook-hoz láncolja saját magát, nem számolva az információk biztonságával, emellett a
profilkép és a borítóképet leszámítva személyre se szabható, nincs teljes irányítás a kezükben.
Az első weblap, amit eladtam, pontosan a kettő között volt, nem volt a legszebb, kicsit dobozos,
WordPress szagú már első látásra, nem volt statikus, lehetett időpontot foglalni egy e-mail
űrlapon keresztül, de amit szándékozok bemutatni, elég magabiztosan a minőségi, már talán
elitista irányába kanyarodik.

# FEJLESZTŐI DOKUMENTÁCIÓ

## MILYEN SZOFTVEREKET HASZNÁLTAM AZ ELKÉSZÍTÉSÉHEZ?


#### Windows 10 <img src="https://www.pngitem.com/pimgs/m/34-340288_logo-windows-10-icon-hd-png-download.png" alt="Windows 10" width="50" height="50">
A Windows 10 operációs rendszert használtam a szakdolgozatom
elkészítéséhez, egyrészt mert ezt az operációs rendszert ismerem a legjobban.
Már kiskorom óta a Windows 7-et ismerem és a mai napig szeretem.

#### Visual Studio Code <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnoirCtiJhhN8Tvo0FJRRd4CInsOXkRX9EbA&s" alt="VS Code" width="50" height="50">
Nagyon felkapott kódszerkesztő, sokak kedvence. Egész végig ezt a
kódszerkesztőt használtam, telis-tele van remek billentyűzet kombinációkkal,
JavaScriptben segített egyes sorokat helyettem befejezni, sok extension /
kiegészítő könnyítette meg a kód írást.

#### XAMPP / MySQL <img src="https://upload.wikimedia.org/wikipedia/commons/d/dc/XAMPP_Logo.png" alt="XAMPP" width="50" height="50"> <img src="https://upload.wikimedia.org/wikipedia/labs/8/8e/Mysql_logo.png" alt="My SQL" width="50" height="50">
Mint bárki más, ezt az adatbázis kezelő szoftvert ismerem a legjobban, még nem
mozgok elég otthonosan az Oracle-ban, úgyhogy maradtam a biztonságosnál.

#### Total Commander <img src="https://upload.wikimedia.org/wikipedia/commons/3/39/Total_Commander_Logo.png" alt="Total Commander" width="50" height="50">
A Total Commander-en keresztül adtam hozzá FTP kapcsolattal a különböző
tartalmakat, fájlokat és betűtípusokat a weblapomhoz miután megvettem a
tárhelyet és a domain címet.

#### IrfanView <img src="https://store-images.s-microsoft.com/image/apps.38156.13721543416381481.45481531-3c49-4c41-b51a-ac19fd243ccb.43b80312-37f9-45f4-b42d-cfffd08282a1?h=210" alt="Windows 10" width="50" height="50">
Az IrfanView a legjobb képszerkesztő véleményem szerint. Minden
képernyőkép, ami gazdagítja ezt a dokumentációt, ennek a remek szoftvernek
köszönhető, képfeltöltések terén való hibakeresésben is segítségemre volt.

## MILYEN PROGRAMOZÁSI NYELVEKET HASZNÁLTAM?

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/HTML5_logo_and_wordmark.svg/1200px-HTML5_logo_and_wordmark.svg.png" alt="HTML" width="50" height="50">

**HTML: HyperText Markup Language,** magyarul „hiperszöveges jelölőnyelv”,
egy leíró nyelv, weboldalak készítéséhez kifejlesztett szabvány, mára már
internetesé vált

<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXalRyF7J7QRLkJfMwCMqA47UUDCFdHJ-dFQ&s" alt="PHP" width="50" height="50">

**PHP: HyperText Processor,** „hiperszöveges előfeldolgozó” -t jelent,
mondhatni, hogy ez egy rekurzív rövidítés. A PHP nyílt forráskódú, széles
körben használt, általános célú és szerver oldali programozási nyelv. Különösen
jó web-fejlesztés támogatással és HTML-be ágyazási képességekkel. A
szintaxisa a C, Java és Perl nyelvekre épül, könnyen megtanulható.

<img src="https://upload.wikimedia.org/wikipedia/commons/d/d5/CSS3_logo_and_wordmark.svg" alt="CSS" width="50" height="50">

**CSS: Cascading Style Sheets”** kifejezés rövidítése, „egymásba ágyazott
stíluslapokat” foglal magába. A weblap vizuális stílusáért felel, a webes
böngészők megvizsgálják a dokumentum (weblap) CSS kódját, és ez alapján
jelenítik meg a HTML elemeket. A HTML-ben sokszor használt’<link
rel=”StyleSheet” href=”style.css”>’ is utal a nevére.

<img src="https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png" alt="HTML" width="50" height="50">

**JavaScript:** programozási nyelv egy objektumorientált, prototípus-alapú, egy
kliensoldali script nyelv, amelyet weboldalakon elterjedten használnak. Csak
olyan dolgokat tudunk elintézni a JavaScripttel, ami a kliens (felhasználó)
oldalán (eszközén) helyezkedik el.

<img src="https://d1.awsstatic.com/asset-repository/products/amazon-rds/1024px-MySQL.ff87215b43fd7292af172e2a5d9b844217262571.png" alt="My SQL" width="50" height="50">

**MySQL: Structured Query Language,** magyarul egy strukturált relációs
adatbázis-kezelő lekérdezési nyelv. Egy programnyelv, amellyel műveleteket
végezhetünk tényhalmazokkal és a közöttük fennálló kapcsolatokkal. A
relációs adatbázis-kezelő programok, például a XAMPP az adatok kezelésére
SQL nyelvet használnak.

## FEJLESZTŐI HARDWARE / HARDVER (RÉSZLET)

**Processzor**: Intel(R) Core(TM) i3 CPU 5500 @ 3.20GHz

**Memória mérete**: 8,00 GB

**Rendszer típusa** : 64 bites Windows 10 operációs rendszer, x64-alapú processzor

**Videókártya neve**: NVIDIA GeForce GTX 650 Ti

## AZ ADATBÁZIS

***Ábra: A szellakozmetika.hu adatbázisa, amely 11 táblából áll.***

### A ‘latogatasok’ tábla

A ‘latogatasok’ tábla magába foglalja az összes
látogatást, ami a weboldalon megtörtént.

**Latogatas_Id:** A látogatás ID-ja / sorszáma.

**Latogatas_Datuma:** Mikor nézték meg az adott
oldalt, DATETIME típusú változó, így
megkapjuk a látogatás dátumát év-hónap-nap
óra:perc:másodperc pontossággal.

**Latogatas_JelenlegiUrl:** A jelenlegi URL
címet a ‘*$_SERVER[‘REQUEST_URI’]*’ szuper globális változónak köszönhetően az
index.php-ban hozzá tudjuk adni a mezőhöz.

**Latogatas_IpCim**: Az eszköz, IP-címe, amely jelenleg a weboldalt megtekinti, ezt az értéket
a ’$_SERVER[’REMOTE_ADDR’]’ foglalja magába.

**LatogatoFelhasznalo_Id**: Annak a felhasználónak az ID-ja / azonosítószáma, aki éppen az
oldalakat látogatja, ha pedig nincs bejelentkezve akkor ez az érték nulla. Tény, vannak benne
redundáns adatok, de akkor is jó megoldásnak bizonyul az admin felület látogatottsági értékek
kinyeréséhez.

### A ‘bejelentkezesek’ tábla

A ‘bejelentkezesek’ tábla eltárolja az összes
bejelentkezést, amit az adott felhasználó
megejt az oldalunkon.

**Bejelentkezes_Id**: A bejelentkezés ID-ja /
sorszáma.

**Bejelentkezett_Felhasznalo_Id:**
A bejelentkezett felhasználó sorszáma, ezt a
‘felhasznalok’ táblában tároljuk, a ‘Felhasznalo_Id’ mezőben és az értéke ugyanúgy a
$_SESSION[‘Felhasznalo_Id’].

**Bejelentkezes_Datuma:** Mikor jelentkezett be a felhasználó legutoljára, az 5 legutóbbi
bejelentkezést megmutatjuk a profil.php-ban, év-hónap-nap és óra:perc:másodperc
pontossággal.

**Bejelentkezes_Ip**: Elmentjük az IP címét a bejelentkezésnek, ez a későbbiekben még ahhoz is
kulcsfontosságú lehet, hogy ha feltörik egy felhasználó fiókját, akkor kétlépcsős azonosítással megvédheti az adatait, itt is a ’$_SERVER[’REMOTE_ADDR’]’ szuperglobális változó lesz az érték.


### A ‘felhasznalok’ tábla

A **‘felhasznalok’** tábla legfontosabb
része az adatbázisnak. Itt tárolunk el
mindenkit (aki volt olyan kedves, hogy
regisztrált), pontosabban nem
mindenkit, hanem minden fontosabb
adatát, amire szüksége / szükségem
lehet, ezeket a regisztracio_form.php-
ben lehet megadni, a regisztracio.php
adja hozzá az adatbázis táblához,
nézzük végig ezeket:

**Felhasznalo_Id:** Nem tetszik nekem,
hogy sorszámozni kell minden
regisztrált embert, de sajnos ez a
legegyszerűbb és ismert módja az
azonosításnak, de más felhasználók
felkeresését már a **’FelhasznaloNev’**
értéke alapján nézhetőek meg.

**Felhasznalo_VezetekNev** és **Felhasznaló KeresztNev:** A felhasználónak kell, hogy legyen
egy emberi névre (legalább hasonlító) kereszt és vezetékneve, ha mást ír be, azon nyomban
törlésre kerül az admin felületen.

**Felhasznalo_SzuletesEv,** **Felhasznalo_SzuletesHonap** és **Felhasznalo_SzuletesNap:**
Eltárolom külön-külön a felhasználó születésnapjának dátumát, azért tárolom INT típusként mert ezzel a születésnappal később funkciókat szeretnék betölteni, mint például a
születésnapkor járó kedvezmény és hasonlók.

**Felhasznalo_Email:** Az e-mail-címet körül-belül mindenhol elkérik, így az én weblapom se lehet kivétel, ugyanis az előbb említett kedvezményt / kupont ki kell küldeni valahogy a
vendégnek / felhasználónak. Emellett e-mailen keresztül lehet figyelmeztetni, például: hogy ne
spam-eljen a Blog oldalon, ne foglaljon több időpontot a szükségesnél, ha mégis így tenne,
akkor a harmadik figyelmeztetés után törlésre kerül.

**Felhasznalo_Jelszo:** Egyértelműen szükség van egy véletlen vagy következetesen kitalált
karakterekből, szimbólumokból álló szövegre, amivel be tud lépni, hogy igénybe vehesse a
szolgáltatásokat, amiket a kutyakozmetika fel tud ajánlani.

**Felhasznalo_IpCim:** A felhasználó IP címét is eltárolom a szuper globális változóban, ami a
“$_SERVER[‘REMOTE_ADDR’]” ismét.

**Felhasznalo_RegisztracioDatuma:** A felhasználó regisztrálása, mint dátum elmentve több
szempontból is jó döntés: tudok adni kedvezményt, például, ha már 1 éve aktív tagja a
közösségnek, ennek köszönhetően akár időkorláthoz is köthetem, hogy mikortól szabad blog
bejegyzést írni, mondjuk 30 nap után napi 1, majd később egyre többet.

**Felhasználo_Neme:** Ha esetleg női felhasználónk is akad, akkor nők / anyák napja alkalmából felköszönthetjük őket bejelentkezéskor / e-mailen keresztül, vagy ha a keresztnév nem stimmel a megadott nemmel akkor gyorsabban kiszűrhetőek a hamis profilok.

**Felhasznalo_Statusz:** A státusza egy adott profilnak, képnek, időpont foglalásnak és egyéb
interakcióknak, az állapotának érdekében elkerülhetetlen. Minden fent felsorolt esetben kap egy „E” betűt, mint „előjegyzett”, még nem lett az adminisztrátor által elfogadva vagy elutasítva az adott tartalom. „T”, mint hogy törölve lett, „S” mint siker. „F”, mint a felhasználó törölte.


### A ‘kutya’ tábla

A ‘kutya’ táblában tárolunk el minden
regisztrált felhasználó által megadott adatot,
ami a kutyával kapcsolatos. Ezt
a **’kutya_form.php**’-ban teheti meg, és ezek az
adatok ’kutya.php’-ban kerülnek a táblába.

**Kutya_Id:** Adunk egy elsődleges kulcsot ehhez
a táblához is, mint bármelyik másikhoz,
ugyanazok az indokok miatt kell a Kutya_Id
mint például a Felhasznalo_Id: leggyorsabban
ki tudjuk szűrni az adott sort a táblából, és ha
kell, akkor ez alapján tudjuk módosítani vagy
törölni.

**Felhasznalo_ID:** Itt kötjük össze a
‘felhasznalok’ táblát a ‘kutya’ táblával.

**Kutya_Neve:** A kutya neve, lehet becenév is.

**Kutya_Fajta**: A kutya fajtája, ez az adat láthat az’**idopont_foglalas_form.php**’ oldalon.

**Kutya_SzorSzin:** A kutya szőrzetének a színe.

**Kutya_Neme:** A kutya neme, egy betű az érték, mint a „Felhasznalo_Neme”, itt nem „F” vagy
„N”, hanem „H” mint hím és „N” mint nőstény.

**Kutya_SzuletesEv**, **Kutya_SzuletesHonap** és **Kutya_SzuletesNap:** Hasonlóan a
‘Felhasznalo_SzuletesEv’, ‘Felhasznalo_SzuletesHonap’ és ‘Felhasznalo_SzuletesNap’-hoz, itt a kutya születésnapját tároljuk, ugyanúgy vagy kedvezménnyel, vagy jutalommal honoráljuk, hogy megerősítsük a felhasználót afelől, hogy törődünk vele és a kutyájával, és szeretnénk, hogy törzsvendégünk legyen.

**Kutya_Ivartalanitva_Van:** A kutya ivartalan vagy sem, használhattam volna BOOLEAN
változót, de egy karaktert használ fel, mint a ‘Felhasznalo_Statusz’ vagy a
‘Felhasznalo_Neme’.

### A ‘blog’ tábla:

A blog tábla az első funkciók egyike, itt
a felhasználók írhatnak új bejegyzéseket
/ témákat, és megvitathatják az
álláspontjukat, kérdéseket és tanácsokat
oszthatnak meg egymással emellett
kifejhetik a véleményüket (józan és
gyűlöletmentes keretek között).
**Blog_Tema_Id**: A blog bejegyzés /
téma sorszáma, ezt a sorszámot a $_GET
szuperglobális változóval, ami itt
pontosítva, ’$_GET[‘tema’]’ ahogyan az
URL címben látható.

**Blog_Felhasznalo_Id:** A felhasználó azonosítószáma / ID-ja, így tudjuk összekötni a
‘felhasznalok’ táblából a ‘Felhasznalo_Id’-val hogy ki írta ezt a blogbejegyzést / témát.

**Blog_BejelentkezettFelhasznalo_Id:** A felhasználó azonosítószámát újra felhasználjuk, ez
mondhatni redundáns adat, de így lehet összekötni a ***„blog_komment”*** táblát a ***„blog”*** táblával.

**Blog_Tema_Cim:** A bejegyzés / téma címe, a blog.php-ban egy kattintható link formájában át
fog irányítani a saját oldalára, példának itt ez a link: [szellakozmetika.hu/?p=blog&tema=1](szellakozmetika.hu/?p=blog&tema=1)

**Blog_Tartalom:** A bejegyzés tartalma, itt TEXT változóban van eltárolva, mert valószínűleg
a VARCHAR sovány 255-ös hosszúsággal túl rövid lehet egy bloghoz, így a***’blog.php’***-n
lekorlátoztam a textarea strlen (string length függvény) értékét maximum 1000-re.

***Blog_PosztolasDatuma***: Mikor küldte el a **‘submit’** típusú input elemmel a bejegyzést és a
címmel együtt a felhasználó, ezt is a ***„blog_form.php”*** -ben megjelenítjük a tartalom alatt a
biztonság kedvéért, egy idő után le fogom zárni az adott bejegyzéseket valószínűleg, a posztolás
dátuma tökéletes támpontnak.

**Blog_Statusz:** A blog bejegyzés státusza, egy darab betű / karakter, mint az előző státusz
tábláknál, előjegyzésben ’E’ ezután három útja lehet: ’S’ mint sikeres, ’L’ mint elutasítva és ’T’,
hogy a felhasználó törölte.

### A ‘blog_komment’ tábla:

A „blog_komment” táblában a felhasználók
által írt bejegyzésekhez / témákhoz lehet
hozzászólást írni, mondhatni a blogok sava-
borsa itt van.
**BlogKomment_Id:** A blog bejegyzés / téma
sorszáma, ezt a sorszámot a $_GET[‘tema’]
szuperglobális változóval
**BlogKomment_Tema_Id:** A „blog” tábla
„Blog_Tema_Id” azonosítószáma / ID-jával
összekötjük a „BlogKomment_Tema_Id”-val,
így csak azok a hozzászólások jelennek meg,
aminek a téma azonosítója megegyezik.

**BlogKomment_Felhasznalo_Id:** A
felhasználó azonosítószáma, hogy melyik felhasználó írta ezt a hozzászólást, a blog bejegyzés
írója nyugodtan írhat a saját bejegyzése alá, nincs ilyen korlátozás, nem lenne értelme.

**BlogKomment_Kep_Id:** Itt a **’kepek’** táblából a mysqli_insert_id() (a legutóbbi Kep_Id)
értéket kapja meg, abban az esetben hogyha a felhasználó adott hozzá képet a hozzászólásához,
különben ez az érték 0, vagyis nem adott hozzá képet.

**Blog_KommentDatuma:** Mikor küldte el a hozzászólást a felhasználó. A ‘blogkomment_form.php’-ben megjelenítjük a tartalom alatt és csökkenő sorrendben jelenítjük meg őket, hogy a legutóbbi hozzászólás legyen legfelül. Egy idő után le lesznek a bejegyzések zárolva, így hozzászólást se lehet majd írni.
**BlogKomment_Tartalom:** A hozzászólás tartalma, ez TEXT típusú, mivel a VARCHAR
kevésnek bizonyulhat a 255 karakterhosszával, főleg, ha valakinek nagyon sok
hozzáfűznivalója van egy témához / bejegyzéshez.

**Blog_EredetiKomment:** A hozzászólás a blogbejegyzéshez vagy egy másik hozzászóláshoz
tartozik. Értéke 0 és 1 lehet.

**BlogKomment_Statusz:** A blog hozzászólás státusza, előjegyzett, elfogadva / elutasítva vagy
törölve van az admin / felhasználó által. Ez a státusz mező is ugyanúgy működik, mint a
többinél, van az előjegyzett mint ’E’, ’S’ mint siker hogyha az adminisztrátor engedélyezni
hozzászólás megjelenítését, a ’T’ mint törölve az adminisztrátor által és ’F’ mint a felhasználó
törölte a blog bejegyzésre tett megjegyzését.

### A ‘idopont_foglalas’ tábla:

Az időpontfoglalás esszenciális része a
kutyakozmetikának, itt tesszük lehetővé, hogy ne a
telefonon keresztül zaklatva tudjon időpontot kérni a
felhasználó. Ebben a táblában eltároljuk a
felhasználót, aki kérte az időpontot, mikor és melyik
kutyájának kérte.

**IdopontFoglalas_Id:** A foglalt időpont sorszáma /
ID-ja elsődleges kulcsa táblának.

**Kutya_ID:** Itt kötjük össze a ‘kutya’ táblával az ‘idopont_foglalas’ táblával.

**KutyaTulajdonos_Id:** A felhasználó ID-ja / azonosítószáma, itt kapcsoljuk össze a
‘felhasznalok’ és ‘kutya’ táblákat egymással.

**IdopontFoglalas_Datuma:** DATETIME változó, ami egy dátumot foglal magába, itt tároljuk
a ‘idopontfoglalas_form.php’-ban lévő checkbox-ban lévő értéket. (Pontosabban első felét.
Például.: 2023- 03 - 20)

**IdopontFoglalas_Oraja:** TIME változó, itt tároljuk a *‘idopontfoglalas_form.php’*-ban lévő
checkbox-ban lévő értéket. (A második fele, például: 10:00:00)

### A ‘igenybevetel’ tábla:

Az igénybevételt összesíti, hogy egy felhasználóhoz
melyik időpontfoglalások tartoznak, milyen
szolgáltatásokat kért kutyájának és mennyi volt a
szolgáltatások pillanatnyi ára.

**Igenybevetel_Id:** Az igénybevétel sorszáma / ID-ja.

**IdopontFoglalas_ID:** Az időpontofoglalás
sorszáma.

**Szolgaltatas_ID:** Az szolgáltatás sorszáma / ID-ja, itt kötjük össze a ’szolgaltatasok’ táblával,
így tudjuk kinyerni, hogy milyen szolgáltatást vett igénybe a felhasználó a kutyája számára,
emellett, hogy mennyi volt a pillanatnyi ára a szolgáltatásnak akkor, és össze tudjuk hasonlítani
a mostanival.

**Igenybevetel_Ar:** A szolgáltatás ára igénybevétel során természetesen változni fog egy idő
után, vagy ha kedvezményes az ár akkor is tudnunk kell évek múlva is hogy mennyi volt akkor
az ár, és mennyi most, ennek köszönhetően statisztikákat is készíthetünk, emellett ha
adóbevallást kell készíteni, lesz mire támaszkodni, hogy ne ütközzünk jogi összetűzésekbe.

### A ‘szolgaltatasok’ tábla:

A szolgáltatásba manuálisan írtam a 20
szolgáltatást, amit a kutyakozmetika jelenleg tud
felajánlani. Ez természetesen még bővülni fog,
ennek érdekében a későbbiekben helyet fog kapni
az adminisztrációs felületen.

**Szolgaltatas_Id:** A szolgáltatás sorszáma / ID-ja.

**Szolgaltatas_Leiras:** A szolgáltatás leírása röviden, mit foglal magába a szolgáltatás és hogy
a kutya állapotát / kinézetét, hogy befolyásolja, TEXT változóként, talán VARCHAR-ban is
elférhet, ha a leírás minimalista.

**Szolgaltatas_Ar:** A szolgáltatás jelenlegi ára.

### A ‘kepek’ tábla:

**Kep_Id:** A feltöltött kép sorszáma / ID-ja,
elsődleges kulcsa a ’kepek’ táblának.

**Kep_Felhasznalo_Id:** A felhasználó
azonosítószáma, vagyis a sokszor használt
$_SESSION[‘Felhasznalo_Id’] szuperglobális
változó.

**Kep_Nev:** A képnek a PHP ’veletlenszo’, azaz
véletlen szó funkció által megváltoztatott képnevét
tároljuk, ezt is mutatjuk meg a’profil.php’ oldalon,
ez azért szükséges, hogy ne tudják könnyedén
ellopni jogtalanul a képeket, amit a
szellakozmetika.hu-ra feltöltöttek a felhasználók.

***Ábra: A ’$_FILES’ kiíratva, megmutatva a kép adatait.***

**Kep_EredetiNev:** A felhasználó által feltöltött kép eredeti neve, az a ’print($_FILES)’ PHP
parancs szerint a tömb azaz Array [kep]-nek a tömbjében lévő Array(első elemét (a [name] =>
a kép neve.képtípus (.png /.jpg)) is elmenti ebbe a mezőbe.

**Kep_FeltoltesDatuma:** Amikor a felhasználó feltölt egy képet a profiljára, vagy profilképnek
állítja be, akkor annak a dátumát év – hónap - nap és óra: perc: másodperc / yyyy-MM-dd HH:
mm: ss pontossággal tároljuk el. Ez azért is szükséges, hogyha a felhasználónak nincs jobb
dolga, akkor ne tudjon egy nap alatt több száz képet feltölteni. Emelett, a ’Kep_EredetiNev’
mezőben lévő összes nevet végignézi, nehogy ugyanazt a képet feltöltse újra, legalábbis
a’profil.php’ oldalon a Galéria részlegnél. Fölöslegesnek tartanám a profilképet lekorlátozni
vagy a blog bejegyzéseknek / hozzászólásoknak hozzáadott képet, lehet, hogy a felhasználó
ugyanannak a témának több bejegyzést akar szentelni, és így akarja megjelölni, hogy a másik
bejegyzés is hozzátartozik.

**Kep_ProfilKep:** Gyakorlatilag olyan, mint egy BOOLEAN változó, ’0’ és ’1’ lehet az értéke,
hogyha ’0’ az érték, akkor az a’profil.php’ oldalon jelenik meg, ha pedig ’1’ az értéke, akkor
az lesz az új profilkép a felhasználónak. Emelett a megfelelő mysqli_query (adatbázis
lekérdezés) paranccsal a’blog.php’ oldalon is megjeleníthetővé tehető. A lekérdezés csak a
legutóbb feltöltött profilképet fogja megjeleníteni, amit a LIMIT 0,1 MYSQL záradékkal
oldottam meg.

**Kep_Meret:** A fent mutatott ’print($_FILES)’ PHP parancs ábrán is látható volt, a kép mérete
68075 byte, és ezt is eltároljuk, hogyha átváltva esetleg 40MB fölötti fájlt próbálna meg egy
felhasználó az adatbázisba feltölteni, akkor azt ki tudjuk szűrni.

**Kep_Statusz:** A státusza egy adott képnek. Minden egyes kép „E” betűt kap, mint
„előjegyzett”, amit még az adminisztrátor nem fogadott el vagy utasított el. A kép státusz
előjegyzés után lehet: „T”, mint hogy törölve, „S” mint siker, fent van a szellakozmetika.hu-n
és „F”, mint a felhasználó törölte.


### A ’felhasznalok_archivum’ tábla

Itt rároljuk el a **’modositas_form.php’**-
ban megváltoztatott felhasználónevet,
jelszót és e-mail-címet.

**Felhasznalo_Archivum_Id:** A
módosításnak a sorszáma.

**Felhasznalo_Id_Archivum:** A
felhasználó azonosítószáma, aki
módosította saját adatait.

**FelhasznaloNev_Archivum:** Az előző
felhasználó név, gyakorlatilag a
jelenlegi **’FelhasznaloNev’** mező értéke maximálisan **25** karakter.

**Felhasznalo_Email_Archivum:** Az előző felhasználó név, a jelenlegi **’Felhasznalo_Email’**
mező értéke és a maximális hossza **100** karakter.

**Felhasznalo_Jelszo_Archivum:** Az előző felhasználó név, a jelenlegi **’Felhasznalo_Jelszo’**
mező értéke, meghagytam a password_hash() verziót biztonsági okokból, a maximális hossza
ugyanúgy **60** karakter.

**Mi_Lett_MegValtoztatva:** Itt 3 érték lehetséges: „F”, mint felhasználónév, „E”, mint e-mail-
cím és „J” mint jelszó, egy **1** karakteres státusz jelölő.

**Valtoztatas_Datuma:** A MySQL-ben több táblában használatos NOW () dátum függvény, az
Év-Hónap-Nap és Óra:Perc:Másodperc érték amikor az adott űrlap `<input type=”submit”>`
elküldés gombja meg lett nyomva megfelelő értékekkel..


## ALGORITMUSOK A WEBLAPON:

Az’idopont_foglalas_form.php’-ban egy for ciklussal oldottam meg a táblázat fejlécét, ahol az
adott nap dátumát kiíratom. A második for ciklus az ábrán a(z) $i változóval biztosítja, hogy 8
órától 18 óráig kiírja az órákat. A harmadik for ciklus íratja ki a hét első 5 napját, mivel a
kutyakozmetika csak hétköznap van nyitva, így csak az első 5 napra van szükség.

```
print "<table>";
print "<thead>";
for($th= 1 ; $th<= 5 ; $th++)
{
print "<th>";
print date("Y.m.d.", $hetfo + $th* 24 * 60 * 60 ). "<br>". $napnev[$th];
print "</th>";
}
print "</thead>";
print "<tbody>";
for($i = 8 ; $i <= 18 ; $i++)
{
print "<tr>";
for($j = 1 ; $j<= 5 ; $j++)
{

$datum = date("Y-m-d", $hetfo + $j* 24 * 60 * 60 );
$datum_nap = date("d", $hetfo + $j* 24 * 60 * 60 );
if($i < 10 )
$ora = "0".$i.":00";
else{
$ora = $i. ":00";
}
```

A’**gyik.php**’ oldalon szerettem volna elérni azt, hogy olyan áttűnési effektekkel rendelkezzen,
mint ahogyan az egy profi weblapnál is megfigyelhető.

```
let har = document.getElementsByClassName('harmonika');
for(let i = 0 ; i<har.length; i++){
    har[i].addEventListener('click',function(){
        let panel = this.nextElementSibling;
    
        if(panel.style.maxHeight){
            panel.style.maxHeight=null;
            this.classList.remove('kinyitva');
            this.getElementsByClassName('ikon')[ 0 ].innerHTML ='<img
src="Ikonok/LeNyil.png" alt="Kattins a válaszért!">';
    }else{
    for(let x= 0 ;x<har.length; x++){
        har[x].classList.remove('kinyitva');
        har[x].nextElementSibling.style.maxHeight = null;
        har[x].getElementsByClassName('ikon')[ 0 ].innerHTML ='<img
src="Ikonok/LeNyil.png" alt="Kattins a válaszért!">';
    }
    panel.style.maxHeight = panel.scrollHeight + 'px';
    this.classList.toggle('kinyitva');
    this.getElementsByClassName('ikon')[ 0 ].innerHTML = '<img
src="Ikonok/Gyik_Bezaras_X.png" alt="Kattins a válasz
bezárásáért!">';
        }
    })
}
```

Az első for ciklus megszámolja az összes’.harmonika’ (mert úgy nyílik és csukódik be, mint
egy harmonika) osztályú ’element’ / elem indexét az utolsóig. Hozzá ad egy ’eventListener’-t
megnézi, hogy történt-e bal egér kattintás. A ’tartalom’ az maga a ’.panel’ nevezetű osztály,
ahol a kérdésekre a válaszokat tároljuk, ha ennek a panelnek a maximum magassága null-lal
egyenlő, akkor eltávolítja a ’.kinyitva’ osztályt, ami CSS-en keresztül manipulálja a megjeleníteni kívánt tartalom maximum magasságát. Emellett, a tőle jobbra található’.ikon’
osztályban lévő képet is cserélgeti, hogyha a ’.kinyitva’ osztály meg van hívva, hogyha be van
csukva, egy lefelé mutató nyíl fogadja a felhasználót, ösztönözve, hogy kattintson rá és olvassa
el. Ha pedig ki van nyitva egy kérdés, akkor az előzőt bezárja, a megnyitott egy kérdés jobb
oldalán megfigyelhetjük, hogy egy nevű ’X’ alakú ikonra cserélte le a JavaScript függvény.

```
const rejtettElemek = document.querySelectorAll('.animacio-
jobb, .animacio-bal');
const megfigyelo = new IntersectionObserver((gorgetesek) => {
    gorgetesek.forEach((gorget) => {
        if(gorget.isIntersecting){
           gorget.target.classList.add('animacio');
        }
        else{
           gorget.target.classList.remove('animacio');
        }
    })
}, {
        // threshold: 0.55
});
rejtettElemek.forEach((rJBE) => megfigyelo.observe(rJBE));
```

Ez a JavaScript szösszenet magába foglal 2 konstans változót a **rejtettElemek** kiválaszt
minden elemet, amelyik a rendelkezik az ’.animacio-jobb’ vagy ’animacio-bal’ osztállyal. Ezek
áttűnési effektek, ha úgy tetszik. A másik konstans, a **megfigyelo** egy
**IntersectionObserver**, azaz megfigyeli, hogy történt-e görgetés. Hogyha történt, akkor hozzáadja az ’.animacio’ osztályt, aminek (és természetesen a CSS-nek) köszönhetően, az elemek az osztályuktól függően, bal vagy jobb oldalról be fognak halványodni. A kikommentelt résznél, a treshold-nál beállíthatjuk, hogyha az adott elem (például 55%-a) látszik, akkor
hozzáadja a hozzárendelt osztályt és az animáció lefut egy forEach-en belül (lásd a kód
legutolsó sorát). Ezeket az animációkat megvalósítva észreveheted az
’index / kezdolap’, ’szolgaltatasok’ és’blog.php’ oldalon

### Regisztráció

Regisztráció nélkül nem tudnánk különbséget tenni a látogatók és a felhasználók között. Ahhoz,
hogy a látogatóból funkciókat élvező felhasználó lehessen, ki kell töltenie 4 darab szövegdobozt
(`<input type=”text”>`), 2 darab jelszó mezőt (`<input type=” password”>`), amiből az előbbi egy
JavaScript függvénnyel megváltoztatható szövegdobozzá, hogy a felhasználó láthassa az általa
beírt jelszót. Majd 2 darab rádiógomb a felhasználó neme (Férfi vagy Nő) megadása miatt, csak
az egyiket kell kiválasztania és végül 3 darab select mező, benne option slot-okkal, év esetén
2023 - tól 1905-ig, hónap esetén januártól – decemberig és a napok 1-től 31-ig (szökőév és
hónaptól függően változik), a nap csak akkor választható ki hogyha az év és hónap meg lett
adva. A beírt adatok után pedig a **’Regisztrálok!’** gombra kattintva az adatok bekerülnek az
adatbázisba, ezt egy felugró ablak jelezni fogja.

### Bejelentkezés

A bejelentkezésre azért van szükség, hogy a látogató korlátolt lehetőségeit feloldja és élhessen
a felhasználói kiváltságokkal (időpontfoglalás, blog közösségben való részvétel stb).
A felhasználó regisztráció után át lesz irányítva a bejelentkezés űrlapra (form), itt a felső
szövegdobozban meg tudja adni az e-mail-címét (`$_POST[’Felhasznalo_Email’]`) vagy
felhasználónevét (`$_POST[’FelhasznaloNev’]`), és az alatta található jelszó mezőben pedig a
jelszavát (`$_POST[’Felhasznalo_Jelszo’]`).

A beírt adatokat összehasonlítja az adatbázisban tárolt adatokkal, vagyis az első mezőben a
`$_POST[’Felhasznalo_Email’]` és `$_POST[’FelhasznaloNev’]` közül az egyiket, azután pedig
a `$_POST[’Felhasznalo_Jelszo’]` értékét az adatbázisban lévő **’felhasznalok’** táblát átnézve.
Ha a `$_POST` értékek megegyeznek a beírt **Felhasznalo_Email**, **FelhasznaloNev** és
**Felhasznalo_Jelszo** mező értékeivel, és a **’Belépek!’** gomb a form alján meg lett nyomva akkor
a belépés sikeresen megtörtént, egy felugró ablakkal a keresztneveden üdvözölve és
megszólítva.

### Más felhasználók megtekintése

Amikor a felhasználó bejelentkezett, automatikusan átírányítást kell hogy kapjon a profiljára,
ahol megtekintheti egy pár ’mysqli_query()’ parancs lefutásával az adatait amiket megadott,
ezek közül az e-mail-címét, jelszavát, felhasználónevét megváltoztathatja. De hogyha egy
másik felhasználó adataira kíváncsi, akkor azt 2 féleképpen teheti meg.:

- A saját profilján való lekérdezések fő elágazási eleme az a ’mysqli_query()’ lekérdezéseben
keresendő.:
    `SELECT` * `FROM` felhasznalok `WHERE` Felhasznalo_Id =’`$_SESSION`[Felhasznalo_Id]’
- Más felhasználók profiljának lekérdezését hasonló logikával készítettem,
a ’`$_SESSION[Felhasznalo_Id]’`-t lecserélve a `$_GET` szuper globális változóra.:
    `SELECT` * `FROM` felhasznalok `WHERE` FelhasznaloNev =’`$_GET`[FelhasznaloNev]’
A `$_GET`[’fiok’] szuper globális változó kiszedte az URL címből a ’fiok’ egyenlőségjel után
található értéket, ami egy felhasználónak a felhasználóneve. Azért nem használtam inkább
a ’Felhasznalo_Id’-t a más felhasználók lekérdezésére, mert így bárki kedvére egyesével végig
futhatna a felhasználókon, ami biztonsági résnek is mondható akárcsak a képek elnevezése
esetében.
- A blog bejegyzések között böngészve megnézheti, hogy ki írta az adott bejegyzést, és mivel
a bejegyzés vagy a hozzászólónak írójának a felhasználóneve egy link, ezért át fogja irányítani
például.: [szellakozmetika.hu/?p=profil&fiok=FelhasznaloNev](szellakozmetika.hu/?p=profil&fiok=FelhasznaloNev)
- A másik lehetőség gyakorlatilag ugyanaz, mint a link amit példának említettem pont az előbb,
hogyha kíváncsi egy másik felhasználó tartalmaira, akkor megteheti azt is hogy a saját profilján
([szellakozmetika.hu/?p=profil](szellakozmetika.hu/?p=profil)) az URL-címet kibővíti a következővel:’&fiok= [A felhasználó
akit keres felhasználónév alapján]’. Mondhatni 50-50% eséllyel vagy kimutatja a felhasználót,
akit keres, vagy kap egy 404-es hiba oldalra való átirányítást, jelezvén, hogy nincs ilyen
felhasználó.

### Képek feltöltése

A képek elnevezését, méretezését és tárolását nem bízhatjuk a felhasználóra, ezt
a’**kep_modositas.php**’ fájl teszi meg (pontosabban a benne lévő eljárások) helyettük és
helyettem. A lényege ennek, hogy szabványosan átméretezze az feltöltött képeket maximum
27 0 pixel szélesre és magasra, eltárolja őket és segítsen megjeleníteni őket.

- Itt a `$_FILES` szuper globális változó szolgál a segítségül, az én esetemben
a’**kep_modositas_form.php**’-ban található `<input type=”file” name=’Kep_Nev’>` elembe
feltöltött fájl lesz az, név szerint `$_FILES[’Kep_Nev’]`.

Ezt a `$_FILES[’Kep_Nev’]` változót eltároltam a `$kepnev` nevű változóba.

A `$betuk` változóban van minden angol betű és minden egyjegyű szám eltárolva szóközök /
space nélkül egyben, majd ezt feldarabolja és egy véletlenszerű eljárással, a rand()-al fog így
készíteni egy 8 karakter hosszú string változót, az azonos kép név elkerülése miatt van erre
szükség.

A képet feltöltjük a move_uploaded_file() metódus segítségével, a gyökérkönyvtáron belül
a ’FeltoltottKepek’ mappába, a mappában lévő fájlok nevei a kép feltöltésének másodperc
pontos eredménye lesz szóközök / space nélkül, azután egy aláhúzás karakter (’_’) amit
a ’`$_SESSION`[Felhasznalo_Id]’, azaz a felhasználó ID-ja, az azonosítószáma aki feltöltött a
képet, egy újabb aláhúzás és a 8 karakterből álló véletlen sorozat, így minimalizálva az esélyét
a redundáns adattal rendelkező képeknek.

Hogyha a kép típusa nem **Joint Photographic Experts Group / .JPG** vagy **.JPEG; Portable**
**Network Graphics / .PNG; Graphics Interchange Format / .GIF** és **Web Picture**, azaz.
**WEBP** kiterjesztésű, akkor egy felugró ablak értesít, hogy milyen formátumú képeket fogad el
és a kép nem kerül feltöltésre.
Ezután a képet a imagecopyresampled() metódussal lekicsinyítjük / felnagyítjuk rosszabb
esetben 270×270 pixel szélesre és vagy magasra ami az említett move_uploaded_file()-al
bekerül a ’Kis_FeltoltottKepek’ mappába.


## A WEBOLDAL DIZÁJN-JA

A legtöbb kutyakozmetikás weboldalnál feltűnt egy mintázat, a kezdőlapokban főleg.:
Menü sáv → Kis szöveg → Képek → Elérhetőség → Lábléc (jobb esetben)
Általában az eredmény egy 1-2 óra alatt WordPress-ben összecsapott statikus weblap.

Az én weblapomban is vannak hasonlóságok a fent felsoroltak az utóbbi időben amilyen őrült
frontend fejlesztők (amilyen én is szeretnék lenni) vannak, az én Kezdőlapom így néz ki.:
Reszponzív menü sáv egy egyedi menü gombbal → Egy kép szöveggel, gombbal és
animációval → Oszlopok szöveggel és átirányító gombokkal → Kép galéria (slider stílusban)
→ Lábléc oldaltérképpel, közösségi média hivatkozásokkal + egyéb jogi oldalak (ÁSZF stb.)

A weboldal egészen a Samsung Galaxy Fold okostelefonig reszponzív, vagyis 280 pixel széles
képernyőn is tökéletesen látható minden tartalom. A töréspontok oldalanként változnak, a 768,
480, 320 pixel széles képernyőkre használt’@media screen’ query értékek a leggyakoribbak. A
legtöbb helyen a ’**display: flex**’-et használtam, ebből adódóan a(z) ’**align-items: center**’, ’**justify-content: center**’, ’**flex-direction: column**’ és az animációkhoz a ’**transition**’
és ’ **transform: rotate(); scale(); translateX() és TranslateY()** ’ tulajdonságokat használtam,
meg írtam pár animáció osztályt, mint például a kezdőlap címszövegén
használt **’.FentrolLefele’**, vagy ’**.animacio-bal’** / ’**.animacio-jobb**’ a ’**Szolgáltatásaink**’
oldalon a jobbról és balról betűnő animációk kíséretében, Emellett előszeretettel használom
a’**:hover**’, ’**:before**’, ’**:after**’ és ’**nth-child()**’ selectorokat. Más esetekben a ’**display: block**’,
a ’**margin: 0 auto;**’ (középre igazítás), a ’**position: absolute;**’ és a hozzátartozó ’**top; right;**
**bottom; és left;** ’ CSS tulajdonságokat használtam. Az animációkat főleg a ’ **Kezdőlapon** ’,
a ’ **Rólunk**’ és a menüsáv jobb sarkában a táblagépeken és telefonokon látható 3 különböző
hosszú vonal jellegzetes animációjával ahogyan egy ’**X**’-et formálnak a lefelé nyíló
menüpontok fölött. De legfőképpen ennek a weboldalnak erőssége a UX (User Experience), és
ez még csak a kezdet.

## KAPCSOLATFELVÉTEL AZ ÜZEMELTETŐVEL

Nagyon sok órát és energiát fektetettem bele ebbe a webes alkalmazásba, remélhetőleg értéket
adott az életedhez és örömödet lelted benne. De tény, még rengeteg munka lesz vele mire
tényleg piacképes lesz és kutyakozmetikusok megbízhatónak találják.

Elsődleges e-mail-címem: [reucovdavid@gmail.com](reucovdavid@gmail.com)

Telefonszámom: +36 50 103 9164

Portfólió oldalam: [fejlodjunktudatosan.hu](fejlodjunktudatosan.hu)

Ott meg fogod találni eddigi munkáimat és a Kapcsolat (itt is, a [szornyellakutyakozmetika.hu](szornyellakutyakozmetika.hu)-
n és a [szellakozmetika.hu](szellakozmetika.hu)-n is) oldalon is felveheted velem a kapcsolatot bármilyen téma
jegyében.

# TESZT DOKUMENTÁCIÓ

Megkértem 2-4 közeli ismerősömet, abból 2 osztálytársamat, hogy felhasználói szemmel
teszteljék le az weblapot, ezek a hibák fordultak elő és lettek sikeresen kijavítva.

## ÜRES PROFIL OLDAL LEZÁROLT TELEFON UTÁN

Osztálytársam, Tóth Norbert név szerint, bejelentkezett egy teszt felhasználói fiókkal, ahol
a’/?p=profil’ vagy a ’Profilom’ oldalon körülnézett, majd lezárolta a telefont és megnézte az
oldalt ismét, ki lett jelentkeztetve, mintha az unset`($_SESSION[’Felhasznalo_Id’])` parancs
lefutott volna a’**kijelentkezes.php**’-ból, vagyis a `$_SESSION` token lejárt. Ennek hatására
eltűnt a profilom adatai és csak egy üres, fehér oldalt adott vissza (csak az’**index.php**’-ban
megírt header és footer tag voltak meg), ezt egy ’if’ elágazással kezeltem a’**profil.php**’-ban:

```
if(!isset($_SESSION['Felhasznalo_Id']) && !isset($_GET['fiok']))
{
include(”404.php”);
}
```

Hogyha nincsen bejelentkezve és egy felhasználóra se keresett rá (még) mint látogató, akkor a.
tartalom osztályú div tagban, ami mindig az’**index.php**’-ban van és meghívja a’**404.php**’-t ahol
van egy pirosan-fehéren villogó cím szöveggel, egy kép és még némi szöveggel meg egy linkkel
vissza a kezdőlapra, értesítve a felhasználót, hogy nem elérhető a kívánt tartalom amit keres.

## ÜRES KÉPEK A GALÉRIÁBAN

A’**kep_modositas_form.php**’-ban fel lehetett tölteni képeket a galériába és a profilképnek
fenntartott. ProfilKep osztályú div tagbe és a Galeria azonosítóval rendelkező div tagben. Mivel
az img az egy HTML tag, így egy kicsi áthúzott képet ábrázoló ikont jelenített meg a galériában
és a profilképben jelezve, hogy az adott kép nem létezik. Így néz ki az ellenőrzés:

```
if (empty($_FILES['Kep_Nev']['name'])){
print "<script>alert('Nem választottál ki képet!')</script>";
}
else {...
```

Ez az ellenőrzés már a’**kep_modositas.php**’-ban történik. Itt ebben az esetben, hogyha a
feltöltött fájl neve üres, tehát nemhogy **null** értéke sincs a képnek, akkor feldob egy felugró
ablakot és az **else** ágban történik minden, ami a kép módosítással kapcsolatos.

## AZ IDŐPONTFOGLALÁS KIJÁTSZÁSA

### Foglalt időpont

Az ’**idopont_foglalas_form.php**’-ban, a táblázat-ban minden cella aminek az értéke
megtalálható az ’**idopont_foglalas**’ adatbázis táblában, annak a cellának a háttérszíne piros
lesz, a benne lévő checkbox CSS display értéke ’**none**’-ra van állítva és megkapja a ’**disabled**’
tulajdonságot. A probléma ott kezdődött, hogyha a látogató / felhasználó jobb egérklikkel
kiválasztotta a Vizsgálat / Elem vizsgálata opciót majd kijelölte az egyik lefoglalt időpont
celláját és kitörölte az előbb említett ’**display: none;**’ és ’**disabled**’ tulajdonságokat és így
ráttinthat a checkbox-ra és így lefoglalhatja ugyanazt az időpontot és így redundanciát okoz az
adatbázisban. Ezután az ’**idopont_foglalas.php**’-ban elmentettem az időpontfoglalásnak a
dátumát és óráját, majd egy MySQL lekérdezésben összehasonlítottam őket. Abban az esetben
hogyha a `mysqli_num_rows()` metódus értéke 0-val tért vissza, akkor az időpontot lefoglalta
sikeresen, ha pedig már van foglalás az adott időpontra, akkor egy felugró ablakkal
figyelmezteti a felhasználót, ezt a hibát ismerősöm, Balla Renáta vette észre.

***Ábra: Ha a felhasználó már foglalt időpontot akar lefoglalni.***

### Nagyon előre tervezett időpontfoglalás

A következő eset hogyha a felhasználó a checkbox értékének a hetét átírja 19 (21 nap – 2 nap
a 3.-dik hét hétvégéje) nappal későbbire, ezt a hibát az orvosom, Dr. Páll István vette észre
amikor megkértem, hogy próbálja ki az időpontfoglalást.

```
$_3Het_Mulva = date("Y-m-d", $Most + ( 19 )* 24 * 60 * 60 );
$HaromHetMulva = strtotime($_3Het_Mulva);
if($IdopontDatuma > $HaromHetMulva)
{
die("<script>alert('Nem foglalhatsz időpontot 3 hétnél
későbbre!')</script>");
print($Vissza_Az_Idopont_Foglalashoz);
}
```

Itt összehasonlítottuk az `$_POST[’IdopontFoglalas_Oraja’]` (ebben a változóban benne van a
dátum és az órája is), átvezettem egy **$IdopontDatuma** változóba **strtotime()** függvénnyel, és
összehasonlítottam a **$HaromHetMulva** változóval, ami mostani dátumhoz hasonlított érték
+ 19 nap. Ha nagyobb ez az érték másodpercekben nézve (mert **strtotime()** függvényt
használtam) akkor hibaüzenetre fut.

***Ábra: Ha a felhasználó 3 hétnél későbbre akar lefoglalni.***

### Elfogadhatatlan időpontok

A következő eset ha átírja a felhasználó az időpont óráját ami nem kerek órára végződik és itt
egy másik esetet is meg tudok említeni, hogyha az időpont órája nem esik 8 és 17 óra közé,
osztálytársam, Erdős Ádám András keltette fel a figyelmemet erre a
hibára.**$ElfogadhatoOrak = array('08:00:00', '09:00:00', '10:00:00',**
**'11:00:00', '12:00:00', '13:00:00', '14:00:00', '15:00:00',**
**'16:00:00', '17:00:00');**
Létrehoztam egy tömböt, amiben benne van minden elfogadható óra. Elmentettem az időpont
foglalás óráját egy **$Idopont_Ora** változóban, összehasonlítottam a **$ElfogadhatoOrak**
változóéval.

```
if ($Idopont_Ora >= '08:00:00' && $Idopont_Ora <= '17:00:00')
//ha az időpont 8 és 17 óra között van
{
if(in_array($Idopont_Ora, $ElfogadhatoOrak))
//és az időpont foglalás órája 8-17 és óra közötti kereken
{
$Az_Idopont_Megfelelo += 1 ;
}
else{ //máskülönben ha akár pl 08:00:01, akkor hibára fut
die("<script>alert('Nem foglalhatsz időpontot megkezdett
órákra!')</script>");
print($Vissza_Az_Idopont_Foglalashoz);}}
elseif($Idopont_Ora < '08:00:00' || $Idopont_Ora >
'17:00:00'){ //máskülönben ha az időpont kisebb mint 8 óra vagy
nagyobb mint 17 óra
if(isset($_POST['Idopont_Foglalas_Gomb']))
{die("<script>alert('Nem foglalhatsz időpontot nyitvartartási
időn (8-17) kívül!')</script>");
print($Vissza_Az_Idopont_Foglalashoz);
        }
}
```

***Ábra: Ha a felhasználó át írja a checkbox értékét, ahol a perc és másodperc nem egyenlő nullával.***

***Ábra: Ha a felhasználó nyitvatartási időn kívül eső időpontra írja át a checkbox értékét.***

```
$Nap_Sorszam = date('N', $Idopont_mpben); //majdnem ugyanaz mint a
most másodpercekben strtotime-al, csak itt az időpont másodpercben
mérve
if ($Nap_Sorszam >= 1 && $Nap_Sorszam <= 5 ) //ha 1-5. nap van
azaz Hétfő, Kedd, Szerda, Csütörtök, Péntek
{
$Az_Idopont_Megfelelo += 1 ;
}
else //Máskülönben hétvége egy hibaüzenettel megfűszerezve
{
die("<script>alert('Nem foglalhatsz időpontot
hétvégére!')</script>");
print($Vissza_Az_Idopont_Foglalashoz);
}
```

***Ábra: Ha a felhasználó egy hétvégére eső időpontra írja át a checkbox értékét.***

## Az admin felülete

***Ábra: Az adminisztrátor számára megjelenik az admin menüpont a Blog és Profilom között.***

Az admin felületen megtekinthetőek az elmúlt hét nap oldal letöltései / látogatásai, a
diagramban vannak fekete szegélyű oszlopok, azokon belül 4 keskeny, színes oszlop balról
jobbra: a ciánkékben látható a nap történt összes látogatás, mellette halvány szürkével a nem
regisztrált felhasználók látogatásai, a lila oszlopban a bejelentkezett női felhasználók látogatás
száma, míg a legutolsóban sötétkékkel a férfi felhasználók látogatásai találhatóak, 200
látogatásonként egy vonallal jelezvén az adatokat.

***Ábra: A látogatások diagram formában.***

Ezután pedig a felhasználók táblázata, itt lehet törölni a azokat a felhasználókat, akiket nem
szeretnénk tovább a [szellakozmetika.hu](szellakozmetika.hu) oldalán látni. Csak görgessünk a táblázat legvégére és
nyomjunk rá a ’**Törlés**’ gombra.

***Ábra: A felhasználók táblázatban, a legvégén egy törlés gombbal.***

***Ábra: Sikerüzenet miután töröltél egy felhasználót.***

Ha lejjebb görgetünk, itt találhatjuk a legutóbb feltöltött képeket, ahol eldönthetjük, hogy
feltöltheti-e a felhasználó profilképnek vagy galéria képnek, csak rá kell kattintani az „Elfogad”
vagy „Töröl” gombra, ha elfogadjuk, megváltoztatjuk a **’Kep_Statusz’** mezőt a ’**kepek**’
táblában, amely megjeleníthető állapotba hozza a képet.

***Ábra: A képek elfogadásának vagy törlésének fenntartott űrlap.***

***Ábra: Bal oldalon elfogadjuk a képet, bal oldalon pedig töröljük.***

***Ábra: Sikerüzenet: Törölted a képet.***

***Ábra : Sikerüzenet: Elfogadtad a képet megjelenítésre.***

A képek sikerüzenete még függ a ’**Kep_ProfilKep**’ értékétől, hogy nullával egyenlő akkor az
ünezet lehet: Törölted a [Kép sorszáma]. -dik profilképet! ha pedig elfogadod akkor ez az [Képsorszáma].-dik profilkép elfogadva! Üzenetet fogja megjeleníteni, ezek a képek a feltöltött
helyükről is törlésre kerülnek, nem csak az adatbázisból.
A blog bejegyzéseket és hozzászólásokat is ilyen módon átnézi az üzemeltető, eldöntve, hogy
melyik bejegyzések felelnek meg a Felhasználási Feltételeknek és nem tartalmaz
gyűlöletbeszédet és egyéb nem kívánatos, nem ’fertőtlenített’ adatokat (SQL injekció
támadások stb.) A bejegyzéseket ugyanúgy láthatjuk, mint a ’Profilom’ oldalon, jobbra és balra
lehet őket lapozni, és el lehet őket fogadni, hogy megjelenjenek a ’Blog’ oldalon vagy sem.

***Ábra : A blogbejegyzésekről megjelenítéséről itt dönthetünk.***

***Ábra : A pillanat amikor rákattintunk a blogbejegyzés elfogadására.***

***Ábra : Sikerüzenet: Elfogadtad a blogot megjelenítésre.***

Hasonlóan a képeknél, különböző sikerüzenetekkel találkozhatunk, hogyha a ’**Blog_Kep_Id**’
nem egyenlő 0-val, akkor a sikerüzenet: „[Blog sorszáma]. -dik blogbejegyzés képpel együtt”_
máskülönben „[Blog sorszáma]. -dik blogbejegyzés kép nélkül”. A törlés is így jelez:

***Ábra : Sikerüzenet: Elfogadtad a blogot megjelenítésre.***

A blogbejegyzések is így működnek, a képlapozó külsejű űrlapon belül kiírtatjuk, hogy melyik
blog bejegyzéshez tartozik, mi a hozzászólás tartalma, melyik felhasználó írta, van-ez hozzá
csatolt kép (ha van, akkor töröljük a ’**BlogKomment_FeltoltottKepek**’
és ’**Kozepes_FeltolotttKepek**’ mappából) és kiír különböző sikerüzeneteket.

***Ábra: A blog hozzászólások törlése és megjelenítésének az űrlapja.***

***Ábra: Sikerüzenet: blog hozzászólás elfogadva, hozzácsatolt kép nélkül.***

***Ábra: Sikerüzenet: hozzászólás törölve, hozzácsatolt képpel.***

## FEJLESZTÉSI LEHETŐSÉGEK

Sok helyen utaltam rá, hogy milyen lehetőségeket látok még megvalósítatlanul a webes alapú
szoftveremen, itt felsorolnám őket:

- A dizájn továbbfejlesztése, reszponzív az oldal egészen a Samsung Galaxy Fold
okostelefonig (280 pixel széles képernyőig!), de viszont szeretnék gondolni a széles 4K-
s monitorral és még annál is nagyobb képernyőkkel rendelkező felhasználókra is.

- Reálisabb időpontfoglalás. Valljuk be, nem ritkán vannak késések, nem minden
szolgáltatás tart tökéletesen 60 percig, és a felhasználó is késhet a kutyájával.

- Időpontfoglalás szerkesztése és törlése.

- Képek vízjelezése és lopás állóvá tétele.

- Reklámfelület kutyakozmetikai eszközök és egyéb kutyákkal kapcsolatos termékek
értékesítésére, például.: kutyatáp, kiegészítők, fésűk és ollók stb. (értelmetlenség lenne
hagyni, hogy más kutyakozmetikusok ezen az oldalon potenciális ügyfeleket ragadjanak
el)

- A regisztráció és bejelentkezés űrlapot át tenni egy megjelenő ablakba, átirányítások
nélkül, mint ahogy az emlékeztetőnél tettem.

- A blog bejegyzéseket külön témákba összefogni, a könnyebb eligazodás érdekében.

- Chatszoba / privát üzenetküldési lehetőség kialakítása.

- Webshop hozzáadása, és ’cserekereskedelem’ vagy piac kialakítása is a felhasználók
között. (Az adminisztrátor is tölthet fel vadonatúj importált, ellenőrzött termékeket, de
a felhasználók is kereskedhetnek egymás között az akár használt termékeikkel.)

- Objektum orientáltra átírni az egész szakdolgozatot.

Röviden összegezve, még számtalan tervem van még amit szeretnék megvalósítani csak a
gyorsan szálló idő és a rengeteg felfedezni való eljárás, trükk amit a PHP, MySQL és JavaScript
nyelvek tartogatnak még számomra nem engedte meg. Emellett szeretném sokkal
biztonságosabbá és hatékonyabbá tenni más programozási nyelvekkel, amiket szeretnék
megtanulni például.: ReactJS vagy NodeJS, leváltani a MySQL-t Oracle-re stb.


# FELHASZNÁLÓI DOKUMENTÁCIÓ

## A WEBLAPOM CÉLJA, ÉS AMIT TE PROFITÁLHATSZ BELŐLE:

Kedves Felhasználó! Jelenleg egy Internet kapcsolattal működő szoftvert tartasz a kezedben,
ahol jelenleg a következő funkciókat fogod tudni élvezni regisztráció után:

- Blog bejegyzések írása, tetszés szerint kép és link (hivatkozás akár egy teljesen más weboldalra).

- Saját és más felhasználók által írt bejegyzések alá hozzászólást (comment) fűzni.

- Időpontot foglalni kutyusoddal a weblaphoz tartozó kutyakozmetikushoz /
kutyakozmetikusokhoz.

- Képeket feltölteni a profilodra, amit mások is megtekinthetnek, fordított esetben te is megtekintheted más felhasználók feltöltött képeit.

## SZOFTVER ÉS HARDVER IGÉNY:

**Hardver** / Hardware alatt a kézzel megfogható informatikai eszközt értjük, mint: legalább egy
középkategóriás okostelefon, vagy egy laptop, azaz hordozható kézi számítógép, vagy egy
otthoni felhasználásra való PC, vagyis személyi számítógép.

**Szoftver** / Software alatt pedig a kézzel nem megfogható alkalmazásokat értjük, itt csak vezeték
nélküli Wi-Fi, Mobil Net kapcsolatra, vagy számítógép és laptop esetén vezetékes Internet
kapcsolatra, és természetesen egy böngészőre van szükség, tudom ajánlani a következőket:
Mozilla Firefox, Google Chrome, Microsoft Edge, DuckDuckGo és az iOS Safari böngészőjét.

## HOGYAN TELEPÍTSD ÉS INDÍTSD EL?

Telepítésre csak akkor van szükség, hogyha még nem rendelkezel egy böngészővel (párat
felsoroltam az előző pontban) és természetesen internet hozzáféréssel, mivel ez egy web alapú
szoftver. De ha ezek megvannak akkor semmi, de semmi szükség nincsen telepítésre a te
részedről, hogy elérd a weblapot. Csak egy böngésző kereső rubrikájába beírod vagy másolod,
és azután beilleszted a következő URL címet, vagy csak itt lent kattints rá az aláhúzott szövegre
és át fog téged irányítani a weblapra.

[szellakozmetika.hu](szellakozmetika.hu)

## LEHETŐSÉGEID ISMERTETÉSE A WEBLAPON:

**_Ábra: Lehetőségei egy látogatónak, regisztrált felhasználónak és az üzemeltetőnek az oldalon._**

Már az imént felsoroltuk a jelenleg is elérhető funkciók listáját, de vannak olyan látogatók a
weblapon, akik bejelentkezés és regisztráció nélkül is szeretnék látni a [szellakozmetika.hu](szellakozmetika.hu)
által kínált lehetőségeket, funkciókat, biztonsági szempontokból a látogatók számára kissé
korlátozottan, de a következők érhetők el.:

- Blog bejegyzések megtekintése
- Felhasználók profiljának megtekintése (korlátozottan, kevesebb adatot láthatnak)
- Felhasználók képeinek megtekintése


**A regisztrált felhasználók némileg több funkciót élvezhetnek, mint a nem regisztrált és bejelentkezett látogatók.:**

- Blog bejegyzések megtekintése.

- Blog bejegyzések írása, hozzáfűzhetnek képet és linket.

- Blog bejegyzések alá írhatnak megjegyzést, képpel és linkkel megtámogatva.

- Felhasználók profiljának megtekintése. (több adatot láthatnak, mint a látogatók)

- Felhasználók képeinek megtekintése.

- Kapcsolat felvétel az adminisztrátorral.

- Hibajegy kérvényezése és panasz / moderátor közbeavatkozás küldése az
adminisztrátornak.

(Előbbinél példának, hogyha esetleg egy adott funkció nem működik megfelelően akkor arról
maradéktalanul levelet küld az adminisztrátornak, az utóbbinál például egy felhasználó nem
tesz eleget a Felhasználási Feltételeknek.)


## A KEZDŐLAP ÉS A MENÜ FEJLÉC, AVAGY A ’NAVIGÁCIÓD’

A fejléccel még sokszor fog minden felhasználó és látogató találkozni, ezért bemutatom, hogy
az adott menü elemek kattintás után hova irányítanak át, fontos tudni, hogy a látogatói és
felhasználói jogosultságok miatt egyes oldalakon (Időpontfoglalás, Blog, Profilom) tartalmi
és dizájnbéli eltérések vannak.

***Menü fejléc PC - n (személyi számítógépen)***

***Menü fejléc táblagépen és telefonon mielőtt a 3 vízszintes vonal ikonra kattintasz***

***Menü fejléc táblagépen és telefonon miután a 3 vízszintes vonal ikonra kattintottál***

Amint a [szellakozmetika.hu](szellakozmetika.hu) címre átkerültél, meg fogod látni fent ezt, fejlécet, a menüt.
Itt választhatsz az alábbiak közül:

- **Kezdőlap:** (gyakorlatilag vissza fog dobni téged a [szellakozmetika.hu](szellakozmetika.hu) -ra.) <u>Nem szükséges
regisztráció.</u>
- **Időpontfoglalás:** itt fogsz tudni időpontot kérni.
(átirányít a [szellakozmetika.hu/?p=idopont_foglalas](szellakozmetika.hu/?p=idopont_foglalas) oldalra.)
<u>Regisztrációhoz kötött.</u>


- **Szolgáltatásaink:** bemutatja a szolgáltatásokat, amiket igénybe lehet venni.
(átirányít a [szellakozmetika.hu/?p=szolgaltatasaink](szellakozmetika.hu/?p=szolgaltatasaink) oldalra.)
<u>Nincs szükség regisztrációra.</u>
- **Rólunk** : bemutatja a kutyakozmetikust / kutyakozmetikusokat, akik a szolgáltatásokat
nyújtják. (átirányít a [szellakozmetika.hu/?p=rolunk](szellakozmetika.hu/?p=rolunk) oldalra.)
<u>Nincs szükség regisztrációra.</u>
- **GY.I.K**: a gyakran ismételt kérdésekre itt lehet választ találni, kis sávok kérdésekkel,
kattintás után megjelenik a válasz. (a dokumentáció e részét ezen az oldalon meg lehet találni,
átirányít a [szellakozmetika.hu/?p=gyik](szellakozmetika.hu/?p=gyik) oldalra.)
<u>Nincs szükség regisztrációra.</u>
- **Blog**: a blogbejegyzések, témák, véleménykifejtés és élménybeszámolók és annak
hozzászólásainak fenntartott helye. (átirányít a [szellakozmetika.hu/?p=blog](szellakozmetika.hu/?p=blog) oldalra.)
Nem kötelező a regisztráció, megtekintés esetén, <u>csak akkor kell regisztrálnod hogyha te is
szeretnél hozzáadni tartalmat.</u>
- **Regisztráció:** itt tudunk felhasználói státuszra emelni a hozzáférési szintünket a látogatói
helyett, miután megadtuk a kötelező adatokat amit az űrlap kér. (átirányít a
[szellakozmetika.hu/?p=regsztracio](szellakozmetika.hu/?p=regsztracio) oldalra.)
- **Bejelentkezés:** miután regisztráltunk, itt kell megadni az e-mail-címünket vagy
felhasználónevünket, amit a regisztrációs oldalon megadtunk, ezután rányomunk a ’**Belépek!**’
gombra és be vagyunk jelentkezve, innen már szabadon élhetünk minden funkcióval.
(átirányít a [szellakozmetika.hu/?p=bejelentkezes](szellakozmetika.hu/?p=bejelentkezes) oldalra.)
<u>Regisztrációhoz kötött, ugyanis regisztráció nélkül nem lehet bejelentkezni.</u>
- **Profil**: miután bejelentkeztél, megtekintheted a saját adataidat, módosíthatod az adatok
többségét, profil és galéria képet tölthetsz fel, és a blog bejegyzéseidet tekintheted meg, más
felhasználókét is beleértve, ha tudod a felhasználónevüket.
(átirányít a [szellakozmetika.hu/?p=profil](szellakozmetika.hu/?p=profil) oldalra.)
<u>Regisztrációhoz kötött, a felhasználók megtekintése kivételével.</u>
- **Kijelentkezés** : Miután bejelentkeztél, a kijelentkezésre is lehetőséget biztosítunk. Amint
rákattintasz a gombra, visszakerülsz a ’ **Kezdőlapra**’.
(átirányít a [szellakozmetika.hu/?p=kijelentkezes](szellakozmetika.hu/?p=kijelentkezes) oldalra, majd [szellakozmetika.hu](szellakozmetika.hu)-ra)
<u>Regisztrációhoz kötött, mivel először be kell jelentkezni.</u>


Amint megnyitod a menüsáv alá tekintesz, láthatsz egy képet egy kutyáról, egy címet és alatta
egy gombot ahol időpontot foglalhatsz, ezt a gombot akkor nyomd meg ha regisztráltál és
bejelentkeztél (erről a következő alfejezetben olvashatsz hogy hogyan teheted meg).

**_Ábra: A kezdőlap._**

Ha lejjebb görgetsz, különböző szolgáltatásokat láthatsz, alattuk gombokkal, amik különböző
oldalakra dobnak át, az első az Időpont Foglalásra, a második a Kapcsolat, a harmadik pedig a
[kapcsolat@szellakozmetika.hu](kapcsolat@szellakozmetika.hu)-ra ahol megtárgyalhatóak az otthoni gondozás feltétélei és ára.

**_Ábra: A szolgáltatások ízelítője._**

Ezután pedig a referencia képek találhatóak, ahol megtekintheted a már regisztrált és időpontot
foglalt felhasználók kutyáiról készült képeket. Természetesen csakis az engedélyükkel és biz-
tosítottunk kedvezményt számukra, amiért segítik a kutyakozmetika hírnevét feltörekedni. (Mi-
vel még nincs kutyakozmetikához kötve a weblap, ezért csak jó néhány véletlenszerű képet
választottam az internetről.) Alatta pedig a mindenhol látható lábléc található, a menüsáv a
kezdet és a lábléc a vége minden oldalnak.

**_Ábra: A referenciaképek galériája._**

Bal oldalt lévő oszlopban, az Oldaltérképben minden lényegesebb oldalra való hivatkozás meg-
található. Középen a Közösségi média + Kapcsolatban a kutyakozmetika elérhetőségei, e-mail-
címe, telefonszáma és székhelye. A jobb oldalt pedig a jogi tudnivalók, a kevésbé olvasott oldal
hivatkozások, mint az Impresszum (az üzemeltető adatai), az Adatvédelmi Nyilatkozat és az
Általános Szerződési Feltételek.

**_Ábra: A lábléc._**

Biztosan észrevetted azt a lila gombot egy felfelé mutató nyíllal benne a képernyő alján jobb
oldalt, akármelyik oldalon görgetsz lefelé, ez egy ’ScrollToTop Button’ (én csak vissza fel gombnak hívom), azaz egy gomb amire, ha rákattintasz, vissza fog vinni Téged bármelyik oldal
legeslegtetejére.


## „A KÉRT OLDAL NEM TALÁLHATÓ”

Ez az oldal akkor jelenik meg hogyha egy olyan oldal címét írod be, ami nem létezik.

_Ábra: 404 - es hiba oldal, a lenti ’Kezdőlapra’ címre, ha rákattintasz, visszairányít a kezdőoldalra._

## DE MÉGIS HOGYAN REGISZTRÁLJ ÉS JELENTKEZZ BE?!

Ha még nem regisztráltál, (és végig néztél minden oldalt esetleg és tetszik, amit látsz) akkor
első lépésnek a jobbról hetedik menü elemre húzd a cursort, és kattints rá a ’ **Regisztráció** ’
gombra. Ezt követően, mint az előzőleg felsorolt listában, át fog irányítani Téged a
[szellakozmetika.hu/?p=regsztracio](szellakozmetika.hu/?p=regsztracio) oldalra.

Itt a ’ **Regisztráció** ’ oldalon, van egy űrlap, egy címmel, alatta egy szín-átmenetes csíkkal, 6
darab kitöltendő mezővel, ahol meg kell adnod:

- Vezetékneved, (csak betűket írhatsz be)
- Keresztneved, (csak betűket írhatsz be)
- Felhasználóneved, (az első karakternek betűnek kell lennie, utána használhatsz számokat és
aláhúzás gombokat)


- E-mail-címed, (kapcsolatfelvétel és bejelentkezéshez miatt szükséges, csak .hu, .com, .net
és .eu végződésű lehet)

- Jelszó (bejelentkezéshez szükséges, legalább 4 karakter, maximum 60)

- Jelszó ismét (a jelszó megerősítése miatt van rá szükség, ugyanaz az elvárás)

2 ’rádiógombbal’ oldottam meg a kérdését, hogy férfi vagy női nemhez tartozol, ezek közül a
csak az egyiket kell kiválasztani.

3 darab legördülő lista, az elsőből balról jobbra irányból haladva a születésnapod évét, azután
hónapját és napját kell megadnod.
Egy pár gyakori hibaüzenet, ami előfordulhat:

**_Ábra: Megkíséreltél betűn kívüli karaktereket beírni keresztnévnek._**

**_Ábra: Megkíséreltél betűn kívüli karaktereket beírni keresztnévnek._**

**_Ábra: Számmal vagy kisbetűvel kezdődött a felhasználóneved, vagy ékezetes betűket tartalmazott._**

**_Ábra: Nem végződött .hu, .net, .eu vagy .com - ra az e-mail- címed._**

### Első lépés: Regisztrálás

**_Ábra: A regisztráció űrlap._**

Itt, a regisztráció űrlapját láthatod, az előbb fent említett elemekkel. Balról-jobbra haladva
lefelé láthatsz szövegdobozokat. A ’ **Vezetéknév** ’ rubrikába írhatod be a vezetékneved, ehhez
csak kattints bele a ’Mi a vezetékneved?’ szövegbe. Ezután következik a ’**Keresztnév**’ mező,
itt egyértelműen a keresztnevednek kell szerepelnie. Itt kattints bele a ’Mi a keresztneved?’
szövegbe, ha esetleg szeretnéd megadni a harmadik nevedet is, itt megteheted, engedélyezünk
egy darab szóközt beírni a rubrikába, nem úgy, mint a Vezetéknévnél. Az ’**E-mail-címed** ’
dobozban megadhatod egy valós, hozzád tartozó e-mail-címedet. Fontos, hogy elsődleges e-
mail-címedet adj meg, mert itt is fogunk tudni értesíteni az időpontfoglalásod állapotáról,
kedvezményekről, elfogadásra került-e egy blog bejegyzésed / galéria képed stb. A ’ **Jelszó** ’ és
a ’ **Jelszó ismét** ’ mezőkbe írj be egy véletlen sorrendben választott karakter sorozatot, ami
állhat: kisbetűkből, nagybetűkből, számokból, szimbólumokból, annyi kikötése van viszont,
hogy szóközt nem használhatsz, biztonsági okokból illetően. Emellett, a ’ **Jelszó** ’ rubrika mellett
találsz egy szem alakú gombot, ha arra rákattintasz, megmutatja a jelszavadat, hogy eddig mit
írtál be, hogy a ’ **Jelszó ismét** ’ rubrikába is be tudd írni. A ’ **Jelszó ismét** ’ mellett pedig láthatsz
egy egyenlőség jelet, ha át van húzva, akkor a két jelszó nem egyezik, ha pedig az áthúzás eltűnt
és erőteljes fekete színe van, akkor a két jelszó megegyezik. Ezután a nemed kiválasztásához
válaszd ki az egyik ’rádiógombot’, hogyha Úr vagy akkor kék a kijelölt gomb belseje, ha pedig
nő, akkor rózsaszín. A ’Mikor születtél?’ cím alatt találsz három legördülő listát, magától
értetődően a születésnapodnak a dátumát kell megadni. Jobb megoldásnak bizonyult
(legalábbis szerintem és a tesztelők szerint) hogy nem egy naptárt használtunk, telefonon és
valamelyik táblagépeken nem működött megfelelően, ellehetetlenítette a regisztrációt. Ha
esetleg már van fiókod, akkor kattints rá a ’Már van fiókod, Szella tag vagy?’ alatti ’**Igen, Bejelentkezek!**’ hivatkozásra, ugyanúgy át fog irányítani a bejelentkezés űrlapra, akárcsak, ha
most regisztrálnál és érvényesítenéd a legalul található ’ **Regisztrálok!** ’ gomb megnyomásával.

**_Ábra: A gomb, amit meg kell nyomnod a regisztráció űrlap alján a fiókod érvényesítéséhez._**

Ha nem kaptál semmilyen hibaüzenetet és megjelent ez a felugró ablak, akkor sikeresen
regisztráltál és át lettél irányítva a bejelentkezés űrlapra.

### Második lépés: Bejelentkezés

**_Ábra: A bejelentkezés űrlap._**

Most hogy a regisztrációval megvagy, a weblap rögtön átirányít a bejelentkezéshez, itt van 2
kitöltendő mező, az elsőben az ’**E-mail-cím vagy Felhasználónév** ’ cím alatt a regisztráció
során megadott e-mail-címedet vagy felhasználónevedet beírva garantáltan el fogja fogadni. A
jelszónál a pedig a regisztrációnál már ismerős ’ **Jelszó** ’ és ’ **Jelszó ismét** ’ rubrikába beírt
karaktersorozatot kell beírnod. Ekkor már csak rá kell kattintanod a ’ **Belépek!** ’ gombra alul.
Ha sikeresen bejelentkeztél, hibaüzenetet ábrázoló ablakok helyett ezt a felugró ablakot kaptad,
akkor már hivatalosan is Szella tag vagy és élvezheted a [szellakozmetika.hu](szellakozmetika.hu) nyújtotta
funkciókat!

**_Ábra: A sikeres bejelentkezést igazoló felugró ablak, ami a keresztneveden szólít._**

A bejelentkezés után át fog irányítani a ’Profilom’ oldalra, az újonnan létrehozott profilodra.


## A PROFIL OLDAL, MINDEN, AMI VELED KAPCSOLATOS

**_Ábra: A profilod a te szemszögedből._**

A ’Profilom’ oldalon láthatsz ismét fentről lefelé és balról jobbra irányban sorrendben haladva
a következőket: **Egy köszöntő üzenet** , ami már első alkalommal fogad, első bejelentkezés után.
Ha többször jelentkezel be, akkor már másmilyen üzenetet fogsz kapni. A **profilképed** a
baloldalon található, mindenkinek ugyanaz a szürke, egyszerű alapértelmezett profilkép kerül
behelyezésre, ameddig a ’ **Kép feltöltése** ’ vagy a ’ **Profil Módosítása** ’ gombra kattintva nem
adunk meg egy újat (erről később). Középen, egy pár információt láthatsz, mint: a
**születésnapod dátuma** , **a regisztrációd dátuma,** és jobb oldalon pedig a **legutóbbi belépéseid dátumát**. Más felhasználók láthatják a profilodat, de nem ezekkel kényes az
adatokkal, korlátozottan, de láthatják a legutóbbi bejelentkezésed dátumát, mikor regisztráltál,
a galériába feltöltött képeket, a blog bejegyzéseidet, profilképedet, emellett a blog
bejegyzésekhez fűzött hozzászólásaidat és a születésnapodat csak más regisztrált felhasználók
láthatják, biztonsági okokból adódóan a látogatók nem. Ezt követően, van 4 darab gomb, az
első az a ’ **Profil módosítása** ’. Erre a gombra kattintva tudod megváltoztatni a
felhasználónevedet és az e-mail-címedet, ha bármi okból kifolyólag változtatásokra van
szükség. (például: feltört e-mail-cím, Felhasználási Feltételekbe ütköző felhasználónév stb.)
Mind a profil tulajdonosát, más bejelentkezett felhasználókat és a látogatók is értesülhetnek
arról hogy még nem töltöttél fel képeket a galériádba, ez a ’[Felhasználóneved] még nem töltött
fel képet a galériájába’ cím alatt fognak megjelenni, az első kép feltöltése után ez a cím
megváltozik és kis, 270 pixel magas és széles képek formájában jelennek meg egymás mellett.
A jobb oldalon kimutatja, hogy nem írtál még blog bejegyzéseket a ’Blog’ menüponton belül,
ha pedig már írtál, a ’[Felhasználóneved] még nem írt blog bejegyzést!’ cím a galériához
hasonlóan, megváltozik. A cím alatt meg fognak jelenni a bejegyzéseid címei egymás alatt, ha
már 3-4 bejegyzésnél többet írtál, akkor görgethetővé válik a blog bejegyzések listája, erre a
telefonon és táblagépeken való kényelmesebb használat érdekében van szükség.

**_Ábra: A profilod a látogatók szemszögedből._**

## A SAJÁT KUTYÁD / KUTYÁID HOZZÁADÁSA

A második gomb, a ’ **Kutya hozzáadása** ’ segítségével, adhatod hozzá a profilodhoz a te saját
kutyádat, a regisztrációhoz némileg hasonló űrlap fog fogadni.

**_Ábra: A kutyád hozzáadásához való űrlap._**

Itt három darab szövegdobozt, a kutyád nevét (becenevet is elfogadunk), a kutyád fajtáját és a
szőre színét kell megadnod. Van 2-2 ’rádiógomb’, a regisztrációhoz hasonlóan a kutyád nemét
kell megadnod az előbbinél, ezt követően a születésnapját a kutyádnak, ha nem tudod pontosan,
akkor egy adj meg egyet, amit úgy érzel, hogy közel áll az igazihoz. Az előbb említett másik
kettő rádiógombnál csak válaszolnod kell, hogy ivartalanítva van-e, vagy sem.

Hogyha mindent megfelelően kitöltöttél, és rányomtál a ’ **Kutya hozzáadása** ’ gombra, akkor
már az időpontfoglalásra is jogosult vagy.


## ÚJ JELSZÓRA VAN SZÜKSÉG

**_Ábra: A jelszavadat ezen űrlapon keresztül változtathatod meg._**

A harmadik gomb a jelszó módosításáért felelős, az adat kényessége érdekében külön
választottam a ’ **Profil módosítása** ’ gombtól. A jelszó egy fokkal kényesebb adat, mint a
felhasználónév vagy az e-mail-cím. Az űrlapon található három szövegdoboz: Az elsőbe
a, ’ **Régi jelszó** ’ rubrikába a mostani jelszavadat írd be, erre biztonsági okokból van szükség. A
további kettőbe az ’ **Új jelszó** ’ és az ’ **Új jelszó újra** ’ (hasonlóan, mint előzőleg a Regisztrációs
űrlapon tetted!) rubrikába pedig az új, a mostani jelszóval nem megegyező jelszót adj meg.


## KÉPEID FELTÖLTÉSE

A negyedik gomb, a **’Kép feltöltése** ’ fontos szerepet játszik: Itt tudsz képeket feltölteni a
galériádba a kutyáidról például. A gombra kattintva át fog irányítani egy űrlapra, ahol csak ki
kell választanod egy képet, aminek a kiterjesztése az alábbi 4 lehet: **Joint Photographic Experts Group** / **.JPG** vagy **.JPEG**; **Portable Network Graphics** / **.PNG** ; **Graphics Interchange Format** / **.GIF** és **Web Picture**, azaz **.WEBP** végződésű lehet. (Ha átnevezed, a
képet mondjuk ’**pelda.jfif**’ -ről ’**pelda.png**’ -re az hibát fog eredményezni, vagy legalábbis nem
fogja beállítani profilképnek vagy galériába feltölteni az adott képet. Tanácsos keresnünk egy
másik képet vagy használjunk konvertáló szoftvereket!)

**_Ábra: A képfeltöltést ezen az űrlapon végezhetjük el._**
Csak kattints rá a ’ **Kép kiválasztása** ’ gombra, tallózd ki a képeid közül azt a képet, amelyiket
szeretnéd feltölteni és kattints rá a ’ **Kép feltöltése a Galériába** ’ gombra. Ellenkező esetben,
hogyha profilképnek szeretnéd, akkor bele kell kattintanod a ’ **Szeretném ezt a képet profilképnek.** ’ szöveg melletti jelölőnégyzetbe, onnét bizonyosodhatsz meg afelől, hogy a
profilképednek lesz beállítva a kép, hogyha a jelölőnégyzetben lévő tér lila színűre váltott, egy
fehér pipával a közepében.

**_Ábra: A jelölőnégyzet kijelölt állapotban, tehát a kép profilképként lesz feltöltve._**

Ezután már csak a ’ **Profilkép feltöltése** ’ gombra kell rákattintanod, azonnal át fog irányítani
a ’Profilom’ oldalra hogy megtekinthesd a változást.


## A GALÉRIA

A galériád az utolsó előtti eleme a profilodnak, itt fognak megjelenni azok a képek, amelyeket
a ’Kép feltöltése’ gomb megnyomása és a ’Szeretném ezt a képet profilképnek.’ jelölőnégyzet
figyelmen kívül hagyása után, a ’ **Kép feltöltése a Galériába** ’ gomb nyomása / kattintása után.
A galéria képet dizájn szempontjából (főleg táblagép nézetben) az Instagram közösségi média
platform kép megjelenítése ihlette. Ahogy a képernyő szélessége csökken, úgy egy sorban
egyre kevesebb képet jelenít meg, és átteszi őket egy új sorba. Ez személyi számítógépek
esetében jellemzően 6-10 képet fog megjeleníteni egy sorban, táblagépeken 6-3 képet, és
telefonokon 3-1 képet, megadva a híres közösségi média által nyújtott görgetési élményt.

**_Ábra: A feltöltött képeid a Galériában a te szemszögedből. A galéria fölött található egy cím, amely kiírja, a mennyiségét a feltöltött képeidnek._**

**_Ábra: Ez a cím mást ír ki ha nincs képed feltöltve, ha pedig van akkor a mennyiség számát._**

A képek szabványosan maximum 270-szer 270 pixel magasak és szélesek lehetnek, közöttük
10 - 10 pixel keskeny távolsággal és 10-10 pixel sor magassággal, ez a megkülönböztetés
érdekében van, hogy a képek ne folyjanak egybe. Minden képet amit feltöltöttél,
megváltoztatott névvel kerülnek fel (ezt akkor láthatod ha rákattintasz a képre). A kép neve a
dátumából, amikor feltöltötted a képet, a profilod sorszáma és egy pár véletlenszerű betűből
álló karaktersor. Erre biztonsági okokból, (hogy a feltöltött képeidet ne tudják eltulajdonítani
következmények nélkül!) és szerzői jogokból adódó konfliktusok és perek elkerülése végett
van szükség. A legtöbb kép esetében nincs tökéletes pontossággal arányban a szélesség és
magasság, ezért némi egyszínű háttérrel kitölti automatikusan a galéria a képet, így nem is
kötelező a képre kattintanod, hogy megtekinthesd az eredeti képet, egy külön oldalon
(lehetséges hogy még kisebb méretben, itt kép minőségi problémák felléphetnek, jellemzően nagyobb méretben fogja mutatni a képet jó minőségben). Ha mégis egyforma magas és széles
a kép, abban az esetben az egész rendelkezésre álló teret (270×270 pixel) kitölti a kép.

**_Ábra: A bal oldali képen elég a fekete háttérre kattintunk, amíg a jobb oldalon csak a képre tudunk._**

**_Ábra: A kép megjelenítve egy új lapon miután rákattintottál._**

**_Ábra: A kép URL - címe és neve a böngésző felső keresőjében._**

## A BLOG, KISKAPU A KÖZÖSSÉGEDHEZ

Itt a blog oldalán, jobb oldalt láthatsz egy oszlopot, legfelül jelezve, hogy a Blog Témák itt
találhatóak, rögtön alatta a ’ **Blogbejegyzés írása** ’ gombot és alatta minden blogbejegyzés /
téma jelen van, csak rá kell kattintanod egyre és átirányít.

**_Ábra: A blog, mielőtt böngészel a témák között._**

**_Ábra: A blogbejegyzés hozzáadásának űrlapja._**

Hogyha rákattintottál a ’ **Blogbejegyzés írása** ’ gombra, ez az űrlap fogad, itt meg kell adni a
bejegyzésed címét, ami maximum **70** karakter lehet, a tartalma a bejegyzésed pedig **1000** ,
opcionálisan hozzáadhatsz egy képet is, ugyanazokkal a feltételekkel, mint a többi helyen, ahol
képet lehet feltölteni, csak JPG, PNG, WEBP és .GIF fájlokat fogad el 200x200 pixel magasság
és szélesség minimummal.


**Sikerüzenet** hogyha elküldted a blog bejegyzést és nem csatoltál hozzá képet:

**Sikerüzenet** hogyha elküldted a blog bejegyzést és csatoltál hozzá képet:

Abban az esetben hogyha a blog bejegyzés címe nagyobb mint 70 karakter:

Hogyha a blog bejegyzés tartalma hosszabb mint 1000 karakter: (ennyinek tényleg elégnek kell
lennie!)


Miután rákattintottál az egyik témára / bejegyzésre a sok közül, legfelül látható lesz a címe,
alatta egy kép, amit hozzáadott a poszt szerzője és a tartalma, mondanivalója.

**_Ábra: Egy teszt jellegű bejegyzés._**

Alatta látható a hozzászólások száma, ha nincs hozzászólás, akkor egy színes ösztönző
szöveg ’ **Legyél te az első hozzászóló!** ’ jelenik meg. Még azalatt pedig lehetőséged nyílik
hozzászólást írni, az ’**Új hozzászólás**’ cím alatti szövegdobozban írhatod le a véleményedet
1000 maximum karakter hosszan. Még fűzhetsz hozzá egy képet a lila ’ **Kép hozzáadása** ’ gomb
segítségével, végül egy linket is csatolhatsz a hozzászólásodhoz, ha szeretnél.

**_Ábra: A hozzászólás űrlapja._**

## ITT AZ IDŐ IDŐPONTOT FOGLALNOD!

Az időpontfoglalás a legfontosabb funkciója ennek a weblapnak, itt lehet igénybe venni a
kutyakozmetika adta szolgáltatásokat, minden hétköznap reggel 8-tól 17-óráig, egy
időpontfoglalás kereken 1 óra. A felépítés így néz ki: legfelül látható a kutyád / kutyáid listája,
ha még nem tetted meg, a ’ **Kutya Hozzáadása** ’ oldalon hozzáadhatod. Ezután található egy
legördülő lista, kattints rá a „-Válassz szolgáltatást! -” szövegre, megjelennek a szolgáltatások,
a nevük és mellette az áruk forintban. Majd 3 darab gomb, az első gombbal az előző hétre
mehetsz vissza, a „Most” gombbal a jelenlegi hétre, a „ **Következő hét** ” gombra nyomva pedig
a következő hét elérhető időpontjai közül válogathatsz, amelyek elérhetőek.

**_Ábra: Az időpontfoglalás táblázata._**

**_Ábra: A kutyakozmetika szolgáltatásai._**

A használata elég egyszerű, ha egy kutyád van, a weblap automatikusan kiválasztja neked, máskülönben szabadon választhatsz, hogy melyik kutyádnak szeretnél időpontpontot
lefoglalni.


**_Ábra: Ha több kutyád van, kattints a rádiógombra (szürke szélű pöttyre a kutya neve mellett balra)!_**

Ha kiválasztottad a kutyádat, a szolgáltatást és a lent látható táblázatban kijelöltél egy jelölő
négyzetet az időpont órája mellett, akkor négyzet belseje lila színűvé válik és egy fehér pipa is
megjelenik.


**_Ábra: Foglalt időpont, lejárt időpont, és az az időpont, amit lefoglalni készülsz miután kijelölted._**

**_Ábra: Az időpontfoglalás gomb nem megnyomható állapotban._**

Ekkor a legalul található „ **Időpontfoglalás** ” gombnak fehér színűnek kell lennie, csak akkor
tudod lenyomni ezt a gombot, ha kiválasztottál egyetlen egy időpontot.

**_Ábra: Az időpontfoglalás gomb megnyomható állapotban, miután kiválasztottál egy időpontot._**

Az egy dolog, hogy az időpontfoglalás gomb elérhető miután kiválasztottál egy időpontot, de
felléphetnek hibaüzenetek a következő esetekben:

**Sikerüzenet** hogyha szabad időpontot foglaltál, a kutyádat és a szolgáltatást is kiválasztottad:

**_Ábra: A sikeres időpont foglalás, formázott dátummal ás a kiválasztott kutya nevével._**

Hogyha a kiválasztott időpont 1 órán belül fog megtörténni, akkor ez a hibaüzenet fogad (ezzel
is elkerülve az elkapkodott munka esélyeit):

**_Ábra: A sikertelen időpont foglalás, 1 órán belül történő időpontok esetén._**

Hogyha kiválasztottad a kutyát és az időpontot, de a szolgáltatást nem:

**_Ábra: Szolgáltatás választás nélkül nem lehetséges időpontot foglalni._**

Hogyha több kutyád van és elfelejtetted kiválasztani az egyiket, de viszont a szolgáltatásról már
döntöttél, hogy melyik legyen és időpontot is választottál:

**_Ábra: Kutya választás nélkül nem lehetséges időpontot foglalni._**

Miután sikeresen időpontot foglaltál, vissza leszel irányítva a Kezdőlapra, egy lila emlékeztető ablak fog megjelenni 5 másodperc múlva, akárhányszor a Kezdőlapon tartózkodsz, egyszeri alkalommal meg fog jelenni. Van a jobb felső sarkában egy X gomb, ami bezárja, egy zöld ’**Rendben**’ gomb az ablak alján, és feketésháttérrel, ha oda nyomsz vagy kattintasz, akkor is eltűnik az emlékeztető. Szürkés-fehéres háttérrel mutatjuk az igénybevételed részleteit: melyik kutyádnak foglaltad az időpontot, mikorra szól az időpont, milyen szolgáltatást kértél számára, mennyibe kerül a szolgáltatás és a hátralévő idő. A hátralevő idő jelzi, hogy mikor kell
itt lennetek a kutyakozmetikánál. Ha kevesebb mint 1 nap, akkor már piros lesz a szöveg, máskülönben fekete.

**_Ábra: Az emlékeztető ablak._**

Ezzel a végére értünk a felhasználói dokumentációnak. Remélem segítséget nyújtott abban,
hogy el tudj igazodni a szellakozmetika.hu-n és hogy örömödet fogod lelni amikor ezen a webes
alkalmazáson tevékenykedsz, szívemet-lelkemet bele adtam csak hogy elnyerje tetszésedet.

# IRODALOMJEGYZÉK

Véletlenszerű képek a kezdőlapon:
[https://picsum.photos/](https://picsum.photos/)
Egy pár gyöngyszem a Tutorial Pokolból: Segítséget nyújtott a menü dizájnhoz:
[https://www.youtube.com/watch?v=kNiic1CaXrQ&ab_channel=CODEWITHHOSSEIN](https://www.youtube.com/watch?v=kNiic1CaXrQ&ab_channel=CODEWITHHOSSEIN)

Az összes űrlap inspirálója:
[https://www.codinglabweb.com/2021/01/responsive-registration-form-in-html-css.html](https://www.codinglabweb.com/2021/01/responsive-registration-form-in-html-css.html)

„Aki nem használja az nem is szoftverfejlesztő:”
[https://www.w3schools.com/](https://www.w3schools.com/)

Még a blog bejegyzés hozzáadása címéhez is inspirációt adott a kezdőlap címe:
[https://stackoverflow.com/](https://stackoverflow.com/)

Rengeteg, de rengeteg segítséget nyújtott a JavaScript megértéséhez:
[https://webiskola.hu/egyeb/javascript-konyvek/](https://webiskola.hu/egyeb/javascript-konyvek/)

[https://jquery.com/](https://jquery.com/)

Kedvenc tanárom kincsesbányája tudás szempontjából:
Űrlap-elemek HTML-ben:
[http://infojegyzet.hu/webszerkesztes/html/urlapok/](http://infojegyzet.hu/webszerkesztes/html/urlapok/)

PHP alapok:
[https://www.php.net/](https://www.php.net/)
[http://infojegyzet.hu/webszerkesztes/php/alapok/](http://infojegyzet.hu/webszerkesztes/php/alapok/)

Képgaléria:
[http://infojegyzet.hu/webszerkesztes/php/kepgaleria/](http://infojegyzet.hu/webszerkesztes/php/kepgaleria/)

Záródolgozat szempontok:
[http://infojegyzet.hu/webszerkesztes/zarodolgozat/](http://infojegyzet.hu/webszerkesztes/zarodolgozat/)

Az ’aktorok’ kép a ’Lehetőségeid ismertetése a weblapon’:
horgaszcuccok.eu dokumentáció, (2020) a szerző engedélyével

Könyvek:

Édesapámtól kaptam 19. születésnapomra, képfeltöltés terén elengedhetetlen volt:
Wankyu Choi · Allan Kent · David Mercer · Dave W. Mercer · Steven D. Nowicki · Dan
Squier: Bevezetés a PHP5 programozásba.

Sokat segített a MySQL elsajátításában:
Laura Thomson - Luke Welling: PHP és MySQL webfejlesztőknek


# ÖSSZEGZÉS

Magabiztosan kijelenthetem, hogy mindent beleadtam ebbe a szakdolgozatomba, amit csak
tudtam, kimondottan meg vagyok elégedve vele. Rengeteget tanultam a PHP, MySQL, HTML,
CSS és JavaScriptről, és még annyi minden van, amit meg szeretnék ezekből a nyelvekből
tanulni, és rengeteg órát és energiát fektettem bele, sok osztálytársam tiszteletét vívtam ki
meglepő módon. Még rengeteg munka lesz ezzel a weblappal, szinte már látomásaim vannak,
és nem félek a nyaramat is rááldozni, hogy egy ténylegesen felhasználható interfészt adhassak
kezdő kutyakozmetikusok kezébe. A dizájn rész volt a legélvezetesebb, a Back End is tartogat
/ tartogatott némi kihívást, de ha Isten is úgy akarja, egy nap sikeres Front End fejlesztő /
programozó leszek saját csapattal.

# KÖSZÖNETNYILVÁNÍTÁS

Keresztény létemre először is szeretném megköszönni Istennek, hogy ez a szakdolgozat
megszülethetett és elkészülhetett a határidőig és mellém adott mindenkit, aki segíteni tudott.
Szeretném megköszönni Kovács László tanár úrnak a megszámlálhatatlan sok jóindulatát,
tanácsait, tanítással eltöltött órákat és biztatását. Köszönöm Czapp Sándor Elek tanárúrnak,
hogy segített az adatbázis ábrában, és az ’aktorok’ kép megtervezésében a ’Lehetőségeid
ismertetése a weblapon’. Köszönöm Fodor Péternek és Englert Ervin (még akkor is, ha ebben
az évben nem tanított, de külön órákon jelen voltam) tanárúrnak a C# órákat. Köszönöm 2 jó
barátomnak, Puskás Bendegúznak és Sós Máténak amiért áprilisban segítettek átvészelni egy
szakítást. Köszönöm, mindenkinek, aki letesztelte a szakdolgozatomat, Dr. Páll Istvánnak,
Balla Renátának a visszajelzéseit. Köszönöm Tóth Norbert, Erdős Ádám András, Schlitt Henrik
János és Holka Ottó József osztálytársaim szakmai és dizájn béli visszajelzésit, kritikáit. Külön
köszönöm nagymamám, Varga Istvánné és mostoha nagyapám Varga István végtelen
szeretetét, pénzügyi és lelki támogatását és hogy befogadott a nehéz idők kellős közepén. Nem
utolsó sorban szeretném megköszönni Neked, aki elolvasta ezt a dokumentációt, Érted is
készült ez a szakdolgozat. És szeretném megköszönni előre is azoknak a szakembereknek, akik 06.01. reggelén veszik a fáradságot és értékelitek a munkásságomat.