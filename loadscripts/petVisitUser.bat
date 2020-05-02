@ECHO OFF
:: ####################################
:: # Inspired by EaaS (see README.md) #
:: ####################################

:: Init
SET URL=http://localhost:8075
SET BINDIR=%~dp0
SET LOGDIR=%BINDIR%log
SET FILE_NAME="hp-url%1.txt"
SET TO=2
SET VISITS=4
IF NOT "%2"=="" SET TO=%2
IF NOT "%3"=="" SET VISITS=4=%3
cd %BINDIR%

:: Create log directory if it does not already exist.
IF EXIST %LOGDIR%\NUL GOTO skipInit
MKDIR %LOGDIR%
:skipInit


:: Create load
CALL :get_url "%URL%/"
SET HP_URL="http://localhost:8075/owners/%1"

SET COUNT=0

:loop
CALL :get_url "http://localhost:8075/owners/%1/pets/%1/visits/new"
CALL :get_url "%URL%"
SET /A COUNT=COUNT+1
IF NOT %COUNT%==%VISITS% GOTO loop
ECHO Visitor%1: %COUNT% visits reached. Waiting for %TO% seconds.
TIMEOUT /T %TO% /nobreak > NUL
SET COUNT=0
GOTO loop


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
curl -4 --connect-timeout 10 --retry 20 --retry-delay 5 --retry-connrefused -sSf -w '%%{redirect_url}' -o NUL -X POST -d %2 %1 >> NUL
EXIT /B 0

:: Perform a POST request to the fiven URL, then sleep 1 second and output the url the server redirects to to a file for future use.
:post_and_save_url
REM ECHO POST %1: %2 %3
break > %LOGDIR%\%3
curl -4 --connect-timeout 10 --retry 20 --retry-delay 5 --retry-connrefused -sSf -w %%{redirect_url} -X POST -d %2 %1 >> %LOGDIR%\%3
TYPE %LOGDIR%\%3
TIMEOUT /T 1 /nobreak > NUL
EXIT /B 0

