@echo off
set APP_HOME=%~dp0
set GRADLE_VERSION=8.7
set GRADLE_HOME=%USERPROFILE%\.gradle\wrapper\dists\gradle-%GRADLE_VERSION%-bin\local
set GRADLE_BIN=%GRADLE_HOME%\gradle-%GRADLE_VERSION%\bin\gradle.bat
if not exist "%GRADLE_BIN%" (
  if not exist "%GRADLE_HOME%" mkdir "%GRADLE_HOME%"
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri https://services.gradle.org/distributions/gradle-%GRADLE_VERSION%-bin.zip -OutFile '%GRADLE_HOME%\gradle.zip'; Expand-Archive -Force '%GRADLE_HOME%\gradle.zip' '%GRADLE_HOME%'"
)
call "%GRADLE_BIN%" %*
