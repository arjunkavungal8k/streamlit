#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  n8n Workflow Manager - Setup${NC}"
echo -e "${BLUE}=====================================${NC}\n"

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creating .env from .env.example${NC}"
    cp .env.example .env
    echo -e "${GREEN}✓ .env created${NC}\n"
fi

# Check Python version
echo -e "${BLUE}Checking Python version...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${YELLOW}Python 3 is required but not found. Exiting.${NC}"
    exit 1
fi
PYTHON_VERSION=$(python3 --version)
echo -e "${GREEN}✓ Found: $PYTHON_VERSION${NC}\n"

# Check if venv exists
if [ ! -d "venv" ]; then
    echo -e "${BLUE}Creating virtual environment...${NC}"
    python3 -m venv venv
    echo -e "${GREEN}✓ Virtual environment created${NC}\n"
fi

# Activate venv
echo -e "${BLUE}Activating virtual environment...${NC}"
source venv/bin/activate
echo -e "${GREEN}✓ Virtual environment activated${NC}\n"

# Install dependencies
echo -e "${BLUE}Installing Python dependencies...${NC}"
pip install -q -r requirements.txt
echo -e "${GREEN}✓ Dependencies installed${NC}\n"

# Check if Docker is available
echo -e "${BLUE}Checking Docker installation...${NC}"
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}✓ Found: $DOCKER_VERSION${NC}\n"
    
    # Ask user if they want to start n8n
    read -p "Would you like to start n8n using Docker? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Starting n8n...${NC}"
        docker-compose up -d n8n
        echo -e "${GREEN}✓ n8n started${NC}"
        echo -e "${YELLOW}n8n will be available at: http://localhost:5678${NC}"
        echo -e "${YELLOW}Waiting for n8n to be ready...${NC}"
        sleep 5
        echo ""
    fi
else
    echo -e "${YELLOW}! Docker not found. n8n must be running separately.${NC}"
    echo -e "${YELLOW}  To run n8n manually: docker run -p 5678:5678 n8nio/n8n${NC}\n"
fi

# Summary
echo -e "${BLUE}=====================================${NC}"
echo -e "${GREEN}Setup completed successfully!${NC}"
echo -e "${BLUE}=====================================${NC}\n"

echo -e "${BLUE}To start the Streamlit app, run:${NC}"
echo -e "${GREEN}  streamlit run app.py${NC}\n"

echo -e "${BLUE}Quick links:${NC}"
echo -e "  • Streamlit app: http://localhost:8501"
echo -e "  • n8n interface: http://localhost:5678\n"

echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Run: ${GREEN}streamlit run app.py${NC}"
echo -e "  2. Configure n8n URL and API key in the sidebar"
echo -e "  3. Create workflows in n8n and execute them from Streamlit\n"
