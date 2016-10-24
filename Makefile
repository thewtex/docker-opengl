# Docker organization to pull the images from
ORG = thewtex

# Name of image
IMAGE = opengl

# Docker tag
TAG = centos

build:
	docker build \
	        -t $(ORG)/$(IMAGE):$(TAG) .

example:
	docker build \
		-t $(ORG)/$(IMAGE)-example example/

push:
	docker push $(ORG)/$(IMAGE):$(TAG)

.PHONY: build example push
