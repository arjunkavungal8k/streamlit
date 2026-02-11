#!/bin/bash

# Colors for output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}  n8n Workflow Manager - Streamlit${NC}"
echo -e "${BLUE}=====================================${NC}\n"

# Check if venv exists
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}Virtual environment not found. Run setup.sh first.${NC}"
    exit 1
fi

# Activate venv
source venv/bin/activate

# Check if n8n is running
echo -e "${BLUE}Checking n8n connection...${NC}"
N8N_URL="${N8N_URL:-http://localhost:5678}"

if timeout 2 curl -s "$N8N_URL/health" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ n8n is running at $N8N_URL${NC}\n"
else
    echo -e "${YELLOW}! n8n doesn't appear to be running at $N8N_URL${NC}"
    echo -e "${YELLOW}  Start n8n with: docker-compose up -d n8n${NC}\n"
fi

# Start Streamlit
echo -e "${BLUE}Starting Streamlit app...${NC}"
echo -e "${GREEN}✓ Streamlit will open at http://localhost:8501${NC}\n"
streamlit run app.py --logger.level=info
