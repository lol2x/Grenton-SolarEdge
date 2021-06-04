# Integracja SolarEdge -> Grenton

Integracja falownika SolarEdge przy użyciu Grenton Gate_HTTP

## Wymagania

* Firmware na CLU > v5.07
* Klucz API i numer instalacji - do zdobycia po zalogowaniu do instalacji na https://monitoring.solaredge.com/ w zakładce Administrator -> Dostęp do instalacji -> Dostęp do interfejsu API


#### Wymagane obiekty:
* SunriseSunsetCalculator - do obliczenia długości dnia celem określenia możliwej ilości zapytań do API SolarEdge (limit dzienny to 300 zapytań)
  * Nazwa u mnie: *czujnik_dnia_nocy*
* Timer - uruchamiający co obliczony czas zapytanie do API
  * Nazwa u mnie: *timer_sprawdzanie_fotowoltaiki*
* HttpRequest - odpytujący API
  * Nazwa u mnie: *fotowoltaika_currentPowerFlow*

#### Wymagane cechy użytkownika na Gate_HTTP:
```
SolarEdge_LOAD number

SolarEdge_GRID number

SolarEdge_PV number

SolarEdge_isExportingToGrid boolean
```

#### Wymagane skrypty:
*fotowoltaika_response*

*fotowoltaika_intervalSetUp*

## Konfiguracja
**SunriseSunsetCalculator**

```
# Cechy wbudowane
Longitute długość geograficzna instalacji
Latitude szerokość geograficzna instalacji
State 1

# Zdarzenia
OnSunrise GateHTTP->fotowoltaika_intervalSetUp()
OnSunset GateHTTP->timer_sprawdzanie_fotowoltaiki->Stop()

```

**Timer**

```
Time 210000
Mode 1
OnTimer GateHTTP->fotowoltaika_currentPowerFlow->SendRequest()
```

**HttpRequest**

```
# Cechy wbudowane
Host https://monitoringapi.solaredge.com
Path /site/NUMERINSTALACJI/currentPowerFlow.json
QueryStringParams api_key=KLUCZAPI
Method GET
RequestType JSON
ResponseType JSON

# Zdarzenia
OnResponse GateHTTP->fotowoltaika_response()
```

**GateHTTP**

```
# Zdarzenia
OnInit Http_204->fotowoltaika_intervalSetUp()
```

## Działanie

W moim przypadku Grenton uruchamia pompę ciepła (Vaillant aroSTOR VWL BM 270/5) w trybie PV ECO gdy oddaję do sieci od 0.4kwh do 1kwh. Oraz uruchamia tryb PV MAX jeżeli oddaję do sieci więcej niż 1.7 kwh (przy wyłączonej pompie) lub więcej niż 1kwh (przy włączonej pompie)