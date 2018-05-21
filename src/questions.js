let questions = {
  'Astianpesukone': [
    "Kuinka leveä astianpesukone on?",
    "Mikä on koneen käynnistyksen ensimmäinen vaihe päivittäisessä käytössä?",
    "Mikä ohjelma on tarkoitettu erittäin likaisten astioiden pesuun (ohjelman numero)?",
    "Mitä lämpötilaa tämä ohjelma käyttää?",
    "Mikä on virhetilanne, jos näytössä näkyy merkintä ,20?",
    "Mihin asentoon vedenpehmennin tulee asettaa, jos veden kovuus on 32°dH?",
    "Mitä Hygiene-lisätoiminnolla saavutetaan?",

  ],
  'Cheerleadingin kilpailusäännöt': [
    "Kuinka suuri kilpailualue on cheerleadingin SM-kilpailuissa?",
    "Kuinka monta ulkoista spotteria joukkueella saa olla kilpailussa enintään?",
    "Kuinka monta pistettä rankaistaan ylimääräisestä ulkoisesta spotterista?",
    "Saako ulkoinen spotteri tukea pyramidia?",
    "Mikä on sarjamääräysten mukainen maksimikesto musiikille Suomen mestaruus -kilpailuissa?",
    "Entä joukkueen maksimikoko?",
    "Kuinka monta tuomaria kaikissa kilpailuissa on oltava vähintään?",
    "Onko esityksessä pakko käyttää musiikkia?",
    "Kuinka monta mainosta esiintymisasuissa saa olla?",
  ],
  'Jääkaappi': [
    "Kuinka kauas sähköliedestä jääkaappi tulee vähintään asettaa?",
    "Mitä pitää tehdä, kun jääkaappia kytkettäessä kuuluu hälytysääni?",
    "Mikä on kylmin lämpötila, jolle pakastinosan voi säätää?",
    "Miten pikapakastuksen saa päälle?",
    "Mikä saattaa olla syynä, jos laitteen jäähdytys ei toimi, mutta lämpötilanäyttö ja sisävalo toimivat?",
    "Mikä on huoltopalvelun puhelinnumero?",
    "Onko normaalia, että laitteesta kuuluu naksahduksia?",

  ],
  'Kouluratsastuksen kilpailusäännöt': [
    "Kuinka monta suoritusta sama hevonen voi korkeintaan tehdä yhtenä kilpailupäivänä kouluratsastuksessa?",
    "Millainen päähine kilpailuasuun kuuluu?",
    "Onko turvaliivin käyttö kilpailussa pakollista?",
    "Kuinka painava ratsastaja saa korkeintaan olla?",
    "Kuinka monta pistettä tuomarit voivat korkeintaan antaa ohjelman liikkeistä?",
    "Minkä nimisiä ovat ohjelmissa ratsastettavat tiet?",

  ],
  'Langattomat Bluetooth-kuulokkeet': [
    "Mitä kaikkea pakkaukseen sisältyy?",
    "Kuinka suuri on kuulokkeiden toimintasäde?",
    "Kuinka kauan kuulokkeiden lataaminen yleensä kestää?",
    "Mikä on kuulokkeiden salasana, mikäli sitä tarvitaan pariliitosta muodostaessa?",
    "Miten voi siirtyä eteenpäin musiikissa?",
    "Entä mykistää mikrofonin puhelun aikana?",
    "Kuulokkeiden ollessa latauksessa, mistä voi päätellä, että akku on täynnä?",
    "Mikä on vialla, jos kuulokkeista kuuluu rätinää?"
  ],
  'Liesi': [
    "Kuuluuko uunin toimintoihin kiertoilma-toiminto?",
    "Voiko uunin asentaa 200 mm päähän seinästä?",
    "Kuinka monta kannatintasoa uunissa on?",
    "Kuinka paljon tyhjää tilaa lieden päällä pitää vähintään olla?",
    "Missä lämpötilassa porsaankyljykset suositellaan paistamaan?",

  ],
  'Liesituuletin': [
    "Mille teholle liesituuletin menee käynnistettäessä (ohjauspaneeli vaihtoehto 1)?",
    "Miten kyseisellä ohjauspaneelilla saa äänimerkin päälle?",
    "Entä tuulettimen jälkikäynnin?",
    "Mitä puhdistusainetta tulee käyttää laitteen alumiini- ja muoviosien puhdistukseen?",
    "Kuinka usein rasvasuodatin pitää puhdistaa?",
    "Laitteen valo ei pala. Millaisen hehkulampun siihen voi vaihtaa (tuotekoodi)?",
  ],
  'Miekkailu': [
    "Mikä kolmesta miekkatyypistä saa olla painavin?",
    "Kuinka paljon se saa painaa?",
    "Mikä on kalpa-miekkailun osuma-alue?",
    "Entä säilä-miekkailun?",
    "Mitä muita varusteita miekkailussa käytetään miekan lisäksi?",
    "Kuinka monta pistettä vaaditaan ottelun voittoon?",
    "Kuinka pitkä on otteluaika näiden pisteiden keräämiseen?",
    "Minkä on taistelukomento, jonka jälkeen miekkailuottelu alkaa?",
  ],
  'Mikroaaltouuni': [
    "Miksi metalliastia on sopimaton mikroon?",
    "Mitä on tapahtunut, jos mikron näytössä palaa kolme nollaa?",
    "Mikä on suurin valittava teho?",
    "Mitä tällä teholla tulisi kuumentaa?",
    "Mikä on mikron leveys?",

  ],
  'Pöytätenniksen säännöt': [
    "Mitkä ovat pöydän mitat pöytätenniksessä?",
    "Kuinka korkealle syötön kuuluu nousta ennen lyöntiä?",
    "Täytän maaliskuussa 15 vuotta. Saanko osallistua pelikaudella (1.7-30.6) M14-luokkaan?",
    "Kuinka monella pisteellä voittaa erän?",
    "Mitä värirajoituksia peliasussa on?",
    "Muutin Suomeen maaliskuussa 2018. Voinko osallistua miesten TOP-12-turnaukseen joulukuussa 2018?",

  ],
  'Pyykinpesukone': [
    "Mikä on pyykinpesukoneen maksimitäyttömäärä?",
    "Mitä tarkoittaa virhemerkintä E40?",
    "Saako pesukoneen kytkeä jatkojohtoon, jos se on hyvin vedeltä suojattu?",
    "Millä ohjelmalla pesen polyesteria sisältävät vaatteet?",
    "Voiko pesuohjelman asettaa käynnistymään vuorokauden päästä?",
  ],
  'Samsung Galaxy S9': [
    "Mikä on Samsung DeX?",

  ],
  'Stereot': [

  ],
  'Suunnistuksen lajisäännöt': [
    "Kuinka montaa seuraa kilpailija voi edustaa yleisessä suunnistuskilpailussa?",
    "Miten kilpailun keskeyttänyt kilpailija poistuu suunnistusalueelta?",
    "Mitä välineitä voi käyttää suunnistustehtävän selvittämiseen?",
    "Saako kilpailija ylittää rautatien suorituksen aikana?",
    "",
  ],
  'Televisio': [
    "Mikä on minimi verkkoyhteyden nopeus, jotta televisio voi muodostaa internet-yhteyden?",
    "Minkä valikkopolun takaa voi asettaa Smart Hubin käynnistymään automaattisesti?",
    "",
  ],
  'Tenniksen kilpailumääräykset': [
    "Kuinka montaa palloa tennisotteluissa voi korkeintaan käyttää?",
    "Minkä tasoiset pelaajat pelaavat luokassa C?",
    "Kuinka pitkään taukoon pelaaja on oikeutettu kahden saman luokan kaksinpelin välissä?",
    "Mitä sääntöjä on pelaajan vaatetuksessa?",
  ],
};

export default questions;

let answers = {
  'Astianpesukone': [
    "596 mm",
    "Vesihanan avaaminen",
    "3",
    "70 astetta",
    "Koneeseen jää vettä",
    "7",
    "Parempi hygieniataso",

  ],
  'Cheerleadingin kilpailusäännöt': [
    "14x16 metriä",
    "6",
    "10",
    "Ei",
    "2:30",
    "24",
    "3",
    "On",
    "2",
  ],
  'Jääkaappi': [
    "3 cm",
    "Painaa lämpötilavalitsinta 1",
    "-24 astetta",
    "Painamalla lämpötilavalitsinta 1 niin monta kertaa kunnes näyttö super 2 syttyy",
    "Demotoiminto on kytketty toimintaan",
    "0207 510 700",
    "On",
  ],
  'Kouluratsastuksen kilpailusäännöt': [
    "2",
    "Knalli tai silinteri",
    "Ei",
    "Painorajoitusta ei ole",
    "2",
    "Voltti, serpentiini ja volttikahdeksikko",

  ],
  'Langattomat Bluetooth-kuulokkeet': [
    "Kuulokkeet, USB-latauskaapeli ja pikaopas",
    "10 metriä",
    "2 tuntia",
    "0000",
    "Painamalla + näppäintä pitkään",
    "Painamalla + ja - näppäimiä",
    "Punainen valo on sammunut",
    "Laite ei ole toiminta-alueella",

  ],
  'Liesi': [
    "Ei",
    "190-210 astetta",
    "4",
    "650 mm",
    "Ei",

  ],
  'Liesituuletin': [
    "2",
    "Painamalla käynnistys- ja + painikkeita samanaikaisesti 3 sekunnin ajan",
    "Painamalla - kunnes merkki ilmestyy näyttöön",
    "Lasinpesuainetta",
    "2 kuukauden välein",
    "HSGSB/C/UB-30-230-E14",

  ],
  'Miekkailu': [
    "Kalpa",
    "770 grammaa",
    "Koko keho",
    "Koko vartalo vyötäröstä ylöspäin",
    "Maskia, miekkailutakkia ja -housuja, miekkailuhanskaa ja vartalojohtoa",
    "5",
    "3",
    "Allez! (Alkakaa!)",
  ],
  'Mikroaaltouuni': [
    "Mikroaallot eivät läpäise metallia (ja ruoka jää kylmäksi)",
    "Sähkökatko",
    "800 W",
    "Nesteitä",
    "382 mm",

  ],
  'Pöytätenniksen säännöt': [
    "Pituus 274 cm ja leveys 152,5 cm",
    "16 cm",
    "Kyllä",
    "11",
    "Paidan, shortsien ja hameen väri täytyy olla selvästi eri kuin käytetyn pallon väri",
    "Et",

  ],
  'Pyykinpesukone': [
    "7 kg",
    "Luukku on auki tai se on suljettu virheellisesti",
    "Ei",
    "Hienopesu",
    "Ei",

  ],
  'Samsung Galaxy S9': [
    "Palvelu jonka avulla puhelinta voi käyttää tietokoneen tapaan yhdistämällä puhelimen ulkoiseen näyttöön",

  ],
  'Stereot': [],
  'Suunnistuksen lajisäännöt': [
    "Kilpailukarttaa, rastinmääritteitä ja kompassia",
    "Yhtä",
    "Maalin kautta (vaikuttamatta kilpailun kulkuun)",
    "Kyllä",
    "",
  ],
  'Televisio': [
    "10 Mbps",
    "Asetukset -> Järjestelmä -> Asiantuntijan asetukset > Suorita Smart Hub automaattisesti",

  ],
  'Tenniksen kilpailumääräykset': [
    "6",
    "13-24",
    "60 min",
    "Pelipaita tennikseen tarkoitettu tekninen paita tai kauluspaita"
  ],
};
