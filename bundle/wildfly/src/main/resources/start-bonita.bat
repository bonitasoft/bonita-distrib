@echo off
setlocal

:: Test if system variable JAVA_HOME is set.
if "x%JAVA_HOME%" == "x" (
    echo JAVA_HOME is not set. Use java in path.
    set JAVA_CMD=java
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
      set VERSION_EXPECTED=8
  )
) else (
  set VERSION_NUMBER=%VERSION_NUMBER_1ST_DIGIT%
  set VERSION_EXPECTED=11
)
echo Java version: %VERSION_NUMBER%

if "%VERSION_NUMBER%" NEQ "%VERSION_EXPECTED%" (
    echo Invalid Java version %VERSION_NUMBER% not 8 or 11. Please set JAVA_HOME system variable to a JRE / JDK related to one of these versions
    goto exit
)
echo Java version is compatible

IF NOT EXIST setup GOTO NOSETUPDIR
echo ------------------------------------------------------
echo Initializing and configuring Bonita WildFly bundle
echo ------------------------------------------------------

echo "------------------------------------------------------"
echo "WARNING: Bonita WildFly bundle has been deprecated in Bonita 7.9."
echo "We advise you to switch to the Tomcat bundle when migrating to Bonita 7.9."
echo "The WildFly bundle was mainly used with the SQL Server database. The Tomcat bundle is now compatible with it, and is the recommended solution."
echo "------------------------------------------------------"
shift
call setup\setup.bat init %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
if errorlevel 1 (
   goto exit
)
call setup\setup.bat configure %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
if errorlevel 1 (
   goto exit
)

:NOSETUPDIR
echo "------------------------------------------------------"
echo "Starting Bonita WildFly bundle"
echo "------------------------------------------------------"
call server\bin\standalone.bat

pause
exit /b 0

:exit
:: pause to let the user read the error message:
pause
exit /b 1
