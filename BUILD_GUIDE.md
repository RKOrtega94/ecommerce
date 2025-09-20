# Build Guide for Ecommerce Backend

This project includes enhanced build scripts for both Linux/macOS and Windows environments that allow you to build the entire backend or specific services.

## Available Scripts

- **`build.sh`** - Linux/macOS build script
- **`build.bat`** - Windows build script

## Usage

### Full Backend Build
```bash
# Linux/macOS
./build.sh

# Windows
.\build.bat
```

### Specific Service Build
```bash
# Linux/macOS
./build.sh security
./build.sh config_server
./build.sh identity

# Windows
.\build.bat security
.\build.bat config_server  
.\build.bat identity
```

### Clean Build
```bash
# Linux/macOS
./build.sh --clean
./build.sh security --clean

# Windows
.\build.bat --clean
.\build.bat security --clean
```

### Build With Tests
```bash
# Linux/macOS
./build.sh --with-tests
./build.sh security --with-tests

# Windows
.\build.bat --with-tests
.\build.bat security --with-tests
```

## Available Services

The build scripts support the following services and components:

### Core Services
- **`config_server`** - Configuration server (`:core:config_server`)
- **`discovery-server`** - Service discovery (`:core:discovery-server`)
- **`gateway`** - API Gateway (`:core:gateway`)
- **`identity`** - Identity/Authentication service (`:core:identity`)

### Business Services
- **`core`** - Core business service (`:services:core`)
- **`security`** - Security service (`:services:security`)

### Libraries
- **`commons`** - Common utilities library (`:libs:commons:lib`)
- **`grpc-common`** - gRPC common library (`:libs:grpc-common:lib`)
- **`xml_signer`** - XML signing library (`:libs:xml_signer:lib`)

## Examples

```bash
# Build the entire backend
./build.sh

# Build only the security service
./build.sh security

# Clean and build the identity service
./build.sh identity --clean

# Build core service with tests
./build.sh core --with-tests

# Windows equivalents
.\build.bat
.\build.bat security
.\build.bat identity --clean
.\build.bat core --with-tests
```

## Help

To see all available options and services:

```bash
# Linux/macOS
./build.sh --help

# Windows
.\build.bat --help
```

## Features

- ✅ **Colored output** (Linux/macOS) for better readability
- ✅ **Service validation** - prevents building non-existent services
- ✅ **Error handling** - stops on build failures
- ✅ **Flexible options** - clean builds, test inclusion/exclusion
- ✅ **Cross-platform** - works on Linux, macOS, and Windows
- ✅ **Dependency refresh** - automatically refreshes Gradle dependencies

## Build Process

The scripts automatically:
1. Navigate to the `backend` directory
2. Validate the requested service (if specified)
3. Execute the appropriate Gradle build command
4. Exclude tests by default (unless `--with-tests` is specified)
5. Refresh dependencies for reliable builds
6. Provide clear success/failure feedback

## Troubleshooting

### Common Issues

1. **"Gradle wrapper not found"** - Ensure you're running the script from the project root directory
2. **"Invalid service name"** - Check the available services with `--help`
3. **Permission denied (Linux/macOS)** - Make the script executable: `chmod +x build.sh`

### Getting More Information

- Use `--help` to see all available options
- Check the Gradle build output for detailed error messages
- Ensure all dependencies are properly configured in the Gradle files