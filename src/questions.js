let questions = {
  'astianpesukone': [
    "Kuinka leveä astianpesukone on?",
    "Mikä on päivittäisen käytön ensimmäinen vaihe?",
    "Mikä ohjelma on tarkoitettu erittäin likaisten astioiden pesuun (ohjelman numero)?",
    "Mitä lämpötilaa tämä ohjelma käyttää?",
    "Mikä on virhetilanne, jos näytössä näkyy merkintä ,20?",
    "Mihin asentoon vedenpehmennin tulee asettaa, jos veden kovuus on 32°dH?",
    "Mitä Hygiene-lisätoiminnolla saavutetaan?",

  ],
  'cheerleading': [
    "Kuinka suuri kilpailualue on SM-kilpailuissa?",
    "Kuinka monta ulkoista spotteria joukkueella saa olla kilpailussa enintään?",
    "Kuinka monta pistettä rankaistaan ylimääräisestä ulkoisesta spotterista?",
    "Saako ulkoinen spotteri tukea pyramidia?",
    "Mikä on sarjamääräysten mukainen maksimikesto musiikille Suome mestaruus -kilpailuissa?",
    "Entä joukkueen maksimikoko?",
    "Kuinka monta tuomaria kaikissa kilpailuissa on oltava vähintään?",
    "Onko esityksessä pakko käyttää musiikkia?",
    "Kuinka monta mainosta esiintymisasuissa saa olla?",
  ],
  'jääkaappi': [
    "Kuinka kauas sähköliedestä jääkaappi tulee vähintään asettaa?",
    "Mitä pitää tehdä, kun jääkaappia kytkettäessä kuuluu hälytysääni?",
    "Kuinka kylmälle pakastinosan voi korkeintaan säätää?",
    "Miten pikapakastuksen saa päälle?",
    "Mikä saattaa olla syynä, jos laitteen jäähdytys ei toimi, mutta lämpötilanäyttö ja sisävalo toimivat?",
    "Mikä on huoltopalvelun puhelinnumero?",
    "Onko normaalia, että laitteesta kuuluu naksahduksia?",

  ],
  // 'kamera': [],
  'kouluratsastus': [
    "Kuinka monta suoritusta sama hevonen voi korkeintaan tehdä yhtenä kilpailupäivänä?",
    "Millainen päähine kilpailuasuun kuuluu?",
    "Onko turvaliivin käyttö kilpailussa pakollista?",
    "Kuinka painava ratsastaja saa korkeintaan olla?",
    "Kuinka monta pistettä rankaistaan ensimmäisestä virheestä?",
    "Minkä nimisiä ovat ohjelmissa ratsastettavat tiet?",

  ],
  'kuulokkeet': [
    "Mitä kaikkea pakkaukseen sisältyy?",
    "Kuinka suuri on kuulokkeiden toimintasäde?",
    "Kuinka kauan kuulokkeiden lataaminen kestää?",
    "Mikä on kuulokkeiden salasana, mikäli sitä tarvitaan pariliitosta muodostaessa?",
    "Miten voi siirtyä eteenpäin musiikissa?",
    "Entä mykistää mikrofonin puhelun aikana?",
    "Kuulokkeiden ollessa latauksessa, mistä voi päätellä, että akku on täynnä?",
    "Mikä on vialla, jos kuulokkeista kuuluu rätinää?"
  ],
  'lattialiesi': [
    "Onko uunissa kiertoilma-toimintoa?",
    "Missä lämpötilassa porsaankyljykset suositellaan paistamaan?",
    "Kuinka monta kannatintasoa uunissa on?",
    "Kuinka paljon tyhjää tilaa lieden päällä pitää vähintään olla?",
    "Voiko uunin sijoittaa 20 cm päähän seinästä?",

  ],
  'liesituuletin': [
    "Mille teholle liesituuletin menee käynnistettäessä (ohjauspaneeli vaihtoehto 1)?",
    "Miten äänimerkin saa päälle?",
    "Entä tuulettimen jälkikäynnin?",
    "Mitä puhdistusainetta tulee käyttää laitteen alumiini- ja muoviosien puhdistukseen?",
    "Kuinka usein rasvasuodatin pitää puhdistaa?",
    "Laitteen valo ei pala. Millaisen hehkulampun siihen voi vaihtaa (tuotekoodi)?",
  ],
  'miekkailu': [
    "Mikä kolmesta miekasta saa olla painavin?",
    "Kuinka paljon se saa painaa?",
    "Mikä on kalpa-miekkailun osuma-alue?",
    "Entä säilä-miekkailun?",
    "Mitä muita varusteita miekkailussa käytetään miekan lisäksi?",
    "Kuinka monta pistettä vaaditaan ottelun voittoon?",
    "Kuinka pitkä on otteluaika näiden pisteiden keräämiseen?",
    "Minkä komennon jälkeen miekkailuottelu alkaa?",
  ],
  'mikroaaltouuni': [
    "Miksi metalliastia on sopimaton mikroon?",
    "Mitä on tapahtunut, jos mikron näytössä palaa kolme nollaa?",
    "Mikä on suurin valittava teho?",
    "Mitä tällä teholla tulisi kuumentaa?",
    "Mikä on mikron leveys?",

  ],
  'pöytätennis': [
    "Mitkä ovat pöydän mitat pöytätenniksessä?",
    "Kuinka korkealle syötön kuuluu nousta ennen lyöntiä?",
    "Täytän maaliskuussa 15 vuotta. Saanko osallistua pelikaudella (1.7-30.6) M14-luokkaan?",
    "Kuinka monella pisteellä voittaa erän?",
    "Mitä värirajoituksia peliasussa on?",
    "Muutin Suomeen maaliskuussa 2018. Voinko osallistua miesten TOP-12-turnaukseen joulukuussa 2018?",

  ],
  'puhelin': [
    "Mikä on Samsung DeX?",

  ],
  'pyykinpesukone': [
    "Mikä on pyykinpesukoneen maksimitäyttömäärä?",
    "Mitä tarkoittaa virhemerkintä E40?",
    "Saako pesukoneen kytkeä jatkojohtoon, jos se on hyvin vedeltä suojattu?",
    "Millä ohjelmalla pesen polyesteria sisältävät vaatteet?",
    "Voiko pesuohjelman asettaa käynnistymään vuorokauden päästä?",
  ],
  'stereot': [

  ],
  'suunnistus': [],
  // 'tabletti': [],
  'televisio': [],
  'tennis': [],
};

export default questions;

let answers = {
  'astianpesukone': [
    "596 mm",
    "Vesihanan avaaminen",
    "3",
    "70 astetta",
    "Koneeseen jää vettä",
    "7",
    "Parempi hygieniataso",

  ],
  'cheerleading': [
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
  'jääkaappi': [
    "3 cm",
    "Painaa lämpötilavalitsinta 1",
    "-24 astetta",
    "Painamalla lämpötilavalitsinta 1 niin monta kertaa kunnes näyttö super 2 syttyy",
    "Demotoiminto on kytketty toimintaan",
    "0207 510 700",
    "On",
  ],
  // 'kamera': [],
  'kouluratsastus': [
    "2",
    "Knalli tai silinteri",
    "Ei",
    "Painorajoitusta ei ole",
    "2",
    "Voltti, serpentiini ja volttikahdeksikko",

  ],
  'kuulokkeet': [
    "Kuulokkeet, USB-latauskaapeli ja pikaopas",
    "10 metriä",
    "2 tuntia",
    "0000",
    "Painamalla + näppäintä pitkään",
    "Painamalla + ja - näppäimiä",
    "Punainen valo on sammunut",
    "Laite ei ole toiminta-alueella",

  ],
  'lattialiesi': [
    "Ei",
    "190-210 astetta",
    "4",
    "650 mm",
    "Ei",

  ],
  'liesituuletin': [
    "2",
    "Painamalla käynnistys- ja + painikkeita samanaikaisesti 3 sekunnin ajan",
    "Painamalla - kunnes merkki ilmestyy näyttöön",
    "Lasinpesuainetta",
    "2 kuukauden välein",
    "HSGSB/C/UB-30-230-E14",

  ],
  'miekkailu': [
    "Kalpa",
    "770 grammaa",
    "Koko keho",
    "Koko vartalo vyötäröstä ylöspäin",
    "Maskia, miekkailutakkia ja -housuja, miekkailuhanskaa ja vartalojohtoa",
    "5",
    "3",
    "Allez! (Alkakaa!)",
  ],
  'mikroaaltouuni': [
    "Mikroaallot eivät läpäise metallia (ja ruoka jää kylmäksi)",
    "Sähkökatko",
    "800 W",
    "Nesteitä",
    "382 mm",

  ],
  'pöytätennis': [
    "Pituus 274 cm ja leveys 152,5 cm",
    "16 cm",
    "Kyllä",
    "11",
    "Paidan, shortsien ja hameen väri täytyy olla selvästi eri kuin käytetyn pallon väri",
    "Et",

  ],
  'puhelin': [
    "Palvelu jonka avulla puhelinta voi käyttää tietokoneen tapaan yhdistämällä puhelimen ulkoiseen näyttöön",

  ],
  'pyykinpesukone': [
    "7 kg",
    "Luukku on auki tai se on suljettu virheellisesti",
    "Ei",
    "Hienopesu",
    "Ei",

  ],
  'stereot': [],
  'suunnistus': [],
  // 'tabletti': [],
  'televisio': [],
  'tennis': [],
};
