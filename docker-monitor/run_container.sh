#!/bin/bash

# Colors for better output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Docker Container Monitor Script ===${NC}"

# Stop and remove existing container if it exists
echo -e "${YELLOW}Stopping and removing existing container (if any)...${NC}"
docker rm -f docker-monitor 2>/dev/null || true

# Build the Docker image
echo -e "${YELLOW}Building Docker image...${NC}"
docker build -t docker-monitor .

# Check if build was successful
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Failed to build Docker image. Exiting.${NC}"
    exit 1
fi

# Run the Docker container
echo -e "${YELLOW}Starting container...${NC}"
docker run -d \
    -p 5001:5000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name docker-monitor \
    docker-monitor

# Check if container is running
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Container started successfully!${NC}"
    echo -e "${GREEN}You can access the application at: http://localhost:5001${NC}"
    echo -e "${YELLOW}To view logs:${NC} docker logs docker-monitor"
    echo -e "${YELLOW}To stop container:${NC} docker stop docker-monitor"
else
    echo -e "${YELLOW}Failed to start the container.${NC}"
    exit 1
fi 