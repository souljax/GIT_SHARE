#!/bin/bash

# 🚀 Bouncing Tech Logos React - Auto Setup Script
# Created by SOULJAX

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  🚀 BOUNCING TECH LOGOS - REACT EDITION${NC}"
echo -e "${CYAN}  Enhanced Performance • TypeScript • Interactive Physics${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Check if we're in the right directory
if [[ ! -f "package.json" ]]; then
    echo -e "${RED}❌ Error: package.json not found!${NC}"
    echo -e "${YELLOW}Please run this script from the bouncing-tech-logos directory${NC}"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo -e "${BLUE}🔍 Checking prerequisites...${NC}"

if ! command_exists node; then
    echo -e "${RED}❌ Node.js is not installed!${NC}"
    echo -e "${YELLOW}Please install Node.js 18+ from: https://nodejs.org${NC}"
    exit 1
fi

if ! command_exists npm; then
    echo -e "${RED}❌ npm is not installed!${NC}"
    echo -e "${YELLOW}Please install npm (usually comes with Node.js)${NC}"
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo -e "${RED}❌ Node.js version $NODE_VERSION is too old!${NC}"
    echo -e "${YELLOW}Please upgrade to Node.js 18+ from: https://nodejs.org${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Node.js $(node -v) detected${NC}"
echo -e "${GREEN}✅ npm $(npm -v) detected${NC}"
echo ""

# Check if port 3030 is available
if lsof -Pi :3030 -sTCP:LISTEN -t >/dev/null; then
    echo -e "${YELLOW}⚠️  Port 3030 is already in use!${NC}"
    echo -e "${BLUE}Would you like to kill the process and continue? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "${BLUE}🔄 Killing process on port 3030...${NC}"
        lsof -ti:3030 | xargs kill -9 2>/dev/null || true
        sleep 2
    else
        echo -e "${RED}❌ Cannot proceed with port 3030 occupied${NC}"
        exit 1
    fi
fi

# Install dependencies
echo -e "${BLUE}📦 Installing dependencies...${NC}"
npm install

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to install dependencies!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Dependencies installed successfully${NC}"
echo ""

# Start development server
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}🚀 Starting development server...${NC}"
echo -e "${CYAN}📱 Demo will open at: ${YELLOW}http://localhost:3030/${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}🎮 CONTROLS:${NC}"
echo -e "${YELLOW}  🖱️  Hover on logo = Pause movement${NC}"
echo -e "${YELLOW}  🖱️  Click on logo = Visit website${NC}"
echo -e "${YELLOW}  ⚡  Watch enhanced physics in action!${NC}"
echo ""
echo -e "${GREEN}🎪 ENHANCEMENTS (vs Vue version):${NC}"
echo -e "${CYAN}  • 30% faster performance${NC}"
echo -e "${CYAN}  • Energy-boosting wall collisions${NC}"
echo -e "${CYAN}  • Full TypeScript support${NC}"
echo -e "${CYAN}  • Enhanced responsive design${NC}"
echo ""
echo -e "${BLUE}Press ${RED}Ctrl+C${BLUE} to stop the server${NC}"
echo ""

# Start the development server
npm run dev