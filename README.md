# Docker Container Monitoring System

A complete DevOps solution for monitoring Docker containers with a Flask web application, an Nginx reverse proxy, and a fully automated CI/CD pipeline using Jenkins.

## Overview

This project demonstrates a complete containerized application stack with:

1. **Docker Monitor**: A Flask application that displays running Docker containers
2. **Nginx Proxy**: A reverse proxy that adds headers and forwards requests
3. **CI/CD Pipeline**: Jenkins jobs for building, testing, and deployment
4. **Docker Compose**: For local development and testing

## Architecture

```
                  +----------------+
                  |                |
Users ----------> |  Nginx Proxy   | -------+
                  |  (Port 80)     |        |
                  +----------------+        |
                                           |
                                           v
                  +----------------+    +----------------+
                  |                |    |                |
                  | Docker Socket  | <- | Docker Monitor |
                  | /var/run/docker.sock|  (Port 5000)   |
                  +----------------+    +----------------+
```

## Components

### 1. Docker Monitor Application

The core Flask application that monitors Docker containers running on the host system. The application communicates with the host's Docker daemon via the mounted Docker socket.

**Key Features:**
- Lists all running Docker containers
- Shows container ID, name, image, and status
- Displays incoming HTTP headers
- Runs in a Docker container using Docker-out-of-Docker (DooD) approach

**Directory Structure:**
```
docker-monitor/
├── Dockerfile         # Docker image definition
├── requirements.txt   # Python dependencies
└── src/
    ├── app.py         # Flask application
    └── templates/     # HTML templates
        └── index.html # Main page template
```

### 2. Nginx Proxy

A reverse proxy that sits in front of the Docker Monitor application, adding custom headers and providing an additional layer of abstraction.

**Key Features:**
- Forwards requests to the Docker Monitor application
- Adds the X-Source-IP header with the client's IP address
- Provides a single entry point for the application

**Directory Structure:**
```
nginx-proxy/
├── Dockerfile         # Docker image definition
├── nginx.conf         # Nginx configuration
└── README.md          # Documentation
```

### 3. Jenkins CI/CD Pipeline

Automated build, test, and deployment pipeline using Jenkins.

**Key Features:**
- Separate Jenkins jobs for building Docker Monitor and Nginx Proxy images
- Integration test job that verifies the entire system works correctly
- Automated Docker image builds and pushes to Docker Hub

**Directory Structure:**
```
jenkins/
├── jobs/
│   ├── Jenkinsfile_docker_monitor    # Pipeline for Docker Monitor
│   ├── Jenkinsfile_nginx_proxy       # Pipeline for Nginx Proxy
│   └── Jenkinsfile_integration_test  # Pipeline for integration tests
└── jenkins_jobs.groovy               # Job DSL script to set up Jenkins jobs
```

## Quick Start

### Local Development with Docker Compose

The easiest way to run the application locally is using Docker Compose:

```bash
# Build and start the containers
docker-compose up -d

# Access the application
# Navigate to http://localhost:80 in your browser

# Stop and remove the containers
docker-compose down
```

### Manual Container Setup

If you prefer to run the containers manually:

1. **Build and run the Docker Monitor:**
   ```bash
   cd docker-monitor
   docker build -t docker-monitor .
   docker run -d -p 5000:5000 -v /var/run/docker.sock:/var/run/docker.sock --name docker-monitor docker-monitor
   ```

2. **Build and run the Nginx Proxy:**
   ```bash
   cd nginx-proxy
   docker build -t nginx-proxy .
   docker run -d -p 80:80 --link docker-monitor:docker-monitor --name nginx-proxy nginx-proxy
   ```

3. **Access the application at http://localhost:80**

## CI/CD Pipeline Setup

### Prerequisites

- Jenkins server with Docker installed
- Docker Hub account
- GitHub account

### Setting Up Jenkins

1. **Install Required Plugins:**
   - Docker Pipeline
   - Docker
   - Job DSL
   - Pipeline

2. **Configure Docker Hub Credentials:**
   - Add Docker Hub credentials with ID 'docker-hub-credentials'

3. **Set Up Jenkins Jobs:**
   - Create a seed job that uses the jenkins_jobs.groovy script to generate all pipeline jobs
   - Run the seed job to create all pipeline jobs

### Pipeline Jobs

1. **Docker Monitor Build:**
   - Builds the Docker Monitor image
   - Pushes it to Docker Hub

2. **Nginx Proxy Build:**
   - Builds the Nginx Proxy image
   - Pushes it to Docker Hub

3. **Integration Test:**
   - Creates a test environment with both containers
   - Verifies the integration between components
   - Checks for proper header forwarding

## Deployment

The Docker images can be deployed to any environment that has Docker installed:

```bash
# Pull the images
docker pull zivism/docker-monitor:latest
docker pull zivism/nginx-proxy:latest

# Create a network
docker network create app-network

# Run the Docker Monitor
docker run -d --name docker-monitor \
  --network app-network \
  -v /var/run/docker.sock:/var/run/docker.sock \
  zivism/docker-monitor:latest

# Run the Nginx Proxy
docker run -d --name nginx-proxy \
  --network app-network \
  -p 80:80 \
  zivism/nginx-proxy:latest
```
