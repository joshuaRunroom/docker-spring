UID = $(shell id -u)
GID = $(shell id -g)
CERTS_DIR = .certs
MKCERT = mkcert

build: halt
	docker compose build --build-arg UID=$(UID) --build-arg GID=$(GID)
.PHONY: build

up: compose
.PHONY: up

halt:
	docker compose stop
.PHONY: halt

ssh:
	docker compose exec app /bin/bash

build-jar:
	docker compose exec app /bin/bash ./mvnw clean install

compose: $(CERTS_DIR)
	docker compose up
.PHONY: compose

$(CERTS_DIR):
	$(MAKE) certs

certs:
	mkdir -p $(CERTS_DIR)
	$(MKCERT) -install
	$(MKCERT) -cert-file $(CERTS_DIR)/certificate.pem -key-file $(CERTS_DIR)/certificate-key.pem localhost
.PHONY: certs