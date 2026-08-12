@ECHO OFF

REM // This file has been gutted and replaced with the Node.js build script.
REM // It has been kept around for ease-of-use for Windows users.
CALL "build_tools\node.bat" build.js || pause REM // Pause on failure so that the user can read the error message.
