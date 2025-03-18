# Docker Container Monitor

A Flask web application that monitors Docker containers running on the host system. The application itself runs in a Docker container and communicates with the host's Docker daemon to list all running containers.

## Features

- Lists all running Docker containers on the host
- Shows container ID, name, image, and status
- Runs in a Docker container itself
- Modern, responsive web interface

## How It Works

The application uses the Docker CLI from inside the container to interact with the host's Docker daemon via the mounted Docker socket. This approach (Docker-out-of-Docker or DooD) allows the container to communicate with the host's Docker daemon without running a separate Docker daemon inside the container.

## Project Structure

```
docker-monitor/
├── dockerfile         # Docker image definition
├── requirements.txt   # Python dependencies
├── run_container.sh   # Script to build and run the container
├── stop_container.sh  # Script to stop and remove the container
└── src/
    ├── app.py         # Flask application
    └── templates/     # HTML templates
        └── index.html # Main page template
```

## Quick Start

The easiest way to run the application is using the provided scripts:

```bash
# To build and start the container
./run_container.sh

# To stop and remove the container
./stop_container.sh
```

Then open your browser and navigate to http://localhost:5001.

## Manual Setup

If you prefer to run the commands manually:

1. Build the Docker image:
   ```bash
   docker build -t docker-monitor .
   ```

2. Run the container:
   ```bash
   docker run -d -p 5001:5000 -v /var/run/docker.sock:/var/run/docker.sock --name docker-monitor docker-monitor
   ```

3. Access the application at http://localhost:5001

## Technical Details

### Flask Application (app.py)

The application uses Python's `subprocess` module to execute Docker CLI commands directly:

```python
result = subprocess.run(
    ['docker', 'ps', '--format', '{{json .}}'],
    capture_output=True,
    text=True
)
```

It then parses the JSON output and displays it using Flask templates.

### Dockerfile

The Dockerfile:
1. Uses Python 3.9 slim as the base image
2. Installs curl to download the Docker CLI binary
3. Downloads the Docker CLI binary directly from Docker's website
4. Installs Python dependencies
5. Copies the application code
6. Exposes port 5000
7. Runs the Flask application

### Container Communication

The container communicates with the host's Docker daemon through the Docker socket, which is mounted as a volume (`-v /var/run/docker.sock:/var/run/docker.sock`).
