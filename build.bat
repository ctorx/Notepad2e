@echo off
setlocal
REM Launcher for build.ps1 — usage: build.bat   or   build.bat -Configuration Debug -Platform x64
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build.ps1" %*
exit /b %ERRORLEVEL%
