@echo off
setlocal enabledelayedexpansion

echo Check Java minor version is 8+

rem Test if system variable JAVA_HOME is set.
if "x%JAVA_HOME%" == "x" (
    echo JAVA_HOME is not set. Trying to use java in path.
    set JAVA=java
rem If JAVA_HOME system variable is not set try to use java command in the path.
) else (
    echo JAVA_HOME is set to: "%JAVA_HOME%"
    rem Verify that value of JAVA_HOME refer to a folder that actually exists.
    if not exist "%JAVA_HOME%" (
        rem Folder does not exist.
        echo JAVA_HOME "%JAVA_HOME%" path doesn't exist
        exit /b 1
    ) else (
        rem Value of JAVA_HOME point to an existing folder.
        rem Build the full path to java executable.
        set JAVA=%JAVA_HOME%\bin\java
        echo Java command path is "%JAVA%"
    )
)

echo Run "java -version" and parse the output
rem 2>&1 allow to redirect error output to standard output. We do that because java -version print to error output.
rem the pipe | takes output of the java -version command and pass it to findstr command. 
rem findstr version will search for the word "version" is in the multiple lines output of java -version and return the single line that include the word "version".
rem ^ is used to escape special characters.
rem /f tokens=3 allow to only consider the third token on the line. I.e. the version number between quotes.
rem matching token is stored in %%g variable (local to the for loop)
for /f "tokens=3" %%g in ('"%JAVA%" -version 2^>^&1 ^| findstr version') do (
    rem Store the token value in JAVAVER variable.
    set JAVAVER=%%g
)

echo Java version: %JAVAVER%

echo Parsing Java version to get minor version
for /f "delims=. tokens=2" %%v in ("%JAVAVER%") do (
    set VERSION_NUMBER=%%v
)

echo Java minor version is: %VERSION_NUMBER%

echo Check that Java minor version is compatible with WildFly (need to be 8 or higher)
if "%VERSION_NUMBER%" LSS "8" (
    rem Java minor version is lower then 8. Not supported by WildFly.
    echo Invalid Java minor version %VERSION_NUMBER% ^< 8. Please set JAVA_HOME system variable to a JDK / JRE 8+
    exit /b 1
)
echo Java minor version is compatible

IF NOT EXIST setup GOTO NOSETUPDIR
echo ------------------------------------------------------
echo Initializing and configuring Bonita BPM WildFly bundle
echo ------------------------------------------------------
shift
call setup\setup.bat init %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
if errorlevel 1 (
    exit /b 1
)
call setup\setup.bat configure %0 %1 %2 %3 %4 %5 %6 %7 %8 %9
if errorlevel 1 (
    exit /b 1
)

:NOSETUPDIR
echo "------------------------------------------------------"
echo "Starting Bonita BPM WildFly bundle"
echo "------------------------------------------------------"
call server\bin\standalone.bat

pause

endlocal