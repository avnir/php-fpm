VERSION ?= php8.2
IMAGE_NAME ?= avnir/php-fpm
BUILDER := mybuilder

# Local build for testing on ARM64 only.
build-local:
	docker build -t $(IMAGE_NAME):$(VERSION) .

# Publish a multi-arch image (ARM64 and AMD64) to Docker Hub.
publish:
	-docker buildx rm $(BUILDER)
	docker buildx create --use --name $(BUILDER) --driver docker-container
	docker buildx build --platform linux/arm64,linux/amd64 \
		-t $(IMAGE_NAME):$(VERSION) \
		-t $(IMAGE_NAME):latest \
		--push .
	docker buildx rm $(BUILDER)

.PHONY: build-local publish