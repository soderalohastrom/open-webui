# Open WebUI Docker Setup Reference

## Current Configuration
- Custom port: 8888 (instead of default 3000)
- Ollama: Running as a Brew-managed service
- Model storage: External storage on Paumalu drive

## Installation and Setup

### Base Docker Command
```bash
docker run -d \
  -p 8888:8080 \
  -v open-webui:/app/backend/data \
  -v /Volumes/Paumalu/ollama/models:/root/.ollama/models \
  -e OLLAMA_BASE_URL=http://host.docker.internal:11434 \
  --add-host=host.docker.internal:host-gateway \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main
```

### Important Configuration Notes
1. Volume Mounts:
   - `-v open-webui:/app/backend/data`: Persists WebUI data
   - `-v /Volumes/Paumalu/ollama/models:/root/.ollama/models`: External model storage

2. Network Configuration:
   - Port mapping: `-p 8888:8080`
   - Host configuration: `--add-host=host.docker.internal:host-gateway`
   - Ollama URL: `-e OLLAMA_BASE_URL=http://host.docker.internal:11434`

## Updating the Container

1. Pull the latest image:
   ```bash
   docker pull ghcr.io/open-webui/open-webui:main
   ```

2. Remove the existing container:
   ```bash
   docker stop open-webui
   docker rm open-webui
   ```

3. Run the container again using the command from the Installation section

## Troubleshooting Network Issues

If you encounter WebSocket connection errors ("Network Problem"), try these steps:

1. First Try: Use host network mode
   ```bash
   docker run -d \
     --network=host \
     -v open-webui:/app/backend/data \
     -v /Volumes/Paumalu/ollama/models:/root/.ollama/models \
     -e OLLAMA_BASE_URL=http://127.0.0.1:11434 \
     --name open-webui \
     --restart always \
     ghcr.io/open-webui/open-webui:main
   ```

2. If the issue persists:
   - Verify Ollama is running: `brew services list`
   - Check Ollama API accessibility: `curl http://localhost:11434/api/tags`
   - Inspect container logs: `docker logs open-webui`
   - Verify no port conflicts: `lsof -i :8888`

3. Advanced Network Debugging:
   - Try direct localhost URL: Change OLLAMA_BASE_URL to `http://localhost:11434`
   - Check Docker network isolation: `docker network inspect bridge`
   - Verify host.docker.internal resolution: `docker exec open-webui ping host.docker.internal`