#  BSC Úkol

## Zadání
### Připravte jednoduchou nativní aplikaci pro iPhone tak, aby se dala po naklonování repository zbuildit, nainstalovat a spustit.

Předpřipravený server BSC s REST API, které bude aplikace používat:
Root URL: http://private-9aad-note10.apiary-mock.com/ (případně použijte REST api podle uvážení: https://www.firebase.com/ , http://jsonplaceholder.typicode.com/, nebo vlastní řešení)
Metody:
GET /notes
GET /notes/{id}
POST /notes
PUT /notes/{id}
DELETE /notes/{id}

### Funkční požadavky:
Po instalaci a spuštění se objeví stránka se seznamem poznámek.
Je možné zobrazit detail, editovat, smazat a vytvořit novou poznámku. (Apiary Mock bude vracet stále stejná data, předmětem úkolu je volat správné metody)
V aplikaci bude možné měnit EN/CZ jazyk.

### Nefunkční požadavky:
GUI vytvořte dle vlastního návrhu, ale ctěte standardy a zvyklosti platformy.
Aplikace by měla být sestavena především ze standardních nativních komponent.
Preferovaný jazyk je Swift.
Projekt by měl obsahovat alespoň jeden základní test.

Kód vyvíjejte do github/bitbucket veřejného repository, v souboru README.md popište instrukce pro instalaci a spuštění aplikace a testu, a pošlete URL e-mailem.


## Instalace
1. Přes git clone si naklonujte repozitář
2. Přejděte pomocí terminálu do kořenové složky repozitáře, která obsahuje mj. projektový soubor a Podfile
3. V terminálu spusťte příkaz pod install
4. Otevřete v Xcodu projekt BSC.xcworkspace
5. CMD+R

## Testy
1. Následujte pokyny z kapitoly Instalace
2. V Xcodu s otevřeným BSC.xcworkspace přejděte do skupiny BSCTests
3. V souboru NotesModelTests.swift najdete požadovanou metodu s testem
