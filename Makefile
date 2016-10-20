# Docker organization to pull the images from
ORG = thewtex

# Name of image
IMAGE = opengl

build:
	docker build \
		-t $(ORG)/$(IMAGE) .

example:
	docker build \
		-t $(ORG)/$(IMAGE)-example example/

push:
	docker push $(ORG)/$(IMAGE)

.PHONY: build example push
