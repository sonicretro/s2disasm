@ECHO OFF

echo Assembling KiS2...
REM // The 'echo | ' at the start of this is so the pause command in build.bat doesn't do anything
echo | call build -a > NUL
IF EXIST s2built.bin (
	win32\checkhash s2built.bin 3DA827D319A60B6180E327C37E1FE5D448746C1644CCE01ADA1F2788D1E182F4 > NUL && echo KiS2 is bit-perfect || echo KiS2 is NOT bit-perfect
) ELSE (
	echo KiS2 build failed
)

echo.

REM // if someone ran this from Windows Explorer, prevent the window from disappearing immediately
pause
