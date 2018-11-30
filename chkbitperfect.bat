@ECHO OFF

echo Assembling...
echo | call build -a > NUL
IF EXIST s2built.bin (
	win32\checkhash s2built.bin 050F9442320386DD3CD5824430135401A56117CBFB468D031416F03517724672 > NUL && echo ROM is bit-perfect || echo ROM is NOT bit-perfect
) ELSE (
	echo Build failed
)

echo.

REM // if someone ran this from Windows Explorer, prevent the window from disappearing immediately
pause
