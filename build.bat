@echo off
setlocal enabledelayedexpansion

:: Enhanced compile script for ecommerce backend (Windows)
:: Usage: build.bat [service_name] [--clean] [--help]
:: Examples:
::   build.bat                    - Compile entire backend
::   build.bat security           - Compile only security service
::   build.bat config_server      - Compile only config server
::   build.bat --clean            - Clean and compile entire backend

:: Available services and cores
set "AVAILABLE_SERVICES=core security config_server discovery-server gateway identity commons grpc-common xml_signer"

:: Initialize variables
set "SERVICE="
set "CLEAN=false"
set "WITH_TESTS=false"
set "ERROR_CODE=0"

:: Functions for colored output (using echo with different formatting)
goto :main

:print_info
echo [INFO] %~1
exit /b

:print_success
echo [SUCCESS] %~1
exit /b

:print_error
echo [ERROR] %~1
exit /b

:print_warning
echo [WARNING] %~1
exit /b

:show_usage
echo Enhanced Compile Script for Ecommerce Backend (Windows)
echo.
echo Usage: %~nx0 [service_name] [options]
echo.
echo Available services:
echo   core              - Compile services:core
echo   security          - Compile services:security
echo   config_server     - Compile core:config_server
echo   discovery-server  - Compile core:discovery-server
echo   gateway           - Compile core:gateway
echo   identity          - Compile core:identity
echo   commons           - Compile libs:commons:lib
echo   grpc-common       - Compile libs:grpc-common:lib
echo   xml_signer        - Compile libs:xml_signer:lib
echo.
echo Options:
echo   --clean           - Clean before compile
echo   --with-tests      - Include tests in compile
echo   --help            - Show this help message
echo.
echo Examples:
echo   %~nx0                        # Compile entire backend
echo   %~nx0 security               # Compile only security service
echo   %~nx0 security --clean       # Clean and compile security service
echo   %~nx0 --clean                # Clean and compile entire backend
echo.
exit /b

:validate_service
set "service_to_check=%~1"
set "is_valid=false"
for %%s in (%AVAILABLE_SERVICES%) do (
    if "%%s"=="%service_to_check%" (
        set "is_valid=true"
        goto :validate_service_end
    )
)
:validate_service_end
if "%is_valid%"=="true" (
    exit /b 0
) else (
    exit /b 1
)

:get_gradle_project
set "service=%~1"
if "%service%"=="core" (
    set "gradle_project=:services:core"
) else if "%service%"=="security" (
    set "gradle_project=:services:security"
) else if "%service%"=="config_server" (
    set "gradle_project=:core:config_server"
) else if "%service%"=="discovery-server" (
    set "gradle_project=:core:discovery-server"
) else if "%service%"=="gateway" (
    set "gradle_project=:core:gateway"
) else if "%service%"=="identity" (
    set "gradle_project=:core:identity"
) else if "%service%"=="commons" (
    set "gradle_project=:libs:commons:lib"
) else if "%service%"=="grpc-common" (
    set "gradle_project=:libs:grpc-common:lib"
) else if "%service%"=="xml_signer" (
    set "gradle_project=:libs:xml_signer:lib"
) else (
    set "gradle_project="
)
exit /b

:main
:: Parse command line arguments
:parse_args
if "%~1"=="" goto :args_parsed
if "%~1"=="--help" goto :show_help
if "%~1"=="-h" goto :show_help
if "%~1"=="--clean" (
    set "CLEAN=true"
    shift
    goto :parse_args
)
if "%~1"=="--with-tests" (
    set "WITH_TESTS=true"
    shift
    goto :parse_args
)
if "%~1:~0,2"=="--" (
    call :print_error "Unknown option: %~1"
    call :show_usage
    exit /b 1
)
if not "%SERVICE%"=="" (
    call :print_error "Multiple services specified. Please specify only one service."
    exit /b 1
)
set "SERVICE=%~1"
shift
goto :parse_args

:show_help
call :show_usage
exit /b 0

:args_parsed

:: Get script directory and backend directory
set "SCRIPT_DIR=%~dp0"
set "BACKEND_DIR=%SCRIPT_DIR%backend"

:: Navigate to backend directory
if not exist "%BACKEND_DIR%" (
    call :print_error "Backend directory not found: %BACKEND_DIR%"
    exit /b 1
)

cd /d "%BACKEND_DIR%"
call :print_info "Changed to backend directory: %BACKEND_DIR%"

:: Check if gradlew.bat exists
if not exist "gradlew.bat" (
    call :print_error "Gradle wrapper not found in backend directory"
    exit /b 1
)

:: Build gradle command
set "GRADLE_CMD=gradlew.bat"

:: Add clean if requested
if "%CLEAN%"=="true" (
    set "GRADLE_CMD=!GRADLE_CMD! clean"
)

:: Determine what to build
if not "%SERVICE%"=="" (
    :: Validate service name
    call :validate_service "%SERVICE%"
    if errorlevel 1 (
        call :print_error "Invalid service name: %SERVICE%"
        echo Available services: %AVAILABLE_SERVICES%
        exit /b 1
    )
    
    :: Get gradle project path
    call :get_gradle_project "%SERVICE%"
    call :print_info "Compiling specific service: %SERVICE% (!gradle_project!)"
    set "GRADLE_CMD=!GRADLE_CMD! !gradle_project!:build"
) else (
    call :print_info "Compiling entire backend"
    set "GRADLE_CMD=!GRADLE_CMD! build"
)

:: Add test exclusion unless explicitly requested
if not "%WITH_TESTS%"=="true" (
    set "GRADLE_CMD=!GRADLE_CMD! -x test"
)

:: Add refresh dependencies
set "GRADLE_CMD=!GRADLE_CMD! --refresh-dependencies"

:: Execute the compile
call :print_info "Executing: !GRADLE_CMD!"
echo.

call !GRADLE_CMD!
set "BUILD_RESULT=!errorlevel!"

echo.
if !BUILD_RESULT! equ 0 (
    if not "%SERVICE%"=="" (
        call :print_success "Successfully compiled service: %SERVICE%"
    ) else (
        call :print_success "Successfully compiled entire backend"
    )
) else (
    if not "%SERVICE%"=="" (
        call :print_error "Failed to compile service: %SERVICE%"
    ) else (
        call :print_error "Failed to compile backend"
    )
    exit /b !BUILD_RESULT!
)

endlocal