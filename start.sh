#!/bin/bash

# Stop any existing containers
docker-compose down

# Create the network if it doesn't exist
docker network create open-webui-net 2>/dev/null || true

# Start the stack
docker-compose up -d

# Wait for the container to be ready
echo "Waiting for Open WebUI to start..."
sleep 5

# Check if the container is running
if docker ps | grep -q open-webui; then
    echo "Open WebUI is running!"
    echo "Access the UI at http://localhost:8080"
else
    echo "Error: Open WebUI failed to start"
    docker-compose logs
fi
