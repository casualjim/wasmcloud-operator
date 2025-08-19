repo := ghcr.io/casualjim/wasmcloud-operator
version := $(shell git rev-parse --short HEAD)
platforms := linux/amd64,linux/arm64

.PHONY: build-dev-image build-image buildx-image
build-image:
	docker build --build-arg BIN_PATH=wasmcloud-operator --build-arg TARGETARCH=amd64 -t $(repo):$(version) .

buildx-image:
	docker buildx build --platform $(platforms) --build-arg BIN_PATH=wasmcloud-operator -t $(repo):$(version) --load .

build-dev-image:
	docker build -t $(repo):$(version)-dev -f Dockerfile.local .
