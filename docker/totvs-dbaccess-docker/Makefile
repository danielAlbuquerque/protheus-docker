USER = endersonmaia
NAME = $(USER)/totvs-dbaccess
VERSION = 18.2.1.2

.PHONY: all
all: build

.PHONY: build
build:
	docker image build -t $(NAME):$(VERSION) --rm .

.PHONY: tag_latest
tag_latest:
	docker image tag $(NAME):$(VERSION) $(NAME):latest

.PHONY: release
	docker image push $(NAME):$(VERSION)
	$(NAME):latest