#!/bin/bash

# CS2 Server Management Script
# Usage: ./manage-server.sh [start|stop|restart|status|logs|update]

set -e

COMPOSE_FILE="docker-compose.yml"
CONTAINER_NAME="cs2-server"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if docker-compose.yml exists
if [ ! -f "$COMPOSE_FILE" ]; then
    echo -e "${RED}Error: $COMPOSE_FILE not found!${NC}"
    exit 1
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}Warning: .env file not found!${NC}"
    echo -e "${YELLOW}Please copy .env.example to .env and configure it.${NC}"
    exit 1
fi

case "$1" in
    start)
        echo -e "${GREEN}Starting CS2 server...${NC}"
        docker-compose up -d
        echo -e "${GREEN}Server started!${NC}"
        echo -e "${YELLOW}Note: First launch may take 5-15 minutes to download CS2.${NC}"
        echo -e "Use './manage-server.sh logs' to monitor progress."
        ;;
    
    stop)
        echo -e "${YELLOW}Stopping CS2 server...${NC}"
        docker-compose down
        echo -e "${GREEN}Server stopped!${NC}"
        ;;
    
    restart)
        echo -e "${YELLOW}Restarting CS2 server...${NC}"
        docker-compose restart
        echo -e "${GREEN}Server restarted!${NC}"
        ;;
    
    status)
        echo -e "${GREEN}Checking CS2 server status...${NC}"
        docker-compose ps
        echo ""
        if docker ps | grep -q "$CONTAINER_NAME"; then
            echo -e "${GREEN}✓ Server is running${NC}"
        else
            echo -e "${RED}✗ Server is not running${NC}"
        fi
        ;;
    
    logs)
        echo -e "${GREEN}Showing CS2 server logs (Ctrl+C to exit)...${NC}"
        docker-compose logs -f cs2
        ;;
    
    update)
        echo -e "${YELLOW}Updating CS2 server...${NC}"
        docker-compose pull
        docker-compose down
        docker-compose up -d
        echo -e "${GREEN}Server updated and restarted!${NC}"
        ;;
    
    shell)
        echo -e "${GREEN}Opening shell in CS2 container...${NC}"
        docker-compose exec cs2 /bin/bash
        ;;
    
    *)
        echo "CS2 Server Management Script"
        echo ""
        echo "Usage: $0 {start|stop|restart|status|logs|update|shell}"
        echo ""
        echo "Commands:"
        echo "  start   - Start the CS2 server"
        echo "  stop    - Stop the CS2 server"
        echo "  restart - Restart the CS2 server"
        echo "  status  - Check server status"
        echo "  logs    - Show server logs (live)"
        echo "  update  - Update and restart server"
        echo "  shell   - Open a shell in the container"
        echo ""
        exit 1
        ;;
esac

exit 0
