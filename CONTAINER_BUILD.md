# Container Build Instructions

This document describes how to build and publish the wasmcloud-operator container.

## Building the Container

### Prerequisites
- Docker installed and running
- Rust toolchain with musl target: `rustup target add x86_64-unknown-linux-musl`
- musl-tools installed: `sudo apt install musl-tools` (on Ubuntu/Debian)

### Building Steps

1. **Build the static binary:**
   ```bash
   cargo build --release --target x86_64-unknown-linux-musl
   ```

2. **Copy binary for Docker build:**
   ```bash
   cp target/x86_64-unknown-linux-musl/release/wasmcloud-operator wasmcloud-operator-amd64
   ```

3. **Build the container:**
   ```bash
   docker build --build-arg BIN_PATH=wasmcloud-operator --build-arg TARGETARCH=amd64 -t ghcr.io/casualjim/wasmcloud-operator:latest .
   ```

4. **Clean up temporary files:**
   ```bash
   rm wasmcloud-operator-amd64
   ```

### Using the Makefile

Alternatively, you can use the provided Makefile after building the binary:

```bash
# Build the static binary first
cargo build --release --target x86_64-unknown-linux-musl

# Copy binary to expected location
cp target/x86_64-unknown-linux-musl/release/wasmcloud-operator wasmcloud-operator-amd64

# Build using make
make build-image

# Clean up
rm wasmcloud-operator-amd64
```

## Publishing the Container

To publish the container to GitHub Container Registry:

1. **Login to GitHub Container Registry:**
   ```bash
   echo $GITHUB_TOKEN | docker login ghcr.io -u <username> --password-stdin
   ```

2. **Push the image:**
   ```bash
   docker push ghcr.io/casualjim/wasmcloud-operator:latest
   docker push ghcr.io/casualjim/wasmcloud-operator:<git-commit-hash>
   ```

## Testing the Container

Test the built container locally:

```bash
docker run --rm ghcr.io/casualjim/wasmcloud-operator:latest --help
```

Note: The container will show a Kubernetes configuration error when run outside of a cluster, which is expected behavior.

## Container Details

- **Base Image**: `gcr.io/distroless/cc-debian12` (distroless container for security and minimal size)
- **Binary**: Statically linked using musl to ensure compatibility with distroless base
- **Size**: ~48MB
- **Architecture**: linux/amd64
- **Entrypoint**: `/usr/local/bin/wasmcloud-operator`

## GitHub Actions

The repository includes a GitHub Actions workflow that automatically builds multi-platform containers (amd64 and arm64) when tags are pushed. The workflow uses the same build process but with additional cross-compilation setup.