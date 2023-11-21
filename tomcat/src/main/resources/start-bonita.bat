@echo off
setlocal

set BASEDIR=%~dp0
echo BASEDIR: %BASEDIR%

:: Test if system variable JRE_HOME is set.
if "x%JRE_HOME%" == "x" (
    echo JRE_HOME is not set. Trying to use JAVA_HOME instead...
    if "x%JAVA_HOME%" == "x" (
        echo No Java command could be found. Please set JRE_HOME or JAVA_HOME variable to a JRE / JDK
        goto exit
    ) else (
        echo JAVA_HOME is set to: %JAVA_HOME%
        :: Verify that value of JAVA_HOME refer to a folder that actually exists.
        if not exist "%JAVA_HOME%" (
            :: Folder does not exist.
            echo JAVA_HOME "%JAVA_HOME%" path doesn't exist
            goto exit
        ) else (
            :: Value of JAVA_HOME points to an existing folder.
            :: Build the full path to java executable.
            set JAVA_CMD=%JAVA_HOME%\bin\java
        )
    )
) else (
    echo JRE_HOME is set to: "%JRE_HOME%"
    :: Verify that value of JRE_HOME refer to a folder that actually exists.
    if not exist "%JRE_HOME%" (
        :: Folder does not exist.
        echo JRE_HOME "%JRE_HOME%" path doesn't exist
        goto exit
    ) else (
        :: Value of JRE_HOME points to an existing folder.
        :: Build the full path to java executable.
        set JAVA_CMD=%JRE_HOME%\bin\java
    )
)
echo Java command path is %JAVA_CMD%

echo Check that Java version is compatible with Bonita
:: 2>&1 allow to redirect error output to standard output. We do that because java -version print to error output.
:: the pipe | takes output of the java -version command and pass it to findstr command.
:: findstr version will search for the word "version" is in the multiple lines output of java -version and return the single line that include the word "version".
:: ^ is used to escape special characters.
:: /f tokens=3 allow to only consider the third token on the line. I.e. the version number between quotes.
:: matching token is stored in %%g variable (local to the for loop)
for /f "tokens=3" %%g in ('"%JAVA_CMD%" -version 2^>^&1 ^| findstr version') do (
    set JAVAVER=%%g
)

:: Remove quotes from the version for easier processing
set JAVAVER=%JAVAVER:"=%
echo Java full version: %JAVAVER%

for /f "delims=. tokens=1" %%v in ("%JAVAVER%") do (
    set VERSION_NUMBER_1ST_DIGIT=%%v
)
:: pre Java 9 versions, get minor version
if "%VERSION_NUMBER_1ST_DIGIT%" EQU "1" (
  for /f "delims=. tokens=2" %%v in ("%JAVAVER%") do (
      set VERSION_NUMBER=%%v
  )
) else (
  set VERSION_NUMBER=%VERSION_NUMBER_1ST_DIGIT%
)
echo Java version: %VERSION_NUMBER%

if "%VERSION_NUMBER%" NEQ "17" (
    echo Invalid Java version %VERSION_NUMBER%. Please set JRE_HOME or JAVA_HOME system variable to a JRE / JDK 17
    goto exit
)
echo Java version is compatible

IF NOT EXIST %BASEDIR%\setup GOTO NOSETUPDIR
echo ------------------------------------------------------
echo Initializing and configuring Bonita Tomcat bundle
echo ------------------------------------------------------
shift
call %BASEDIR%\setup\setup.bat init %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
if errorlevel 1 (
   goto exit
)
call %BASEDIR%\setup\setup.bat configure %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
if errorlevel 1 (
   goto exit
)

:NOSETUPDIR
cd %BASEDIR%
cd server
echo "-----------------------------------------------------"
echo "Starting Bonita Tomcat bundle"
echo "-----------------------------------------------------"
call bin\startup.bat
exit /b 0

:exit
:: pause to let the user read the error message:
pause
exit /b 1
