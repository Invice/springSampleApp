@ECHO OFF
:: ####################################
:: # Inspired by EaaS (see README.md) #
:: ####################################

:: Init
SET URL=http://localhost:8075
SET BINDIR=%~dp0
SET LOGDIR=%BINDIR%log
cd %BINDIR%

:: Create log directory if it does not already exist.
IF EXIST %LOGDIR%\NUL GOTO skipInit
MKDIR %LOGDIR%
:skipInit

:: Create load
CALL :get_url "%URL%/"
CALL :get_url "%URL%/owners/new"
CALL :post_and_save_url "%URL%/owners/new" "firstName=Harry&lastName=Potter&address=4+Privet+Drive&city=Little+Whinging+Surrey&telephone=123456789"

SET /p HP_URL=<%LOGDIR%\hp-url.txt 

:loop
CALL :get_url "%URL%/"
CALL :get_url "%URL%/owners?lastName="
CALL :post_url "%HP_URL%/pets/new" "id=&name=Hedwig&birthDate=2000-01-01&type=bird"
CALL :get_url "%URL%/owners/find"
CALL :get_url "%URL%/owners?lastName=Potter"
CALL :get_url "%HP_URL%"
TIMEOUT /T 1 /nobreak > NUL
CALL :post_url "%URL%/owners/new" "firstName=Petunia&lastName=Dursley&address=4+Privet+Drive&city=Little+Whinging+Surrey&telephone=123456790"
CALL :get_url "%URL%/owners?lastName=Dumbledore"
CALL :get_url "%URL%/vets.html"
TIMEOUT /T 2 /nobreak > NUL
GOTO loop

:: Force execution to quit before reaching the functions
EXIT /B %ERRORLEVEL%

:: ############################################
:: # Functions to be called for creating Load #
:: ############################################

:: Perform a GET request to the given URL and discard the output data
:get_url
ECHO Get %1
curl -4 --connect-timeout 10 --retry 20 --retry-delay 5 --retry-connrefused -sSf -o NUL %1
EXIT /B 0

:: Perform a POST request to the fiven URL, then sleep 1 second and output the url the server redirects to.
:post_url
ECHO POST %1: %2 
curl -4 --connect-timeout 10 --retry 20 --retry-delay 5 --retry-connrefused -sSf -w '%%{redirect_url}' -o NUL -X POST -d %2 %1 
TIMEOUT /T 1 /nobreak > NUL
EXIT /B 0

:: Perform a POST request to the fiven URL, then sleep 1 second and output the url the server redirects to to a file for future use.
:post_and_save_url
ECHO POST %1: %2 
break > %LOGDIR%\hp-url.txt 
curl -4 --connect-timeout 10 --retry 20 --retry-delay 5 --retry-connrefused -sSf -w %%{redirect_url} -X POST -d %2 %1 >> %LOGDIR%\hp-url.txt
TYPE %LOGDIR%\hp-url.txt 
TIMEOUT /T 1 /nobreak > NUL
EXIT /B 0

