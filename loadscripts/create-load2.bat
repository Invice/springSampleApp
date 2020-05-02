@ECHO OFF

SET COUNTER=0
SET MAX=5
SET BINDIR=%~dp0
cd %BINDIR%

REM START /B %BINDIR%create-new-load.bat

START /B %BINDIR%petVisitUser.bat 1 2 10
START /B %BINDIR%petVisitUser.bat 2 3 8

START /B %BINDIR%multiplePetCreateUsers.bat 0 6

START /B %BINDIR%multipleEditUsers.bat 6 3