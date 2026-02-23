@echo off
REM Version Sync Script for Windows
REM Run this before building to sync version across all files

echo.
echo ========================================
echo   XWorkout Version Sync
echo ========================================
echo.

REM Change to script directory
cd /d "%~dp0.."

REM Run the Dart sync script
dart run scripts/sync_version.dart

echo.
echo ========================================
echo   Sync Complete!
echo ========================================
echo.
pause
