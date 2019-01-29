@ECHO OFF

echo Assembling REV00...
REM // The 'echo | ' at the start of this is so the pause command in build.bat doesn't do anything
echo | call build -a -r0 > NUL
IF EXIST s2built.bin (
	win32\checkhash s2built.bin 07329F4561044A504923EB0742894485C61FC42EBB0891EEBFF247CA2E086D61 > NUL && echo REV00 is bit-perfect || echo REV00 is NOT bit-perfect
) ELSE (
	echo REV00 build failed
)

echo.

echo Assembling REV01...
echo | call build -a -r1 > NUL
IF EXIST s2built.bin (
	win32\checkhash s2built.bin 193BC4064CE0DAF27EA9E908ED246D87EC576CC294833BADEBB590B6AD8E8F6B > NUL && echo REV01 is bit-perfect || echo REV01 is NOT bit-perfect
) ELSE (
	echo REV01 build failed
)

echo.

echo Assembling REV02...
echo | call build -a -r2 > NUL
IF EXIST s2built.bin (
	win32\checkhash s2built.bin 3EF0C3CDDEC79CB66AF7E5053963C4506E5551E2A47338C53236388F6E081A19 > NUL && echo REV02 is bit-perfect || echo REV02 is NOT bit-perfect
) ELSE (
	echo REV02 build failed
)

echo.

REM // if someone ran this from Windows Explorer, prevent the window from disappearing immediately
pause
