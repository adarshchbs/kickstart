# Remote ML IDE Docker Image

A Docker-based development environment that combines:
- VS Code Server
- VS Code Extensions
  - python
  - based-pyright (python language server: varient of pylance)
  - ruff (formatter)
  - git-graph
  - path-intellisense
  - vscode-pull-request-github
  - and many more
- Jupyter lab
- Python development tools via `uv`
- Homebrew packages
  - 🧠 `mcfly`: Smart command history search/completion for shell
  - 🔍 `fzf`: Fuzzy file finder & command-line filter
  - 🐙 `gh`: GitHub's official CLI tool
  - ⚡ `zoxide`: Smarter `cd` command with directory jump
  - 🚀 `starship`: Fast, minimal cross-shell prompt
  - 📚 `tldr`: Simplified community-driven man pages
  - 🔎 `fd`: User-friendly alternative to `find`
  - 📦 `uv`: Fast Python package installer & resolver
- Common development utilities
- Process management via PM2: PM2 keeps your application running continuously, automatically restarts it if it crashes, and manages logs - making it ideal for running services like VS Code Server and Jupyter Lab reliably.

## Image Details

### Components
- Base Image: `homebrew/brew:latest`
- Code Server (Browser-based VS Code)
- Package Managers:
  - apt (system packages)
  - Homebrew (development tools)
  - uv (Python packages)
- Process Management: PM2
- Customizable through `packages.yaml`:
  - apt packages
  - Homebrew packages
  - VS Code extensions
  - Python tools via uv

## Getting the Image

The image is distributed as a compressed tar file through GitHub releases:

1. Go to the releases page
2. Download the `docker-image.tar.gz` file from the desired release
3. Load the image:
```bash
docker load -i docker-image.tar.gz
```

## Usage

### Using the Container Creation Script

The easiest way to get started is using the provided `create_container.sh` script:

1. Download the script:
```bash
wget https://raw.githubusercontent.com/adarshchbs/remote-ml-ide/main/create_container.sh
chmod +x create_container.sh
```

2. Run the script:
```bash
./create_container.sh
```

Setup ports number in the script before running. It requires three ports. The default are set to be 8023-8025.

The script will:
- Clean up any existing container/image with the same name
- Load the image from a local `docker-image.tar.gz` if available, otherwise pull from registry
- Start the container with the following port mappings:
  - VS Code Server: 8023
  - Jupyter Lab: 8024
  - Misc Port: 8025
- Mount a `workspace` directory from your current location
- Display access URLs and perform health checks

### Manual Docker Run Command

If you prefer to run the container manually:

```bash
docker run -d \
  --name ml-ide \
  -p 0.0.0.0:8023:8023 \
  -p 0.0.0.0:8024:8024 \
  -p 0.0.0.0:8025:8025 \
  -v "$(pwd)/workspace:/root/workspace" \
  ghcr.io/adarshchbs/remote-ml-ide:latest
```

After starting the container:
1. Access VS Code Server at `http://0.0.0.0:8023`
2. Access Jupyter Lab at `http://0.0.0.0:8024`
3. The environment comes pre-configured with common development tools and extensions

### Available Services

| Service | Port | URL |
|---------|------|-----|
| VS Code Server | 8023 | http://0.0.0.0:8023 |
| Jupyter Lab | 8024 | http://0.0.0.0:8024 |
| Misc Services | 8025 | http://0.0.0.0:8025 |

## Build Process

The Docker image is automatically built and released through GitHub Actions when a new version tag is pushed. The build process:

1. Triggers on push of version tags (v*.*.*)
2. Builds the Docker image using BuildKit
3. Saves the image as a compressed tar file
4. Creates a GitHub release with:
   - Changelog from git commits
   - The compressed Docker image
   - Installation instructions

## Customization

The image uses `packages.yaml` to configure various components. You can modify this file before building to customize:

- APT packages
- Homebrew packages
- VS Code extensions
- Python tools installed via uv

## Version History

All versions are available as releases on the GitHub repository. Each release includes:
- A changelog detailing the changes since the last release
- The Docker image as a compressed tar file
- Installation instructions

To check available versions, visit the [releases page](https://github.com/adarshchbs/remote-ml-ide/releases).

## Contributing

To contribute:

1. Fork the repository
2. Make your changes
3. Create a pull request
4. Once merged, a new version tag can be created to trigger the build and release process

## Support

For issues and feature requests, please use the GitHub issues page.

## Security Note

The container exposes services on 0.0.0.0, which makes them accessible from any network interface. In production environments:
- Use appropriate firewall rules
- Consider using reverse proxy with SSL/TLS
- Implement authentication if needed
- Use private networks when possible
