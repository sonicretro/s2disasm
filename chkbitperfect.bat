@ECHO OFF

echo Assembling...
echo | call build -a > NUL
IF EXIST s2built.bin (
	win32\checkhash s2built.bin 429F6A1FACE094147FA703419A7EA2CEA72272C4E4D2CF10A0926DEEC565110E > NUL && echo ROM is bit-perfect || echo ROM is NOT bit-perfect
) ELSE (
	echo Build failed
)

echo.

REM // if someone ran this from Windows Explorer, prevent the window from disappearing immediately
pause
