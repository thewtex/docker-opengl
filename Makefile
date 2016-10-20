# Docker organization to pull the images from
ORG = thewtex

# Name of image
IMAGE = opengl

build:
	docker build \
		-t $(ORG)/$(IMAGE) .

push:
	docker push $(ORG)/$(IMAGE)
