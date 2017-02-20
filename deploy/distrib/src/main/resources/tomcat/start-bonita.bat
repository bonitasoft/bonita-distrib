@echo off
setlocal

:: Test if system variable JRE_HOME is set.
if "x%JRE_HOME%" == "x" (
    echo JRE_HOME is not set. Trying to use JAVA_HOME instead...
    if "x%JAVA_HOME%" == "x" (
        echo No Java command could be found. Please set JRE_HOME or JAVA_HOME variable to a JRE / JDK 1.8+
        goto exit
    ) else (
        echo JAVA_HOME is set to: %JAVA_HOME%
        REM Verify that value of JAVA_HOME refer to a folder that actually exists.
        if not exist "%JAVA_HOME%" (
            REM Folder does not exist.
            echo JAVA_HOME "%JAVA_HOME%" path doesn't exist
            goto exit
        ) else (
            REM Value of JAVA_HOME points to an existing folder.
            REM Build the full path to java executable.
            set JAVA_CMD="%JAVA_HOME%\bin\java"
        )
    )
) else (
    echo JRE_HOME is set to: "%JRE_HOME%"
    REM Verify that value of JRE_HOME refer to a folder that actually exists.
    if not exist "%JRE_HOME%" (
        REM Folder does not exist.
        echo JRE_HOME "%JRE_HOME%" path doesn't exist
        goto exit
    ) else (
        REM Value of JRE_HOME points to an existing folder.
        REM Build the full path to java executable.
        set JAVA_CMD="%JRE_HOME%\bin\java"
    )
)
echo Java command path is %JAVA_CMD%

:: 2>&1 allow to redirect error output to standard output. We do that because java -version print to error output.
:: the pipe | takes output of the java -version command and pass it to findstr command.
:: findstr version will search for the word "version" is in the multiple lines output of java -version and return the single line that include the word "version".
:: ^ is used to escape special characters.
:: /f tokens=3 allow to only consider the third token on the line. I.e. the version number between quotes.
:: matching token is stored in %%g variable (local to the for loop)
for /f "tokens=3" %%g in ('"%JAVA_CMD%" -version 2^>^&1 ^| findstr version') do (
    REM Store the token value in JAVAVER variable.
    set JAVAVER=%%g
)

echo Java version: %JAVAVER%

for /f "delims=. tokens=2" %%v in ("%JAVAVER%") do (
    set VERSION_NUMBER=%%v
)

echo Check that Java minor version is compatible with Bonita BPM 7.5+ (need to be 8 or higher)...
if "%VERSION_NUMBER%" LSS "8" (
    REM Java minor version is lower then 8. Not supported by Bonita BPM 7.5+.
    echo Invalid Java minor version 1.%VERSION_NUMBER% ^< 1.8. Please set JRE_HOME or JAVA_HOME variable to a JRE / JDK 1.8+
    goto exit
)
echo Java minor version is compatible

IF NOT EXIST setup GOTO NOSETUPDIR
	echo "-----------------------------------------------------"
    echo "Initializing and configuring Bonita BPM Tomcat bundle"
	echo "-----------------------------------------------------"
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
cd server
echo "-----------------------------------------------------"
echo "Starting Tomcat server..."
echo "-----------------------------------------------------"
call bin\startup.bat
cd ..
exit /b 0

:exit
:: pause to let the user read the error message:
pause
exit /b 1