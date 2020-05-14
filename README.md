# HP-Server Health-Check Script

Für ältere Server (zb. HP Server mit iLO3 wie in meinem Fall) haben keine Möglichkeit bei Hardware Warnungen oder Ausfällen eine Email an den Server Administrator zu senden. Dieses Script ermöglicht genau dies.

## Installation

#### Dependencies installieren (old Kernel Versions):

```bash
nano /etc/apt/sources.list.d/hp.list
```
copy & pasta in die gerade geöffnete Datei
```bash
deb http://downloads.linux.hpe.com/SDR/repo/mcp trusty/current non-free
```
anschließend die Datei abspeichern und dieses Command ausführen:
```bash
curl http://downloads.linux.hpe.com/SDR/hpePublicKey2048_key1.pub | apt-key add -
```
zum Schluss noch die Pakete installieren:
```bash
apt update && apt install hp-health hponcfg hp-snmp-agents ssmtp mailutils
```

#### Dependencies installieren (Linux Kernel 5.0+):
Website öffnen und aktuelle Version downloaden
```bash
https://hwraid.le-vert.net/debian/pool-buster/hpacucli/
```
anschließend folgenden Command ausführen
```bash
sudo dpkg -i //package-name//
```
zum Schluss noch die Pakete installieren:
```bash
apt update && apt install mailutils
```

#### Script einrichten:
Script herunterladen:
```bash
git clone https://xedon@bitbucket.org/xedon/hp-health-script.git
```
dem Script die notwenigen Rechte vergeben:
```bash
chmod -x healthstatus.sh
```
ssmtp config erstellen:
```bash
(siehe ssmtp-example.conf)
```
cronjob konfigurieren:
```bash
(siehe crontab-example.conf)
```

## Schlusswort
Wenn Ihr die Konfiguration erfolgreich abschließen konntet, habt hier nun ein vollwertiges Überwachungssystem für eueren HP Server. Ihr solltet jedoch trotzdem ein externes Monitoring zusätzlich verwenden um über andere Fehler ebenfalls benachrichtigt zu werden (zb Netzwerk Ausfall, Stromausfall etc)

## License
[MIT](https://choosealicense.com/licenses/mit/)