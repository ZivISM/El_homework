#!/bin/bash

# Colors for better output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Set your Docker Hub username here
DOCKER_HUB_USERNAME="zivism"
IMAGE_NAME="nginx-proxy"
TAG="latest"

echo -e "${YELLOW}=== Building Nginx Proxy Image ===${NC}"

# Build the Docker image
echo -e "${YELLOW}Building Docker image...${NC}"
docker build -t ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${TAG} .

# Check if build was successful
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Failed to build Docker image. Exiting.${NC}"
    exit 1
fi

echo -e "${GREEN}Image built successfully!${NC}"

# Push to Docker Hub
echo -e "${YELLOW}Pushing image to Docker Hub...${NC}"
echo -e "${YELLOW}Please enter your Docker Hub password:${NC}"
docker login -u ${DOCKER_HUB_USERNAME}
docker push ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${TAG}

# Check if push was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Image pushed to Docker Hub successfully!${NC}"
else
    echo -e "${YELLOW}Failed to push image to Docker Hub.${NC}"
    exit 1
fi 