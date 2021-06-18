@echo off
setlocal

set BASEDIR=%~dp0

cd %BASEDIR%
cd server
call bin\shutdown.bat