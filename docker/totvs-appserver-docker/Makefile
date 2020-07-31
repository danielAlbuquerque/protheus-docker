USER = endersonmaia
NAME = $(USER)/totvs-appserver
VERSION = 17.3.0.13

.PHONY: all
all: build

.PHONY: build
build:
	docker image build -t $(NAME):$(VERSION) --rm .

.PHONY: tag_latest
tag_latest:
	docker image tag $(NAME):$(VERSION) $(NAME):latest

.PHONY: release
release:
	docker image push $(NAME):$(VERSION)
	docker image push $(NAME):latest