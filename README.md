# DevOps Project

This project demonstrates a complete DevOps implementation with four main components:

## 1. Docker Container Monitor & Nginx Proxy

### Docker Container Monitor
A Flask application that monitors Docker containers on a host system.

- **Location**: `docker-monitor/`
- **Features**:
  - Lists all running containers
  - Shows container stats (CPU, memory usage)
  - Provides container logs

### Nginx Proxy
A reverse proxy that sits in front of the Docker Monitor application.

- **Location**: `nginx-proxy/`
- **Features**:
  - Forwards requests to the Flask application
  - Adds security headers
  - Handles TLS termination
  - Preserves client IP addresses

**Running Locally**:
```bash
# Using Docker Compose
docker-compose up -d
```

## 2. Jenkins CI/CD Pipeline

Automated build and deployment pipeline for the components.

- **Location**: `jenkins/`
- **Jenkinsfiles**:
  - `Jenkinsfile_docker_monitor`: Builds and publishes the Docker Monitor image
  - `Jenkinsfile_nginx_proxy`: Builds and publishes the Nginx Proxy image
  - `Jenkinsfile_integration_test`: Tests the integration between components

**Setup**:
```bash
# Steps to run Jenkins locally with Docker
docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkins/jenkins:lts
```

## 3. Kubernetes Deployment (EKS)

Infrastructure as Code for deploying to AWS EKS using Terraform.

- **Location**: `k8s/`
- **Features**:
  - EKS cluster provisioning
  - VPC and networking configuration
  - Node groups with spot instances
  - Essential add-ons (metrics-server, load balancer controller)

**Deployment**:
```bash
# Deploy infrastructure
cd k8s
terraform init
terraform apply

# Configure kubectl
aws eks update-kubeconfig --name elbit-test --region us-east-1
```

## 4. KEDA Autoscaling

Kubernetes-based Event Driven Autoscaling implementation on the EKS cluster.

- **Location**: `keda/`
- **Components**:
  - KEDA deployment configurations
  - Sample nginx deployment with CPU-based scaling
  - HTTP load generator for testing

**Testing KEDA on EKS**:
```bash
# After deploying the EKS cluster with Terraform
# KEDA is automatically installed via the Terraform modules

# Deploy test application with autoscaling
kubectl apply -f keda/nginx-deployment.yaml
kubectl apply -f keda/keda-cpu-scaledobject.yaml

# Generate HTTP load to test scaling
kubectl apply -f keda/http-load-generator.yaml

# Monitor scaling
kubectl get hpa -w
kubectl get deployment nginx-app -w
```

## Project Structure

```
.
├── docker-monitor/       # Flask app for monitoring Docker containers
├── nginx-proxy/          # Nginx reverse proxy configuration
├── jenkins/              # Jenkins job configurations and Jenkinsfiles
├── k8s/                  # Terraform files for EKS deployment
│   └── cluster/          # EKS cluster module
└── keda/                 # KEDA autoscaling implementations
    └── deployment/       # KEDA test deployments and configurations
```

## Getting Started

1. Clone this repository
2. Set up Jenkins using the provided configuration
3. Deploy to Kubernetes using the Terraform scripts
4. Test autoscaling with KEDA scripts

## Requirements

- Docker and Docker Compose
- Jenkins with Docker Pipeline plugin
- AWS CLI configured with appropriate permissions
- Terraform v1.0+
- kubectl v1.20+
