# open\HSR Connect

WARNUNG: NOCH IST DIESE SOFTWARE IN ENTWICKLUNG - ALSO NICHT FÜR DEN PRODUKTIVEN EINSATZ GEEIGNET!

Besser als der HSR Mapper ;)

##How to install
###Ubuntu/Debian
1. Install dependencies
```
$sudo apt-get install git python3-setuptools gcc python3-dev libffi-dev libssl-dev python3-pip -y
```
2. Clone repo
```
$git clone https://github.com/openhsr/connect.git
$cd connect
```
3. Build & install
```
$sudo  python3 ./setup.py install
```
4. Set up sync settings
```
$openhsr-connect edit
```
Enter HSR information, modify config file for your classes (See example [here](https://github.com/seroam/connect/blob/master/docs/config.example.yaml))

###Windows
1. Download Python 3.x (Latest is 3.5.2 as of creation of this guide. Download website: [Link](https://www.python.org/downloads/release/python-352/), Installer: [click me hard](https://www.python.org/ftp/python/3.5.2/python-3.5.2-amd64.exe))
Install and make sure to install the py launcher as well (this setting should automatically be set in the advanced installation options).

2. Install git
Download link [here](https://git-scm.com/download/win)

3. Clone repo
Open admin command prompt
```
$git clone https://github.com/openhsr/connect.git
cd connect
```

4. Build & install
```
$py -3 setup.py install
```

5. Add Python Scripts folder to $PATH
For x64 Python this path is ```C:\Program Files\Python35\Scripts``` by default. If you're not sure how to add this to Path, check this [link](http://www.computerhope.com/issues/ch000549.htm)

6. Set up sync settings
```
$openhsr-connect edit
```
Enter HSR information, modify config file for your classes (See example [here](https://github.com/seroam/connect/blob/master/docs/config.example.yaml))

 
## Lizenz

```open\HSR Connect``` steht unter der [GNU Public License version 3 (GPLv3)](https://www.gnu.org/licenses/gpl-3.0.html). Eine Kopie der Lizenz ist unter LICENSE.txt abgelegt.
