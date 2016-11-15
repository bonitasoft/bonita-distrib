@echo off
setlocal

rem Check Java version is 8+
if "x%JAVA_HOME%" == "x" (
    set JAVA=java
) else (
    if not exist "%JAVA_HOME%" (
        echo JAVA_HOME "%JAVA_HOME%" path doesn't exist
        exit /b 1
    ) else (
        set "JAVA=%JAVA_HOME%\bin\java"
    )
)

for /f "tokens=3" %%g in ('%JAVA% -version 2^>^&1 ^| findstr /i "version"') do (
    set JAVAVER=%%g
)

set JAVAVER=%JAVAVER:"=%
for /f "delims=. tokens=2" %%v in ("%JAVAVER%") do (
    set VERSION_NUMBER=%%v
)

if "%VERSION_NUMBER%" LSS "8" (
    echo Wrong Java version %VERSION_NUMBER%^<8. Please set JAVA_HOME variable to a JDK / JRE 8+
    exit /b 1
)


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

endlocal