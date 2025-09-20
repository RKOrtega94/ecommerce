#!/bin/bash

# Enhanced compile script for ecommerce backend
# Usage: ./build.sh [service_name] [--clean] [--help]
# Examples:
#   ./build.sh                    # Compile entire backend
#   ./build.sh security           # Compile only security service
#   ./build.sh config_server      # Compile only config server
#   ./build.sh --clean            # Clean and compile entire backend

set -e  # Exit on any error

# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Available services and cores
AVAILABLE_SERVICES=(
    "core"
    "security"
    "config_server"
    "discovery-server" 
    "gateway"
    "identity"
    "commons"
    "grpc-common"
    "xml_signer"
    "invoicing"
)

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Enhanced Compile Script for Ecommerce Backend"
    echo ""
    echo "Usage: $0 [service_name] [options]"
    echo ""
    echo "Available services:"
    echo "  core              - Compile services:core"
    echo "  security          - Compile services:security"
    echo "  config_server     - Compile core:config_server"
    echo "  discovery-server  - Compile core:discovery-server"
    echo "  gateway           - Compile core:gateway"
    echo "  identity          - Compile core:identity"
    echo "  commons           - Compile libs:commons:lib"
    echo "  grpc-common       - Compile libs:grpc-common:lib"
    echo "  xml_signer        - Compile libs:xml_signer:lib"
    echo "  invoicing         - Compile services:invoicing"
    echo ""
    echo "Options:"
    echo "  --clean           - Clean before compile"
    echo "  --with-tests      - Include tests in compile"
    echo "  --help            - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                        # Compile entire backend"
    echo "  $0 security               # Compile only security service"
    echo "  $0 security --clean       # Clean and compile security service"
    echo "  $0 --clean                # Clean and compile entire backend"
    echo ""
}

# Function to validate service name
validate_service() {
    local service=$1
    for valid_service in "${AVAILABLE_SERVICES[@]}"; do
        if [[ "$valid_service" == "$service" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to map service name to gradle project path
get_gradle_project() {
    local service=$1
    case $service in
        "core") echo ":services:core" ;;
        "security") echo ":services:security" ;;
        "config_server") echo ":core:config_server" ;;
        "discovery-server") echo ":core:discovery-server" ;;
        "gateway") echo ":core:gateway" ;;
        "identity") echo ":core:identity" ;;
        "commons") echo ":libs:commons:lib" ;;
        "grpc-common") echo ":libs:grpc-common:lib" ;;
        "xml_signer") echo ":libs:xml_signer:lib" ;;
        "invoicing") echo ":services:invoicing" ;;
        *) echo "" ;;
    esac
}

# Parse command line arguments
SERVICE=""
CLEAN=false
WITH_TESTS=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            show_usage
            exit 0
            ;;
        --clean)
            CLEAN=true
            shift
            ;;
        --with-tests)
            WITH_TESTS=true
            shift
            ;;
        -*)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
        *)
            if [[ -z "$SERVICE" ]]; then
                SERVICE="$1"
            else
                print_error "Multiple services specified. Please specify only one service."
                exit 1
            fi
            shift
            ;;
    esac
done

# Navigate to backend directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/backend"

if [[ ! -d "$BACKEND_DIR" ]]; then
    print_error "Backend directory not found: $BACKEND_DIR"
    exit 1
fi

cd "$BACKEND_DIR" || exit 1
print_info "Changed to backend directory: $BACKEND_DIR"

# Check if gradlew exists
if [[ ! -f "./gradlew" ]]; then
    print_error "Gradle wrapper not found in backend directory"
    exit 1
fi

# Build gradle command
GRADLE_CMD="./gradlew"

# Add clean if requested
if [[ "$CLEAN" == true ]]; then
    GRADLE_CMD="$GRADLE_CMD clean"
fi

# Determine what to build
if [[ -n "$SERVICE" ]]; then
    # Validate service name
    if ! validate_service "$SERVICE"; then
        print_error "Invalid service name: $SERVICE"
        echo "Available services: ${AVAILABLE_SERVICES[*]}"
        exit 1
    fi
    
    # Get gradle project path
    GRADLE_PROJECT=$(get_gradle_project "$SERVICE")
    print_info "Compiling specific service: $SERVICE ($GRADLE_PROJECT)"
    GRADLE_CMD="$GRADLE_CMD $GRADLE_PROJECT:build"
else
    print_info "Compiling entire backend"
    GRADLE_CMD="$GRADLE_CMD build"
fi

# Add test exclusion unless explicitly requested
if [[ "$WITH_TESTS" != true ]]; then
    GRADLE_CMD="$GRADLE_CMD -x test"
fi

# Add refresh dependencies
GRADLE_CMD="$GRADLE_CMD --refresh-dependencies"

# Execute the compile
print_info "Executing: $GRADLE_CMD"
echo ""

if $GRADLE_CMD; then
    echo ""
    if [[ -n "$SERVICE" ]]; then
        print_success "Successfully compiled service: $SERVICE"
    else
        print_success "Successfully compiled entire backend"
    fi
else
    echo ""
    if [[ -n "$SERVICE" ]]; then
        print_error "Failed to compile service: $SERVICE"
    else
        print_error "Failed to compile backend"
    fi
    exit 1
fi