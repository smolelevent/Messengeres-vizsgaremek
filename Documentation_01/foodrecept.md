# TARTALOM

ABSZTRAKT

Fejezetek oldalszáma

1. **BEVEZETÉS**
    1. Problémanyilatkozat
 2. Célok
 3. Motiváció
2. **IRODALMI FELMÉRÉS**

1. Problémanyilatkozat
 2. Célok
 3. Motiváció
2. **IRODALMI FELMÉRÉS**


1. **SZOFTVERKÖVETELMÉNYEK SPECIFIKÁCIÓI**
 1. Külső interfész követelmények

Nem funkcionális követelmények

1. **RENDSZERTERVEZÉS**
 1. Rendszerarchitektúra
 2. Használati esetdiagram
 3. Entitáskapcsolati diagram
 4. Adatbázis bejegyzések
 5. Android alkalmazástervezés
 6. Tevékenységi diagram
 7. Osztálydiagram
2. **VÉGREHAJTÁS**
 1. Környezetvédelmi beállítások
 2. Modul leírása
 3. Szoftver leírás 
 4. Kódminta 

1. **RENDSZERTESZTELÉS**
 1. Tesztek
2. **EREDMÉNYKÉPERNYŐKÉPEK **

1. **KÖVETKEZTETÉS **
2. **BIBLIOGRÁFIA **

# ÁBRÁK JEGYZÉKE

1. ábra: Rendszer architektúra 5

2. ábra: Használati eset diagram a fejlesztő számára 6

3. ábra: Használati eset diagram a felhasználó számára 7

4. ábra: Entitáskapcsolati diagram 8

5. ábra: A francia konyha adatbázis-bejegyzései 9

6. ábra: Az olasz konyha adatbázis-bejegyzései 10

7. ábra: A mexikói konyha adatbázis-bejegyzései 11

8. ábra: Android-tevékenységek 12

9. ábra: Tevékenységi diagram 13

10. ábra: Osztálydiagram 14

11. ábra: A felhasználó megtekinti a receptet 17

12. ábra: A recept nevének megtekintése 17

13. ábra: A fenti recept hozzávalói 18

14. ábra: A receptet kedvencként felvevő felhasználó 18

15. ábra: A felhasználó megtekintheti kedvenc receptjét 19

16. ábra: ÉPÍTÉSI FOKOZAT KÓDJA 21

17. ábra: A Widget_test.dart kódja 22

18. ábra: A Gradle Android alkalmazás KÓDJA 22

19. ábra: A lib main.dart kódja 23

20. ábra: KÓD SZAKÉSZEKNEK válogatta 25

21. ábra: KÓD AZ indiai konyhákhoz 30



# KÉPERNYŐKÉPEK LISTÁJA

SS 1: Alkalmazás interfész (I)  21

SS 2: Alkalmazás interfész (II) 21

SS 3: Alkalmazás interfész (III) 22

SS 4: Alkalmazás interfész (IV) 22

# <center>ABSZTRAKT

A mobileszközök használata jelentősen megnövekedett az elmúlt évtizedben. Mindezek az eszközök a számukra létrehozott alkalmazásokat használják. Ezek az alkalmazások számos különféle szolgáltatást nyújthatnak, beleértve a közösségi médiát, a zenei streaminget, a videostreaminget, az utazásmegosztást, az online vásárlást és a videojátékokat. Ezen alkalmazások némelyikének folyamatosan csatlakoznia kell az internethez a megfelelő működéshez, míg mások offline is működhetnek.

Ez a cikk egy többplatformos ételrecept-alkalmazást mutat be, amely segít a felhasználóknak különböző kategóriák alapján különböző ételreceptek megtalálásában és megtekintésében, valamint lehetővé teszi számukra, hogy intelligens keresőszűrők és kategóriák segítségével keressenek a számukra megfelelő receptek között. A felhasználók szűrhetik a receptlistát a receptben használt összetevők, az elkészítési idő, a főzési idő és az étrend alapján. Az alkalmazás arra törekszik, hogy hatékonyan fusson, miközben elegáns felhasználói élményt nyújt az online alkalmazások alapvető funkcióival, miközben teljesen offline marad.

# <center>1\. BEVEZETÉS

Napjainkra nyugodtan bevallhatjuk, hogy a világ elérte a globális falu formáját, ahol minden elérhető a technológián keresztül. A mobiltelefonok megjelenése sok ember életét átalakította. Nehéz elmúlni egy nap anélkül, hogy ne ellenőriznéd újra meg újra a közösségi hálózataidat. Ez pusztán azt állítja, hogy a mobilalkalmazások már bejárták az életünket. A kutatások azt mutatják, hogy a rendszeres otthoni ételek fogyasztása családként egészségesebb és boldogabb gyerekekhez és tinédzserekhez kapcsolódik, akik kevésbé hajlamosak alkoholt, drogokat vagy cigarettát fogyasztani. Butler szerint „Az elmúlt években az okos telefonok megjelenése megváltoztatta a mobiltelefonok definícióját. A telefon már nem csupán kommunikációs eszköz, hanem az emberek kommunikációjának és mindennapi életének elengedhetetlen része is. A különféle alkalmazások korlátlan szórakozást nyújtottak az emberek életében. Az biztos, hogy a hálózat jövője a mobilterminál lesz.”

**Probléma kijelentés:**

Mindegy, hogy az emberek szeretnek főzni, vagy egyszerűen csak enni, étel- és receptgyűjteményük van, amelyeket szívesen kipróbálnak. Talán van egy csomó, amit egy szeretett személytől kaptak. Mindkét esetben minden bizonnyal jobb módszerre van szükségük, hogy hosszú távon rendszerezzék őket, mint egy csomó indexkártyára egy fájlmappában, ami régi és unalmas. Ezért a telefonnal való főzés sokkal finomabb, ha a megfelelő receptek vannak.

A felnőttek is jelentős előnyökhöz jutnak, ha otthon főzött ételeket fogyasztanak. A kutatások azt mutatják, hogy azok az emberek, akik rendszeresen otthon készítenek ételt, általában boldogabbak és egészségesebbek, és kevesebb cukrot és feldolgozott élelmiszert fogyasztanak, ami magasabb energiaszintet és jobb mentális egészséget eredményezhet. A heti öt vagy több napos otthoni főzés még hosszabb élettartammal is jár.

**Célok:**

A projekt célja egy „Recetté” mobilalkalmazás kifejlesztése, amellyel a felhasználói konyhai ismeretek fejleszthetők, ahelyett, hogy irattárat használnának egy mappában. Más szóval, Recetté zsebes sous séffé varázsolja telefonját.

**Motiváció:**

A Recette alkalmazás egy nagyon hasznos alkalmazás azoknak, akik szeretnek főzni és új recepteket kipróbálni. Rugalmasságot biztosít a felhasználónak a receptek adatbázisból való kereséséhez és mentéséhez, valamint a már nem szükséges receptek törléséhez. Ez az alkalmazás időt takarít meg, és néhány kattintással recepteket biztosít. A felület tiszta és egyszerű. Kihasználja a Flutter konténerek képességét, hogy a kezdőképernyőn a lehetőségeket képikonokkal jelenítse meg. A felhasználó kereshet recepteket, megtekintheti a hozzáadott kedvenc receptek listáját a kezdőképernyőről.

# <center>2\. IRODALMI FELMÉRÉS

Meglévő rendszer:

Biztosan sok receptalkalmazás létezik, amelyek sokféle lehetőséget kínálnak a választásra, de a legtöbbjük csak online, és az offline alkalmazásokból hiányzik ez a sok lehetőség, és hiányzik a megfelelő UX és struktúra.

A megvalósíthatósági tanulmány, ahogy a neve is mutatja, a javasolt projekt gyakorlatiasságának felmérésére irányul. Amint az a kezdeti specifikációról szóló jelentésben szerepel, a projekt célja egy „Recetté” mobilalkalmazás kifejlesztése, amely a felhasználók konyhai készségeinek fejlesztésére és a bevásárlás egyszerűsítésére szolgál, ahelyett, hogy az indexkártyákat fájlmappában használnák.

Ajánlott rendszer:

Egy olyan alkalmazást fejlesztünk, amely segít azoknak, akiknek problémái vannak az internettel, miközben megtartjuk mindazokat a funkciókat, amelyek egy online alkalmazást nagyszerűvé tesznek, és több funkciót kínálnak, mint egyes meglévők.

Dart és flutter segítségével fejlesztjük natív alkalmazásunkat iOS-re, Androidra stb. A Dart/futter lehetővé teszi a fejlesztők számára, hogy egyetlen kódbázisból natív alkalmazásokat fejlesszenek több platformra.

Összegzés:

Ennek a lépésnek az a célja, hogy a követelmények következetesek, pontosak és teljesek legyenek, hogy megfeleljünk a végső eredményre vonatkozó elvárásoknak. Kétféle követelmény létezik: funkcionális és nem funkcionális. A funkcionális követelmények azok, amelyek leírják az alkalmazás funkcióit; mivel a nem funkcionális követelmények azok, amelyek az alkalmazás megszorításait és tulajdonságait mutatják be.

# <center>3\. SZOFTVERKÖVETELMÉNYEK SPECIFIKÁCIÓI

Külső interfész követelmények:

- Hardver

A mobilalkalmazás Android és iOS rendszeren fog működni.

- Szoftver

A mobilalkalmazás kompatibilis lesz a mobil és táblagép (Android alkalmazás) legutóbbi verziójával.

Fejlesztői követelmények**:**

- Hardverkövetelmények:
- OS: MacOS-64bit és Windows 7 (64bit) vagy újabb
- HDD: 1,23 GB Windows esetén vagy 2,8 GB MacOS for Flutter SDK esetén
- RAM: 4 GB (minimum)
- Processzor: Intel i3 3<sup>rd</sup>gen vagy AMD megfelelője
- Szoftverkövetelmények:
- OS: MacOS-64bit és Windows 7 (64bit) vagy újabb
- Eszközök: Flutter SDK
- Android Studio/Visual Studio Code vagy bármely más IDE-t támogató dart
- Git
- Windows Powershell 5.0 (csak Windows felhasználók számára)
- Felhasználói követelmények:
- Operációs rendszer: Android Jellybean vagy újabb és iOS 8 vagy újabb
- Hardver: iOS-eszközök (iPhone 4s vagy újabb) és ARM Android-eszközök
- Tárhely: ~200 MB
- RAM: 2 GB

Nem funkcionális követelmények:

A nem funkcionális elemzés a felhasználó érdeklődési szintjének alkalmazáselemzését tartalmazza.

Ez a rész elmagyarázza, hogyan tesztelik az alkalmazást ilyen módon, és megkapja a felhasználó értékelését a pályázat megfelelőségéről és állapotáról.

- Biztonság:

Az alkalmazáson belüli adatokat védeni kell a manipulációtól.

- Elérhetőség:

Az alkalmazásnak mindenkor elérhetőnek kell lennie az internetkapcsolat nélküli felhasználó számára.

- Használhatóság:

Jó UX/UI-val rendelkezik, elegáns dizájnnal és elegendő információval rendelkezik ahhoz, hogy a felhasználó teljes mértékben használhassa az alkalmazást.

- Teljesítmény:

Az alkalmazásnak érzékenynek kell lennie, és meg kell egyeznie a képernyő frissítési gyakoriságával.

- Termékkövetelmények:
    - Használhatósági követelmények:
        - Az alkalmazás legyen könnyen használható és intuitív.
        - Az alkalmazásnak felhasználóbarát felülettel kell rendelkeznie.
        - A grafikus felületnek egyszerűnek és áttekinthetőnek kell lennie.
- Teljesítménykövetelmények:
    - Az alkalmazásnak gyorsnak és robusztusnak kell lennie betöltéskor.
    - A program nem engedhet meg több mint 10 perc/év meghibásodást.
- Helyigény:
    - Az alkalmazásnak elegendő memóriával kell rendelkeznie ahhoz, hogy nagy mennyiségű adatot tároljon.
- Megbízhatósági követelmények:
    - Az alkalmazás nem adhat hibás kimenetet.
- Hordozhatósági követelmények:
    - A szoftvernek minden platformon működnie kell.

- Szervezeti követelmények:
    - Megvalósítási követelmények:

        - Az alkalmazást az Android Studio használatával kell megvalósítani.

- Külső követelmények:
    - Interoperabilitási követelmények:

        - Az alkalmazás lehetővé teszi a hozzáférést az alkalmazás különböző részlegeihez anélkül, hogy megváltoztatná annak hatékonyságát és következetességét.

- Etikai követelmények:

    - Az applikációnak licencmentesnek kell lennie.

# 4.RENDSZERTERVEZÉS

Rendszer architektúra:

![](img1.png)
<center>1. ábra: Rendszer architektúra</center>
A rendszerarchitektúra a rendszer felépítését és viselkedését írja le a különböző komponensek és a köztük lévő kapcsolatok ábrázolásával. Ennek a rendszernek az architektúrája egy mobil eszközből áll (iOS/Android), amely lehetővé teszi a felhasználók számára az alkalmazás és a rendszer különböző funkcióinak használatát.

Az adatbázis része az alkalmazásnak, amely a szótárak különböző listáiból áll.

Amikor a felhasználó kérést küld, az alkalmazás elküldi a kérés alapján a megfelelő paramétereket a List_buildernek, amely az adatbázis felhasználásával megfelelő választ generál.

Használati eset diagramok:

1. Használati esetdiagram a fejlesztő számára:

![](img2.png)
<center>2. ábra: Használati eset diagram a fejlesztő számára</center>
2. Felhasználói eset diagram:

![](img3.png)
<center>3. ábra: Felhasználói eset diagram</center>
Entitáskapcsolat diagram:

Ez a folyamatábra azt szemlélteti, hogy az „entitások”, például a felhasználók, objektumok vagy fogalmak hogyan kapcsolódnak egymáshoz egy rendszeren belül. Nyelvtani szerkezetet tükröznek, az entitásokat főnevekként, a kapcsolatokat pedig igékként.

![](img4.png)
<center>4. ábra: Entitáskapcsolati diagram</center>
Adatbázis bejegyzések: ![](img5.png)

<center>5. ábra: A francia konyha adatbázis-bejegyzései</center>
![](img6.png)
<center>6. ábra: Az olasz konyha adatbázis-bejegyzései</center>
![](img7.png)
<center>7. ábra: A mexikói konyha adatbázis-bejegyzései</center>


Android-alkalmazás tervezés:

Az Android felhasználói felülete a tevékenységek köré épül, amelyek egyetlen fókuszpont, amit a felhasználó megtehet. Ezek közvetlenül kapcsolódnak az alkalmazáshoz meghatározott funkcionális követelményhez. Az alábbiakban a felhasználói követelményekből származnak azok a tevékenységek, amelyeket végre kell hajtani a funkcionális követelmények teljesítése érdekében.

![](img8.png)
<center>8. ábra: Android-tevékenységek</center>
Tevékenység diagram:

Ez egy másik fontos viselkedési diagram az UML diagramban, amely leírja a rendszer dinamikus vonatkozásait. Lényegében a folyamatábra továbbfejlesztett változata, amely az egyik tevékenységről a másik tevékenységre való áramlást modellezi.

![](img9.png)
<center>9. ábra: Tevékenységi diagram</center>
Osztály diagram:

Az osztálydiagramok az objektumorientált modellezés fő építőelemei. A rendszer különböző objektumainak, attribútumainak, műveleteinek és a köztük lévő kapcsolatok bemutatására szolgál. Példánkban a „receptek” vannak ábrázolva.

![](img10.png)
<center>10. ábra: Osztálydiagram</center>
# 5.IMPLEMENTÁCIÓ

Környezetvédelmi beállítás:

1. A „Környezet” beállítása az alkalmazáshoz
2. Flutter beállítása

Rendszerkövetelmények:

A Flutter telepítéséhez és futtatásához a fejlesztői környezetnek meg kell felelnie az alábbi minimális követelményeknek:

- **Operációs rendszerek**: Windows 7 SP1 vagy újabb (64 bites), x86-64 alapú
- **Lemezterület**: 1,32 GB (nem tartalmazza az IDE/eszközök lemezterületét).
- **Eszközök**: A Flutter attól függ, hogy ezek az eszközök elérhetők-e a környezetében.
  - [Windows PowerShell 5.0](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-windows-powershell) vagy újabb (ez előre telepítve van a Windows 10 rendszerrel)
  - [Git for Windows](https://git-scm.com/download/win) 2.x, a **Use Git from the Windows Command Prompt** opcióval.

Ha a **Git for Windows** már telepítve van, győződjön meg arról, hogy tudja futtatni a git parancsokat a parancssorból vagy a PowerShellből.

Szerezze be a Flutter SDK-t

1. Töltse le a következő telepítőcsomagot a Flutter SDK legújabb stabil kiadásának beszerzéséhez:

[flutter_windows_1.22.5-stable.zip](https://storage.googleapis.com/flutter_infra/releases/stable/windows/flutter_windows_1.22.5-stable.zip)

Más kiadási csatornák és régebbi buildek megtekintéséhez lásd az [SDK releases](https://flutter.dev/docs/development/tools/sdk/releases) oldalt.

1. Bontsa ki a zip fájlt, és helyezze a benne lévő fluttert a Flutter SDK kívánt telepítési helyére (például C:\\src\\flutter).

&nbsp;**Figyelem:** Ne telepítse a Fluttert olyan könyvtárba, mint például a C:\\Program Files\\, amely magasabb jogosultságokat igényel.

Ha nem szeretné telepíteni a telepítőcsomag rögzített verzióját, akkor kihagyhatja az 1. és 2. lépést. Ehelyett szerezze be a forráskódot a
a GitHubon, és szükség szerint módosítsa az ágakat vagy címkéket. Például: 

![](img11_2.png)

Most már készen áll a Flutter parancsok futtatására a Flutter konzolon.

### Frissítse az PATH-et

Ha a Flutter parancsokat a normál Windows konzolon szeretné futtatni, tegye a következő lépéseket a Flutter PATH környezeti változóhoz való hozzáadásához:

- A Kezdő keresősávban írja be az „env” kifejezést, és válassza a **Környezeti változók szerkesztése a fiókhoz** lehetőséget.
- A **Felhasználói változók** alatt ellenőrizze, hogy van-e **Path** nevű bejegyzés:
 - Ha a bejegyzés létezik, fűzze hozzá a flutter\\bin teljes elérési útját a ; mint elválasztó a meglévő értékektől.
 - Ha a bejegyzés nem létezik, hozzon létre egy új Path nevű felhasználói változót, amelynek értéke a flutter\\bin teljes elérési útja.

A módosítások érvénybe léptetéséhez be kell zárnia, majd újra meg kell nyitnia minden meglévő konzolablakot.

&nbsp;**Megjegyzés:** A Flutter 1.19.0 fejlesztői kiadása óta a Flutter SDK a dart parancsot is tartalmazza a flutter parancs mellett, így könnyebben futtathatja a Dart parancssori programokat. A Flutter SDK letöltése a Dart kompatibilis verzióját is letölti, de ha a Dart SDK-t külön töltötte le, győződjön meg arról, hogy a dart Flutter verziója áll az első helyen, mert előfordulhat, hogy a két verzió nem kompatibilis. A következő parancs (macOS, linux és chrome OS rendszeren) megmondja, hogy a flutter és dart parancsok ugyanabból a bin könyvtárból származnak-e, és ezért kompatibilisek-e. (A Windows egyes verziói támogatják a hasonló where parancsot.)

![](img11.png)

Mint fentebb látható, a két parancs nem ugyanabból a bin könyvtárból származik. Frissítse az elérési utat, hogy a /path-to-flutter-sdk/bin parancsokat a /usr/local/bin parancsok előtt használja (ebben az esetben). A shell frissítése után, hogy a változás érvénybe lépjen, a which vagy where parancs ismételt futtatása azt mutatja, hogy a flutter és a dart parancsok ugyanabból a könyvtárból származnak.

![](img11_1.png)

Ha többet szeretne megtudni a dart parancsról, futtassa a dart -h parancsot a parancssorból, vagy tekintse meg a [dart tool](https://dart.dev/tools/dart-vm) oldalon.

Futtassa a flutter doctor-t

Egy olyan konzolablakból, amelynek elérési útjában a Flutter könyvtár található (lásd fent), futtassa a következő parancsot, hogy megnézze, vannak-e platformfüggőségek, amelyekre szüksége van a telepítés befejezéséhez:

![](img11_3.png)

Ez a parancs ellenőrzi a környezetet, és jelentést mutat meg a Flutter telepítés állapotáról. Gondosan ellenőrizze a kimenetet, hogy nem talál-e más szoftvereket, amelyeket esetleg telepíteni kell, vagy további feladatokat kell végrehajtania (**félkövér** szöveggel).

Például:

![](img11_4.png)

A következő szakaszok leírják, hogyan kell végrehajtani ezeket a feladatokat és befejezni a telepítési folyamatot. Miután telepítette a hiányzó függőségeket, újra futtathatja a flutter doctor parancsot, hogy ellenőrizze, hogy mindent megfelelően állított-e be.

&nbsp;**Megjegyzés:** Ha a flutter doctor azt állítja, hogy az Android Studio Flutter vagy Dart beépülő modulja nincs telepítve, lépjen tovább a [Set up an editor](https://flutter.dev/docs/get-started/editor?tab=androidstudio) részhez a probléma megoldásához.

&nbsp;**Figyelem:** A flutter eszköz a Google Analytics segítségével anonim módon jelentheti a funkcióhasználati statisztikákat és az alapvető [összeomlási jelentéseket](https://github.com/flutter/flutter/wiki/Flutter-CLI-crash-reporting). Ezeket az adatokat a Flutter-eszközök idővel történő fejlesztésére használjuk fel.

A Flutter eszköz elemzését a rendszer nem küldi el a legelső futtatáskor. A jelentéskészítés letiltásához írja be a flutter config --no-analytics parancsot. Az aktuális beállítás megjelenítéséhez írja be a flutter config. Ha leiratkozik az analitikáról, a rendszer leiratkozási eseményt küld, majd a Flutter eszköz nem küld további információkat.

A Flutter SDK letöltésével Ön elfogadja a Google Általános Szerződési Feltételeit. Megjegyzés: A Google [Adatvédelmi irányelvei](https://policies.google.com/privacy) leírja, hogyan kezeljük az adatokat ebben a szolgáltatásban.

Ezenkívül a Flutter tartalmazza a Dart SDK-t, amely használati mutatókat és hibajelentéseket küldhet a Google-nak.

Android beállítás

&nbsp;**Megjegyzés:** A Flutter az Android Studio teljes telepítésére támaszkodik az Android-platformfüggőségek biztosításához. A Flutter-alkalmazásokat azonban számos szerkesztőben megírhatja; egy későbbi lépés ezt tárgyalja.

Telepítse az Android Studio alkalmazást

1. Töltse le és telepítse az [Android Studio](https://developer.android.com/studio) alkalmazást.
2. Indítsa el az Android Studio alkalmazást, és menjen végig az „Android Studio beállítási varázslón”. Ezzel telepíti a legújabb Android SDK-t, az Android SDK Command-line Tools-t és az Android SDK Build-Tools-t, amelyekre a Flutternek szüksége van az Androidra való fejlesztéskor.

### Állítsa be Android-eszközét

A Flutter alkalmazás Android-eszközön való futtatására és tesztelésére való felkészüléshez Android 4.1-es (16-os API-szintű) vagy újabb rendszert futtató Android-eszközre van szüksége.

1. Engedélyezze a **Fejlesztői beállítások** és az **USB-hibakeresés** lehetőséget eszközén. A részletes utasítások az [Android dokumentációjában](https://developer.android.com/studio/debug/dev-options) találhatók.
2. Csak Windows esetén: Telepítse a [Google USB-illesztőprogramot](https://developer.android.com/studio/run/win-usb).
3. USB-kábellel csatlakoztassa telefonját a számítógéphez. Ha az eszköz kéri, engedélyezze számítógépének az eszköz elérését.
4. A terminálon futtassa a flutter devices parancsot annak ellenőrzésére, hogy a Flutter felismeri-e a csatlakoztatott Android-eszközt. Alapértelmezés szerint a Flutter az Android SDK azon verzióját használja, amelyen az adb-eszköz alapul. Ha azt szeretné, hogy a Flutter az Android SDK egy másik telepítését használja, akkor az ANDROID_SDK_ROOT környezeti változót az adott telepítési könyvtárba kell beállítania.

Állítsa be az Android emulátort

A Flutter alkalmazás Android emulátoron való futtatására és tesztelésére való felkészüléshez kövesse az alábbi lépéseket:

1. Engedélyezze a [VM-gyorsítást](https://developer.android.com/studio/run/emulator-acceleration) a számítógépén.
2. Indítsa el az **Android Studiot**, kattintson az **AVD Manager** ikonra, és válassza a **Virtuális eszköz létrehozása…** lehetőséget.
 - Az Android Studio régebbi verzióiban inkább indítsa el az **Android Studio > Eszközök > Android > AVD Manager** lehetőséget, és válassza a **Virtuális eszköz létrehozása…** lehetőséget. (Az **Android** almenü csak akkor érhető el, ha egy Android-projekten belül van.)
 - Ha nincs megnyitott projektje, válassza a **Konfigurálás > AVD-kezelő**, majd a **Virtuális eszköz létrehozása…** lehetőséget.
3. Válassza ki az eszközdefiníciót, majd válassza a **Tovább** lehetőséget.
4. Válasszon ki egy vagy több rendszerképet az emulálni kívánt Android-verziókhoz, majd válassza a **Tovább** lehetőséget. _x86_ vagy _x86_64_ kép használata javasolt.
5. Az Emulált teljesítmény alatt válassza a **Hardver – GLES 2.0** lehetőséget a [hardveres gyorsítás](https://developer.android.com/studio/run/emulator-acceleration). engedélyezéséhez 
6. Ellenőrizze, hogy az AVD konfiguráció helyes-e, majd válassza a **Befejezés** lehetőséget.

A fenti lépésekkel kapcsolatos részletekért lásd: [Managing AVDs](https://developer.android.com/studio/run/managing-avds).

1. Az Android Virtual Device Manager eszköztárában kattintson a **Futtatás** lehetőségre. Az emulátor elindul, és megjeleníti a kiválasztott operációs rendszer-verzióhoz és eszközhöz tartozó alapértelmezett vásznat.

Modul leírása:

A megvalósítás nagyjából három hónapig tartott, és minden egyes nap kódolást igényelt, hogy végül megérkezzen a végtermék. A megvalósítás a webalkalmazások oldalaihoz hasonló tevékenységek tervezéséről szólt, a grafikus felhasználói felület létrehozásáról és összekapcsolásáról a funkcionalitásokkal. Minden alkalommal, amikor megvalósítottunk egy funkciót, közvetlenül az AVD emulátoron és az Android telefonomon teszteltük, hogy valós képet kapjunk arról, hogyan fog kinézni az alkalmazás ügyfeleink mobiltelefonján. Sikerült a mobilalkalmazást kompatibilissé tennünk a különböző verziókat támogató telefonokkal is. Ezenkívül a mobilalkalmazás számos funkcióval rendelkezik:

1. Intelligens keresési szűrők:

A felhasználók kereshetnek vagy szűrhetnek a receptekben a névalap összetevői és az étrend alapján. Amikor a felhasználó egy összetevőt keres, az adott összetevőhöz kapcsolódó összes recept megjelenik a felhasználó számára, és megjelenik az étrenden alapuló keresés is. Például egyesek allergiásak bizonyos összetevőkre, és nem kívánják bevenni őket az étkezésükbe. Így a felhasználó diéta vagy egyéb követelménytényezők alapján kereshet a receptben. A keresési szűrő a keresés típusától függően a megfelelő recepteket adja vissza.

2. Kategorizált nézet:

Alkalmazásunkban az összes receptet különféle konyha, ételtípusok, diéták és fajták szerint osztályozzuk. Különböző országok exkluzív autentikus receptjeit gyűjtöttük össze, és konyhájukat a felhasználó által keresett ételtípus és étrend szerint kategorizáltuk.

3. Felügyelt gyűjtemények:

Recepteket gyűjtöttünk össze a világ híres szakácsaitól, felsoroltuk a receptjeiket, valamint különféle információkat és adatokat gyűjtöttünk össze a receptekkel kapcsolatban a népszerű webhelyekről és cikkekből.

4. Kamravezető:

Minden felhasználó saját személyes kamráját kezelheti egy kamrakezelő segítségével, amelyet az alkalmazásunkba is beépítettünk.

5. Étkezéstervező:

Az egyik legjobb megoldás az elfoglalt emberek számára, hogy jobban étkezzenek otthon, ha előre terveznek és felkészülnek. A tápláló és ízletes ételek otthoni elkészítése különösen kritikus manapság, amikor az étkezés és az élelmiszervásárlás nagyobb kihívást jelent. Sok ember számára nehéz lehet az indulás. Étkezéstervező funkciónk lehetővé teszi a felhasználó számára, hogy előre megtervezze étkezését vagy alkalmi ételeket különleges eseményekhez, és beállítsa a fennmaradó részt az étkezéstervezővel

6. Bevásárlólista:

Adtunk egy olyan funkciót is, ahol a felhasználó hozzáadhat összetevőket a bevásárlólistához. Így a felhasználó nyomon követheti az összes hiányzó összetevőt, és egyszerre megvásárolhatja őket, amikor bevásárolni látogat. Ezek a bevásárlólista-funkciók elvégzik az összes munkát Ön helyett, akár meg szeretne osztani egy virtuális listát a családjával. és barátaival, vagy [nézze meg a táplálkozási tényeket](https://www.goodhousekeeping.com/health/diet-nutrition/g5047/cheap-healthy-foods/), bármit is vásárol. Használható és létrehozható több, mint egy mobiltelefon, mivel egyes alkalmazások integrálhatók az okosórákkal.

7. Ügyességi útmutató és szószedet:

A készségismertető és a szószedet részben a főzési technikákkal kapcsolatos különféle információkkal látjuk el a felhasználót. Mint például a késhasználat stb., és tartalmaz egy „Szótárt” a közös kulináris terminológia megértéséhez. Ez a rész alapvetően azoknak a kezdőknek szól, akik nem rendelkeznek tapasztalattal és megfelelő tudással a főzés terén.

Barátságos és rugalmas GUI

Az alkalmazásom barátságos és rugalmas grafikus felhasználói felülettel rendelkezik. Picassót használtam képbetöltőként. Arról is gondoskodtam, hogy minden egyes elrendezés görgethető legyen. A „Photoshop” szoftvert használtam a gombok, elrendezések és „Szövegnézet” hátterek megtervezéséhez.

- Recept Megtekintése![](img12.png)

<center>11. ábra: A felhasználó megtekinti a receptet</center>

A felhasználónak látnia kell a recepteket az alkalmazásban. Más szóval, a felhasználó hozzáférhet a Receptfórumhoz, ahol a felhasználó összes receptje felkerül és a létrehozás dátuma szerint rendezve van. Alkalmazásunk lehetővé teszi a felhasználó számára, hogy megtekintse a receptlistát képekkel és címmel. Egyetlen recept megtekinthető képekkel, recept címével és részletes főzési útmutatóval.

![Egy tál leves](img13.png)
<center>12. ábra: A recept nevének megtekintése</center>

- Recept keresése

Minden regisztrált felhasználónak lehetséges megkeresni a receptet a cím alapján. A keresési funkció segítségével a felhasználók egy parancsikont találhatnak a célzott receptjeikhez, ha a felhasználók korábban közzétették.

- Tekintse meg az összetevőket

Az alkalmazás felhasználója meg tudja tekinteni egy bizonyos recept összetevőit. Ez az opció lehetővé teszi számára, hogy szükség szerint megjelölje ezeket az összetevőket, és végül megtalálja őket a bevásárlólistában.

![](img14.png)
<center>13. ábra: A fenti recept hozzávalói</center>

![](img15.png)

<center>14. ábra: Egy felhasználó, aki a receptet a kedvenceként adja hozzá</center>

- Recept hozzáadása a kedvencekhez

Amint a felhasználó hozzáfér a recept információihoz, képesnek kell lennie a receptet kedvencként megjelölni. Alkalmazásunk lehetővé teszi a felhasználó számára, hogy kedvencként mentse el a receptet. Amikor a felhasználó keresési műveletet hajt végre, az eredmény egy receptlista. A listán szereplő minden receptnél szerepel a kedvenc gomb. A felhasználó hozzáadhat receptet a kedvenc gombra kattintva.

- Kedvenc receptjeim megtekintése

A felhasználónak hozzá kell férnie az általa kedvencként megjelölt receptekhez.

![](img16.png)

<center>15. ábra: A felhasználó megtekintheti kedvenc receptjét</center>

Szoftver leírás:

Az alkalmazás fejlesztéséhez használt technológiai lehetőségek kiválasztása elengedhetetlen az alkalmazás sikeréhez. A technológiát elősegítőnek megfelelő módon kell biztosítaniuk a korábban megfogalmazott követelmények teljesítésére. E technológiák kiválasztásakor szem előtt kell tartani a vállalati szintű alkalmazások alapelveit. A két fő dolog az, hogy nincs a legjobb technológia, hanem a megfelelő, és hogy nem szabad feltalálni a kereket, ami azt jelenti, hogy ki kell használni a már megvalósított és a közösség számára kínált előnyöket.

ANDROID STUDIO:

- Az Android Studio az Android hivatalos IDE-je. Az Android számára készült, hogy felgyorsítsa a fejlesztést, és segítsen a legjobb minőségű alkalmazásokat létrehozni minden Android-eszközhöz. Az Android-fejlesztők számára testreszabott eszközöket kínál, beleértve a gazdag kódszerkesztő, hibakereső, tesztelő és profilkészítő eszközöket. Az Android Studiot a következő okok miatt választottam:
- Azonnali futtatás: Ha a Futtatásra vagy a Hibakeresésre kattint, az Android Studio Instant Run funkciója kódot és erőforrás-módosításokat küld a futó alkalmazásba. Intelligensen megérti a változtatásokat, és gyakran az alkalmazás újraindítása vagy az APK újraépítése nélkül teljesíti azokat, így azonnal láthatja a hatásokat.

Intelligens kódszerkesztő **:** A kódszerkesztő segítségével jobb kódot írhat, gyorsabban dolgozhat és hatékonyabban dolgozhat, mivel fejlett kódkiegészítést, átalakítást és kódelemzést kínál.

- Minden Android-eszközre optimalizálva: Az Android Studio egységes környezetet biztosít, ahol alkalmazásokat készíthet Android telefonokhoz, táblagépekhez, Android Wear-hez, Android TV-hez és Android Auto-hoz. A strukturált kódmodulok lehetővé teszik, hogy projektjét funkcionalitási egységekre ossza fel, amelyeket önállóan építhet, tesztelhet és hibakereshet.

Android virtuális eszköz (AVD)

- AVD emulátor, amely az Android készülék helyett használható. Bizonyos esetekben ugyanolyan jó vagy jobb, mint a tényleges eszközökön való fejlesztés.

**Notepad++**

- A Notepad++ egy ingyenes forráskód-szerkesztő és Jegyzettömb-csere, amely több nyelvet is támogat.