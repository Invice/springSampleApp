@ECHO OFF

SET COUNTER=0
SET MAX=5
SET BINDIR=%~dp0
cd %BINDIR%

REM START /B %BINDIR%create-new-load.bat

START /B %BINDIR%petVisitUser.bat 1 3 5
START /B %BINDIR%petVisitUser.bat 2 3 2

START /B %BINDIR%multiplePetCreateUsers.bat 1 4