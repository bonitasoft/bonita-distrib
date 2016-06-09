@echo off
setlocal

IF EXIST ./setup (
	call ./setup/setup.bat init
	if errorlevel 1 (
		echo ERROR 1 Setting up Bonita BPM platform
		exit 1
	)	
)

call ./bin/standalone.bat 