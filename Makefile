# Docker organization to pull the images from
ORG = thewtex

# Name of image
IMAGE = opengl

# TAG of the image
TAG = centos-v1.0.0

build:
	docker build \
		-t $(ORG)/$(IMAGE):$(TAG) \
		.

example:
	docker build \
		-t $(ORG)/$(IMAGE)-example:$(TAG) example/

push:
	docker push $(ORG)/$(IMAGE):$(TAG)

.PHONY: build example push
