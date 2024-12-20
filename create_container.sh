#!/bin/bash

# Default ports and names
CODE_SERVER_PORT=8023
JUPYTER_PORT=8024
MISC_PORT=8025
CONTAINER_NAME="ml-ide"
IMAGE_NAME="ghcr.io/adarshchbs/remote-ml-ide:latest"

# Check if container already exists
if docker ps -a | grep -q ${CONTAINER_NAME}; then
    echo "Removing existing container..."
    if ! docker rm -f ${CONTAINER_NAME}; then
        echo "Error: Failed to remove existing container"
        exit 1
    fi
fi

# Remove existing image if it exists
if docker images | grep -q ${IMAGE_NAME}; then
    echo "Removing existing image..."
    if ! docker rmi -f ${IMAGE_NAME}; then
        echo "Error: Failed to remove existing image"
        exit 1
    fi
fi

# Find the downloaded tar.gz file
RELEASE_FILE=$(ls docker-image.tar.gz 2>/dev/null)
if [ -z "$RELEASE_FILE" ]; then
    echo "Note: No local docker-image.tar.gz found, will pull from registry"
fi

# Load the docker image if local file exists
if [ -n "$RELEASE_FILE" ]; then
    echo "Loading docker image from local file..."
    if ! docker load -i "$RELEASE_FILE"; then
        echo "Error: Failed to load docker image"
        exit 1
    fi
    
    # Delete the tar.gz file
    echo "Removing downloaded tar.gz file..."
    if ! rm "$RELEASE_FILE"; then
        echo "Warning: Failed to remove tar.gz file"
    fi
fi

# Run the container with port mappings
echo "Starting container..."
if docker run -d \
    -p 0.0.0.0:${CODE_SERVER_PORT}:8023 \
    -p 0.0.0.0:${JUPYTER_PORT}:8024 \
    -p 0.0.0.0:${MISC_PORT}:${MISC_PORT} \
    -v "$(pwd)/workspace:/root/workspace" \
    -e CODE_SERVER_PORT=${CODE_SERVER_PORT} \
    -e JUPYTER_PORT=${JUPYTER_PORT} \
    -e MISC_PORT=${MISC_PORT} \
    --name ${CONTAINER_NAME} \
    --restart=always \
    ${IMAGE_NAME}; then
    
    echo "✅ Container started successfully!"
    echo "Access the services at:"
    echo "💻 VS Code Server: http://0.0.0.0:${CODE_SERVER_PORT}"
    echo "📓 Jupyter Lab: http://0.0.0.0:${JUPYTER_PORT}"
    echo "🔌 Misc Port: http://0.0.0.0:${MISC_PORT}"
    
    # Wait for services to be ready
    echo "Waiting for services to start..."
    sleep 5
    
    # Check if services are responding
    if curl -s -f http://0.0.0.0:${CODE_SERVER_PORT} > /dev/null; then
        echo "✅ VS Code Server is running"
    else
        echo "⚠️  VS Code Server may not be running properly"
    fi
    
    if curl -s -f http://0.0.0.0:${JUPYTER_PORT} > /dev/null; then
        echo "✅ Jupyter Lab is running"
    else
        echo "⚠️  Jupyter Lab may not be running properly"
    fi
else
    echo "❌ Error: Failed to start container"
    exit 1
fi
