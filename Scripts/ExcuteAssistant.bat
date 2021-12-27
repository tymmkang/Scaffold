@echo off
FOR %%I IN ("%~dp0.") DO SET "PROJECT_ROOT_DIR=%%~dpI"

set ASSISTANT_DIR=%PROJECT_ROOT_DIR%Assistant\
set ASSISTANT_EXE=%PROJECT_ROOT_DIR%Output\Scaffold-Assistant\Release\Scaffold-Assistant.exe

cmake --version >nul 2>&1
if ERRORLEVEL 1 (
    echo Not found CMake
)

:: Build CMake project
echo. 
cmake -S %ASSISTANT_DIR% -B %ASSISTANT_DIR%\CMakeBuild

:: Build Scaffold-Assistant excutable (Release)
echo.
cmake --build %ASSISTANT_DIR%\CMakeBuild --target Scaffold-Assistant --config Release

:: Run Scaffold-Assistant
echo.
%ASSISTANT_EXE% %*

