@ECHO OFF
:: ####################################
:: # Inspired by EaaS (see README.md) #
:: ####################################

:: Init
SET URL=http://localhost:8075
SET BINDIR=%~dp0
SET LOGDIR=%BINDIR%log
SET FILE_NAME="hp-url%1.txt"
cd %BINDIR%

:: Create log directory if it does not already exist.
IF EXIST %LOGDIR%\NUL GOTO skipInit
MKDIR %LOGDIR%
:skipInit


:: Create load
CALL :get_url "%URL%/"
CALL :get_url "%URL%/owners/new"
CALL :post_and_save_url "%URL%/owners/new" "firstName=Harry&lastName=Potter&address=4+Privet+Drive&city=Little+Whinging+Surrey&telephone=123456789" "%FILE_NAME%"

SET /p HP_URL=<%LOGDIR%\%FILE_NAME%

:loop
CALL :post_url "%HP_URL%/pets/new" "id=&name=Hedwig&birthDate=2000-01-01&type=bird"
CALL :post_url "%HP_URL%/pets/new" "name=Nagini&birthDate=2001-01-01&type=snake"
CALL :post_url "%HP_URL%/pets/new" "name=Fluffy&birthDate=2002-01-01&type=dog"
CALL :post_url "%HP_URL%/pets/new" "name=Scabbers&birthDate=2003-01-01&type=hamster"
TIMEOUT /T 2 /nobreak > NUL



:: Force execution to quit before reaching the functions
EXIT /B %ERRORLEVEL%

:: ############################################
:: # Functions to be called for creating Load #
:: ############################################

:: Perform a GET request to the given URL and discard the output data
:get_url
REM ECHO Get %1
curl -4 --connect-timeout 10 --retry 20 --retry-delay 5 --retry-connrefused -sSf -o NUL %1 >> NUL
EXIT /B 0

:: Perform a POST request to the fiven URL, then sleep 1 second and output the url the server redirects to.
:post_url
REM ECHO POST %1: %2 
curl -4 --connect-timeout 10 --retry 20 --retry-delay 5 --retry-connrefused -sSf -w '%%{redirect_url}' -o NUL -X POST -d %2 %1
TIMEOUT /T 1 /nobreak > NUL
EXIT /B 0

:: Perform a POST request to the fiven URL, then sleep 1 second and output the url the server redirects to to a file for future use.
:post_and_save_url
REM ECHO POST %1: %2 %3
break > %LOGDIR%\%3
curl -4 --connect-timeout 10 --retry 20 --retry-delay 5 --retry-connrefused -sSf -w %%{redirect_url} -X POST -d %2 %1 >> %LOGDIR%\%3
TYPE %LOGDIR%\%3
TIMEOUT /T 1 /nobreak > NUL
EXIT /B 0

