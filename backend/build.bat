@echo off
REM =====================================================
REM E-Commerce Backend Build Script (Windows)
REM =====================================================
REM Usage: build.bat [layer] [module] [run_tests]
REM 
REM Parameters:
REM   layer     : core, services, libs, or all (default: all)
REM   module    : specific module name or all (default: all)
REM   run_tests : true/false (default: false)
REM
REM Examples:
REM   build.bat                           # Build all with no tests
REM   build.bat core                      # Build all core modules with no tests
REM   build.bat core config_server        # Build only config_server with no tests
REM   build.bat services core true        # Build services:core with tests
REM   build.bat all all true              # Build everything with tests
REM =====================================================

setlocal enabledelayedexpansion

REM Default values
set "LAYER=%~1"
set "MODULE=%~2"
set "RUN_TESTS=%~3"

if "%LAYER%"=="" set "LAYER=all"
if "%MODULE%"=="" set "MODULE=all"
if "%RUN_TESTS%"=="" set "RUN_TESTS=false"

REM Valid modules
set "CORE_MODULES=config_server discovery-server gateway identity"
set "SERVICES_MODULES=core security invoicing"
set "LIBS_MODULES=commons grpc-common xml_signer"

echo ======================================================
echo          E-Commerce Backend Build Script
echo ======================================================
echo Layer: %LAYER%
echo Module: %MODULE%
echo Run Tests: %RUN_TESTS%
echo.

REM Function to show help
if "%1"=="--help" goto :show_help
if "%1"=="-h" goto :show_help
if "%1"=="/?" goto :show_help

REM Validate layer
if "%LAYER%"=="core" goto :validate_module
if "%LAYER%"=="services" goto :validate_module
if "%LAYER%"=="libs" goto :validate_module
if "%LAYER%"=="all" goto :validate_module
echo Error: Invalid layer '%LAYER%'. Valid options: core, services, libs, all
exit /b 1

:validate_module
if "%MODULE%"=="all" goto :build_start

REM Validate module for specific layer
if "%LAYER%"=="core" (
    echo %CORE_MODULES% | findstr /i /c:"%MODULE%" >nul
    if errorlevel 1 (
        echo Error: Invalid core module '%MODULE%'. Valid options: %CORE_MODULES%
        exit /b 1
    )
)

if "%LAYER%"=="services" (
    echo %SERVICES_MODULES% | findstr /i /c:"%MODULE%" >nul
    if errorlevel 1 (
        echo Error: Invalid services module '%MODULE%'. Valid options: %SERVICES_MODULES%
        exit /b 1
    )
)

if "%LAYER%"=="libs" (
    echo %LIBS_MODULES% | findstr /i /c:"%MODULE%" >nul
    if errorlevel 1 (
        echo Error: Invalid libs module '%MODULE%'. Valid options: %LIBS_MODULES%
        exit /b 1
    )
)

:build_start
echo Validating parameters...
echo ✓ Parameters validated
echo.

REM Set test flag
set "TEST_FLAG="
if "%RUN_TESTS%"=="false" set "TEST_FLAG=-x test"

echo Starting build process...
echo.

REM Always clean first
echo Step 1: Cleaning previous builds...
call gradlew.bat clean
if errorlevel 1 (
    echo Build failed during clean step
    exit /b 1
)
echo.

REM Determine build targets
set "TARGETS="

if "%LAYER%"=="all" if "%MODULE%"=="all" (
    echo Step 2: Building all projects with generateProto...
    call gradlew.bat generateProto build %TEST_FLAG%
    goto :build_complete
)

if "%LAYER%"=="core" if "%MODULE%"=="all" (
    echo Step 2: Building all core modules with generateProto...
    call gradlew.bat :core:config_server:build :core:discovery-server:build :core:gateway:build :core:identity:generateProto :core:identity:build %TEST_FLAG%
    goto :build_complete
)

if "%LAYER%"=="services" if "%MODULE%"=="all" (
    echo Step 2: Building all services modules with generateProto...
    call gradlew.bat :services:core:generateProto :services:security:generateProto :services:invoicing:generateProto :services:core:build :services:security:build :services:invoicing:build %TEST_FLAG%
    goto :build_complete
)

if "%LAYER%"=="libs" if "%MODULE%"=="all" (
    echo Step 2: Building all libs modules...
    call gradlew.bat :libs:commons:lib:build :libs:grpc-common:lib:generateProto :libs:grpc-common:lib:build :libs:xml_signer:lib:build %TEST_FLAG%
    goto :build_complete
)

REM Build specific module
if "%LAYER%"=="libs" (
    echo Step 2: Building specific libs module: %MODULE%...
    if "%MODULE%"=="grpc-common" (
        call gradlew.bat :libs:%MODULE%:lib:generateProto :libs:%MODULE%:lib:build %TEST_FLAG%
    ) else (
        call gradlew.bat :libs:%MODULE%:lib:build %TEST_FLAG%
    )
) else (
    echo Step 2: Building specific module: %LAYER%:%MODULE%...
    if "%LAYER%"=="core" (
        if "%MODULE%"=="identity" (
            call gradlew.bat :%LAYER%:%MODULE%:generateProto :%LAYER%:%MODULE%:build %TEST_FLAG%
        ) else (
            call gradlew.bat :%LAYER%:%MODULE%:build %TEST_FLAG%
        )
    ) else (
        REM All services have generateProto
        call gradlew.bat :%LAYER%:%MODULE%:generateProto :%LAYER%:%MODULE%:build %TEST_FLAG%
    )
)

:build_complete
if errorlevel 1 (
    echo.
    echo ======================================================
    echo          Build failed!
    echo ======================================================
    exit /b 1
)

echo.
echo ======================================================
echo          Build completed successfully!
echo ======================================================
goto :end

:show_help
echo Usage: %0 [layer] [module] [run_tests]
echo.
echo Parameters:
echo   layer     : core, services, libs, or all (default: all)
echo   module    : specific module name or all (default: all)
echo   run_tests : true/false (default: false)
echo.
echo Available modules by layer:
echo   core:     %CORE_MODULES%
echo   services: %SERVICES_MODULES%
echo   libs:     %LIBS_MODULES%
echo.
echo Examples:
echo   %0                           # Build all with no tests
echo   %0 core                      # Build all core modules with no tests
echo   %0 core config_server        # Build only config_server with no tests
echo   %0 services core true        # Build services:core with tests
echo   %0 all all true              # Build everything with tests
goto :end

:end
endlocal