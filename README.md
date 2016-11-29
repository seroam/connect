# open\HSR Connect

WARNUNG: NOCH IST DIESE SOFTWARE IN ENTWICKLUNG - ALSO NICHT FÜR DEN PRODUKTIVEN EINSATZ GEEIGNET!

Besser als der HSR Mapper ;)

##How to install
###Ubuntu/Debian
1. Install dependencies
```$sudo apt-get install git python3-setuptools gcc python3-dev libffi-dev libssl-dev python3-pip -y```

2. Clone repo
```
$git clone https://github.com/openhsr/connect.git
$cd connect
```

3. Build & install
```
$sudo  python3 ./setup.py install

4. Set up sync settings
```
$openhsr-connect edit
```
Enter HSR information, modify config file for your classes (See example [here](https://github.com/seroam/connect/blob/master/docs/config.example.yaml)

## Lizenz

```open\HSR Connect``` steht unter der [GNU Public License version 3 (GPLv3)](https://www.gnu.org/licenses/gpl-3.0.html). Eine Kopie der Lizenz ist unter LICENSE.txt abgelegt.
