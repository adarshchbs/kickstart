# Remote ML IDE Docker Image

A Docker-based development environment that combines:
- VS Code Server
- Python development tools via `uv`
- Homebrew packages
- Common development utilities
- Process management via PM2

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

### Basic Run Command

```bash
docker run -d \
  --name ml-ide \
  -p 8023:8023 \
  -p 8024:8024 \
  ghcr.io/adarshchbs/remote-ml-ide:latest
```

After starting the container:
1. Access VS Code Server through your browser at `http://localhost:8023`
2. The environment comes pre-configured with common development tools and extensions

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

To check available versions, visit the [releases page](https://github.com/adarshchbs/kickstart/releases).

## Contributing

To contribute:

1. Fork the repository
2. Make your changes
3. Create a pull request
4. Once merged, a new version tag can be created to trigger the build and release process

## Support

For issues and feature requests, please use the GitHub issues page.
