@ECHO OFF

REM // build the ROM
call build %1

REM  // run fc against a Sonic 2 Rev 01 (W) ROM
echo -------------------------------------------------------------
IF EXIST s2built.bin ( fc /b s2built.bin s2rev01.bin
) ELSE echo s2built.bin does not exist, probably due to an assembly error

REM // clean up after us
IF EXIST s2.p del s2.p
IF EXIST s2.h del s2.h
IF EXIST s2built.bin del s2built.bin
IF EXIST s2built.prev.bin del s2built.prev.bin
IF EXIST s2.log ( IF "%1"=="-pe" del s2.log )

REM // if someone ran this from Windows Explorer, prevent the window from disappearing immediately
pause
