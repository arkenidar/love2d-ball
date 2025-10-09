# CMake Build Instructions

## Quick Start

### Using the build script (recommended):
```bash
./build.sh
cd build/bin
./ball_game
```

### Manual CMake build:
```bash
# Create build directory
mkdir build && cd build

# Configure (downloads SDL3 from git automatically)
cmake .. -DCMAKE_BUILD_TYPE=Release

# Build
cmake --build . --config Release

# Run
cd bin && ./ball_game
```

## Requirements

- **CMake 3.16+**
- **C99 compatible compiler** (GCC, Clang, MSVC)
- **Git** (for fetching SDL3)
- **Internet connection** (first build only)

## Features

- **Automatic SDL3 fetching**: Downloads latest SDL3 from GitHub
- **Cross-platform**: Works on Linux, Windows, macOS
- **Asset copying**: Automatically copies ball-shiny.bmp to build directory
- **Modern build system**: Uses CMake best practices

## Build Options

```bash
# Debug build
cmake .. -DCMAKE_BUILD_TYPE=Debug

# Release build (default)
cmake .. -DCMAKE_BUILD_TYPE=Release

# Specify compiler
cmake .. -DCMAKE_C_COMPILER=clang

# Verbose build
cmake --build . --verbose
```

## Troubleshooting

### If SDL3 download fails:
- Check internet connection
- Clear CMake cache: `rm -rf build` and try again
- Check firewall/proxy settings

### If build fails:
- Ensure CMake 3.16+ is installed: `cmake --version`
- Check compiler is available: `gcc --version` or `clang --version`
- Try debug build for more information

### Runtime issues:
- Ensure `ball-shiny.bmp` is in the same directory as executable
- Check SDL3 shared library is found (should be automatic)

## Advanced Usage

### Install system-wide:
```bash
cd build
sudo cmake --install .
```

### Custom install prefix:
```bash
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/ball_game
cmake --build . --target install
```

### Static linking (if preferred):
Edit CMakeLists.txt and change:
```cmake
set(SDL_SHARED OFF CACHE BOOL "Build SDL3 shared library")
set(SDL_STATIC ON CACHE BOOL "Build SDL3 static library")
```