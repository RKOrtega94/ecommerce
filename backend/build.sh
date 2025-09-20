#!/bin/bash

# =====================================================
# E-Commerce Backend Build Script (Unix/Linux/MacOS)
# =====================================================
# Usage: ./build.sh [layer] [module] [run_tests]
# 
# Parameters:
#   layer     : core, services, libs, or all (default: all)
#   module    : specific module name or all (default: all)
#   run_tests : true/false (default: false)
#
# Examples:
#   ./build.sh                           # Build all with no tests
#   ./build.sh core                      # Build all core modules with no tests
#   ./build.sh core config_server        # Build only config_server with no tests
#   ./build.sh services core true        # Build services:core with tests
#   ./build.sh all all true              # Build everything with tests
# =====================================================

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
LAYER=${1:-all}
MODULE=${2:-all}
RUN_TESTS=${3:-false}

# Valid layers and modules based on settings.gradle
VALID_LAYERS=("core" "services" "libs" "all")
CORE_MODULES=("config_server" "discovery-server" "gateway" "identity")
SERVICES_MODULES=("core" "security" "invoicing")
LIBS_MODULES=("commons" "grpc-common" "xml_signer")

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}         E-Commerce Backend Build Script${NC}"
echo -e "${BLUE}======================================================${NC}"
echo -e "${YELLOW}Layer:${NC} $LAYER"
echo -e "${YELLOW}Module:${NC} $MODULE"
echo -e "${YELLOW}Run Tests:${NC} $RUN_TESTS"
echo ""

# Function to validate layer
validate_layer() {
    if [[ ! " ${VALID_LAYERS[@]} " =~ " ${LAYER} " ]]; then
        echo -e "${RED}Error: Invalid layer '$LAYER'. Valid options: ${VALID_LAYERS[*]}${NC}"
        exit 1
    fi
}

# Function to validate module for a given layer
validate_module() {
    if [ "$MODULE" = "all" ]; then
        return 0
    fi
    
    case $LAYER in
        "core")
            if [[ ! " ${CORE_MODULES[@]} " =~ " ${MODULE} " ]]; then
                echo -e "${RED}Error: Invalid core module '$MODULE'. Valid options: ${CORE_MODULES[*]}${NC}"
                exit 1
            fi
            ;;
        "services")
            if [[ ! " ${SERVICES_MODULES[@]} " =~ " ${MODULE} " ]]; then
                echo -e "${RED}Error: Invalid services module '$MODULE'. Valid options: ${SERVICES_MODULES[*]}${NC}"
                exit 1
            fi
            ;;
        "libs")
            if [[ ! " ${LIBS_MODULES[@]} " =~ " ${MODULE} " ]]; then
                echo -e "${RED}Error: Invalid libs module '$MODULE'. Valid options: ${LIBS_MODULES[*]}${NC}"
                exit 1
            fi
            ;;
    esac
}

# Function to build specific targets
build_targets() {
    local targets=""
    local test_flag=""
    
    # Set test flag
    if [ "$RUN_TESTS" = "false" ]; then
        test_flag="-x test"
    fi
    
    # Determine targets based on layer and module
    if [ "$LAYER" = "all" ] && [ "$MODULE" = "all" ]; then
        targets=""  # Build everything
    elif [ "$LAYER" != "all" ] && [ "$MODULE" = "all" ]; then
        # Build all modules in specific layer
        case $LAYER in
            "core")
                targets=":core:config_server:build :core:discovery-server:build :core:gateway:build :core:identity:generateProto :core:identity:build"
                ;;
            "services")
                targets=$(printf ":%s:%s:generateProto :%s:%s:build " "services" "${SERVICES_MODULES[@]}" "services" "${SERVICES_MODULES[@]}")
                ;;
            "libs")
                targets=":libs:commons:lib:build :libs:grpc-common:lib:generateProto :libs:grpc-common:lib:build :libs:xml_signer:lib:build"
                ;;
        esac
    elif [ "$LAYER" != "all" ] && [ "$MODULE" != "all" ]; then
        # Build specific module in specific layer
        if [ "$LAYER" = "libs" ]; then
            if [ "$MODULE" = "grpc-common" ]; then
                targets=":libs:${MODULE}:lib:generateProto :libs:${MODULE}:lib:build"
            else
                targets=":libs:${MODULE}:lib:build"
            fi
        elif [ "$LAYER" = "core" ]; then
            if [ "$MODULE" = "identity" ]; then
                targets=":${LAYER}:${MODULE}:generateProto :${LAYER}:${MODULE}:build"
            else
                targets=":${LAYER}:${MODULE}:build"
            fi
        else
            # All services have generateProto
            targets=":${LAYER}:${MODULE}:generateProto :${LAYER}:${MODULE}:build"
        fi
    fi
    
    echo -e "${GREEN}Starting build process...${NC}"
    echo ""
    
    # Always run clean first
    echo -e "${YELLOW}Step 1: Cleaning previous builds...${NC}"
    ./gradlew clean
    echo ""
    
    # Run the build
    if [ -z "$targets" ]; then
        echo -e "${YELLOW}Step 2: Building all projects with generateProto...${NC}"
        ./gradlew generateProto build $test_flag
    else
        echo -e "${YELLOW}Step 2: Building specific targets with generateProto...${NC}"
        echo -e "${BLUE}Targets: $targets${NC}"
        ./gradlew $targets $test_flag
    fi
}

# Main execution
main() {
    echo -e "${YELLOW}Validating parameters...${NC}"
    validate_layer
    
    if [ "$LAYER" != "all" ]; then
        validate_module
    fi
    
    echo -e "${GREEN}✓ Parameters validated${NC}"
    echo ""
    
    build_targets
    
    echo ""
    echo -e "${GREEN}======================================================${NC}"
    echo -e "${GREEN}         Build completed successfully!${NC}"
    echo -e "${GREEN}======================================================${NC}"
}

# Help function
show_help() {
    echo "Usage: $0 [layer] [module] [run_tests]"
    echo ""
    echo "Parameters:"
    echo "  layer     : core, services, libs, or all (default: all)"
    echo "  module    : specific module name or all (default: all)"
    echo "  run_tests : true/false (default: false)"
    echo ""
    echo "Available modules by layer:"
    echo "  core:     ${CORE_MODULES[*]}"
    echo "  services: ${SERVICES_MODULES[*]}"
    echo "  libs:     ${LIBS_MODULES[*]}"
    echo ""
    echo "Examples:"
    echo "  $0                           # Build all with no tests"
    echo "  $0 core                      # Build all core modules with no tests"
    echo "  $0 core config_server        # Build only config_server with no tests"
    echo "  $0 services core true        # Build services:core with tests"
    echo "  $0 all all true              # Build everything with tests"
}

# Check for help flag
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

# Run main function
main