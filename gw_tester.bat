@echo off
REM Autor: Ilija Injac, The8BitBox - Ilija Injac
REM Lizenz: MIT
REM Ausgabe der Seriennummer und weiterer Daten

REM Dieses Skript benötigt 2 Diskettenlaufwerke, die am GW angeschlossen sind.
REM Ein 5 1/4" Laufwerk und ein 3 1/2" Laufwerk (ansonsten gerne umschreiben)

START /B /WAIT cmd /c "gw info"  > output.txt 2>&1


setlocal enableDelayedExpansion

for /f "usebackq tokens=1,2 delims=:" %%a in ("output.txt") do (
    
    REM Auslesen der Info Daten des GW
    set "key=%%a"
    set "value=%%b"
    SET "cleankey=!key: =!"
    SET "cleanval=!value: =!"
    
    REM Haben wir die Seriennummer?
    if /i "!cleankey!"=="Serial" (
        
        REM Verzeichnis mit dem Namen der Seriennummer anlegen
        mkdir !cleanval!
        cd !cleanval!
        
        REM Tests Amiga ausführen
        echo LESE AMIGA DISK - TEST 1 >> testprotokoll.txt
        START /B /WAIT cmd /c "gw read --format=amiga.amigados test.adf --drive=1"  > amigaread.txt 2>&1
        echo TEST 1 - ENDE >> testprotokoll.txt
        echo SCHREIBE AMIGA DISK - TEST 2 >> testprotokoll.txt
        START /B /WAIT cmd /c "gw read --format=amiga.amigados test.adf --drive=1"  > amigawrite.txt 2>&1
        echo TEST 2 - ENDE >> testprotokoll.txt

        REM Tests C64 Disks ausführen
        echo LESE C64 DISK - TEST 1 >> testprotokoll.txt
        START /B /WAIT cmd /c "gw read --format=commodore.1541 --tracks=c=0-39:h=0:step=2 test.d64 "  > C64read.txt 2>&1
        echo TEST 1 - ENDE >> testprotokoll.txt
        echo SCHREIBE C64 DISK - TEST 2 >> testprotokoll.txt
        START /B /WAIT cmd /c "gw read --format=commodore.1541 --tracks=c=0-39:h=0:step=2 test.d64"  > C64Write.txt 2>&1
        echo TEST 2 - ENDE >> testprotokoll.txt

    )
    

)

