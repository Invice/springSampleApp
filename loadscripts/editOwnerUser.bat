@ECHO OFF
:: ####################################
:: # Inspired by EaaS (see README.md) #
:: ####################################

:: Init
SET URL=http://localhost:8075
SET BINDIR=%~dp0
SET LOGDIR=%BINDIR%\log
SET FILE_NAME="vernon-url%1.txt"
cd %BINDIR%

:: Create log directory if it does not already exist.
IF EXIST %LOGDIR%\NUL GOTO skipInit
MKDIR %LOGDIR%
:skipInit

:: Create load
CALL :get_url "%URL%/"
CALL :get_url "%URL%/owners/new"
CALL :post_and_save_url "%URL%/owners/new" "firstName=Vernon&lastName=Dudley%1&address=4+Privet+Drive&city=Little+Whinging+Surrey&telephone=123456789"

SET /p VERNON_URL=<%LOGDIR%\%FILE_NAME%

:loop
CALL :get_url "%VERNON_URL%/"
CALL :post_url "%VERNON_URL%/edit" "firstName=Vernon&lastName=Dunsley%1&address=4+Privet+Drive&city=Little+Whinging+Surrey&telephone=123456789"
CALL :post_url "%VERNON_URL%/edit" "firstName=Vernon&lastName=Dudsley%1&address=4+Privet+Drive&city=Little+Whinging+Surrey&telephone=123456789"
GOTO loop



:: Force execution to quit before reaching the functions
EXIT /B %ERRORLEVEL%

:: ############################################
:: # Functions to be called for creating Load #
:: ############################################

:: Perform a GET request to the given URL and discard the output data
:get_url
REM ECHO Get %1
REM ECHO(
curl -4 --connect-timeout 10 --retry 20 --retry-delay 5 --retry-connrefused -sSf -o NUL %1 >> NUL
EXIT /B 0

:: Perform a POST request to the fiven URL, then sleep 1 second and output the url the server redirects to.
:post_url
REM ECHO POST %1: %2
REM ECHO(
curl -4 --connect-timeout 10 --retry 20 --retry-delay 5 --retry-connrefused -sSf -w '%%{redirect_url}' -o NUL -X POST -d %2 %1 >> NUL
TIMEOUT /T 1 /nobreak > NUL
EXIT /B 0

:: Perform a POST request to the fiven URL, then sleep 1 second and output the url the server redirects to to a file for future use.
:post_and_save_url
REM ECHO POST %1: %2
REM ECHO(
break > %LOGDIR%\%FILE_NAME% 
curl -4 --connect-timeout 10 --retry 20 --retry-delay 5 --retry-connrefused -sSf -w %%{redirect_url} -X POST -d %2 %1 >> %LOGDIR%\%FILE_NAME%
ECHO(
TYPE %LOGDIR%\%FILE_NAME%
TIMEOUT /T 1 /nobreak > NUL
EXIT /B 0

