#!/bin/bash

# Build script for love2d-ball with SDL3 from git

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎮 Building love2d-ball with SDL3 from git repository${NC}"

# Create build directory
BUILD_DIR="build"
if [ -d "$BUILD_DIR" ]; then
    echo -e "${YELLOW}⚠️  Build directory exists, cleaning...${NC}"
    rm -rf "$BUILD_DIR"
fi

echo -e "${BLUE}📁 Creating build directory...${NC}"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configure with CMake
echo -e "${BLUE}⚙️  Configuring with CMake...${NC}"
cmake .. -DCMAKE_BUILD_TYPE=Release

# Build the project
echo -e "${BLUE}🔨 Building project...${NC}"
cmake --build . --config Release

# Check if build was successful
if [ -f "bin/ball_game" ] || [ -f "bin/ball_game.exe" ]; then
    echo -e "${GREEN}✅ Build successful!${NC}"
    echo -e "${GREEN}📦 Executable location: build/bin/ball_game${NC}"
    echo -e "${GREEN}🎯 Asset location: build/bin/ball-shiny.bmp${NC}"
    echo ""
    echo -e "${YELLOW}🚀 To run the game:${NC}"
    echo -e "${YELLOW}   cd build/bin && ./ball_game${NC}"
else
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi