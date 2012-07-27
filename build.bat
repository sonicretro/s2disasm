@ECHO OFF

REM // make sure we can write to the file s2built.bin
REM // also make a backup to s2built.prev.bin
IF NOT EXIST s2built.bin goto LABLNOCOPY
IF EXIST s2built.prev.bin del s2built.prev.bin
IF EXIST s2built.prev.bin goto LABLNOCOPY
move /Y s2built.bin s2built.prev.bin
IF EXIST s2built.bin goto LABLERROR3
REM IF EXIST s2built.prev.bin copy /Y s2built.prev.bin s2built.bin
:LABLNOCOPY

REM // delete some intermediate assembler output just in case
IF EXIST s2.p del s2.p
IF EXIST s2.p goto LABLERROR2
IF EXIST s2.h del s2.h
IF EXIST s2.h goto LABLERROR1

REM // clear the output window
cls


REM // run the assembler
REM // -xx shows the most detailed error output
REM // -c outputs a shared file (s2.h)
REM // -A gives us a small speedup
set AS_MSGPATH=win32/msg
set USEANSI=n

REM // allow the user to choose to print error messages out by supplying the -pe parameter
IF "%1"=="-pe" ( "win32/asw" -xx -c -A s2.asm ) ELSE "win32/asw" -xx -c -E -A s2.asm

REM // if there were errors, a log file is produced
IF EXIST s2.log goto LABLERROR4

REM // combine the assembler output into a rom
IF EXIST s2.p "win32/s2p2bin" s2.p s2built.bin s2.h

REM // fix some pointers and things that are impossible to fix from the assembler without un-splitting their data
IF EXIST s2built.bin "win32/fixpointer" s2.h s2built.bin

REM REM // fix the rom header (checksum)
IF EXIST s2built.bin "win32/fixheader" s2built.bin


REM // done -- pause if we seem to have failed, then exit
IF NOT EXIST s2.p goto LABLPAUSE
IF EXIST s2built.bin exit /b
:LABLPAUSE

pause


exit /b

:LABLERROR1
echo Failed to build because write access to s2.h was denied.
pause


exit /b

:LABLERROR2
echo Failed to build because write access to s2.p was denied.
pause


exit /b

:LABLERROR3
echo Failed to build because write access to s2built.bin was denied.
pause

exit /b

:LABLERROR4
REM // display a noticeable message
echo.
echo **********************************************************************
echo *                                                                    *
echo *   There were build errors/warnings. See s2.log for more details.   *
echo *                                                                    *
echo **********************************************************************
echo.
pause


