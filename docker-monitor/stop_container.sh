#!/bin/bash

# Colors for better output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Stopping Docker Container Monitor ===${NC}"

# Check if the container exists
if docker ps -a | grep -q docker-monitor; then
    # Stop and remove the container
    echo -e "${YELLOW}Stopping and removing container...${NC}"
    docker stop docker-monitor
    docker rm docker-monitor
    echo -e "${GREEN}Container stopped and removed successfully!${NC}"
else
    echo -e "${YELLOW}Container 'docker-monitor' is not running.${NC}"
fi 