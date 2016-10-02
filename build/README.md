
## Erstellen build

In diesem Beispiel für Ubuntu Xenial x86\_64:

```bash
./build.bash ubuntu xenial x86_64 all
```
Dies erstellt momentan:

- Build des open\HSR Connect
- Build der fehlenden Abhängigkeiten (in diesem fall pyyaml und pysmb)
- Ein lokales Repository

## Momentan unterstütze Builds:

- ```ubuntu```:
  - Architektur:
    - ```x86\_64```
    - ```i386```: TODO
  - Versionen:
    - ```trusty```: TODO
    - ```xenial```:
      - Fehlende Abhängigkeiten:
        - ```pyyaml```
        - ```pysmb```
    - ```yakett```: TODO
- ```fedora```: TODO
  - Architektur:
    - ```x86\_64```: TODO
    - ```i386```: TODO
  - Versionen:
    - ```23```: TODO
      - Andere Paketname der Abhängigkeiten:
        - ```pyyaml``` is named ```python3-PyYAML```: TODO
      - Fehlende Abhängigkeiten:
        - ```pysmb```: TODO
    - ```24```: TODO
