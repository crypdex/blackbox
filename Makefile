
# This .env will overwrite values from the environment
include ./.env
# LEGACY ENV
include ./.blackbox.env
export

# This is called if .env does not exist
.env:
	@echo ".env file does not exist"
.blackbox.env:
	@echo ".blackbox.env file does not exist"

# If DATA_DIR is already in the environment, keep it
# otherwise, default to ~/data
DATA_DIR?=/root/data

CHAINS?=
chains-compose-files := $(foreach service,$(CHAINS),-f ./services/$(service)/docker-compose.yml)

docker-compose = DATA_DIR=$(DATA_DIR) docker-compose -p blackbox -f ./docker-compose.yml -f ./docker-compose-deps.yml $(chains-compose-files)

# For development: Load only the supporting containers, not the API container
docker-compose-dev = DATA_DIR=$(DATA_DIR) docker-compose -p blackbox -f ./docker-compose-deps.yml $(chains-compose-files)

build:
	./scripts/build-docker.sh

configuration: setup
	$(docker-compose) config

devup:
	$(docker-compose-dev) pull && \
	$(docker-compose-dev) up -t 60

devdown:
	$(docker-compose-dev) down --remove-orphans

pull: setup
	$(docker-compose) pull

start: pull
	$(docker-compose) up -t 60

update: pull
	$(docker-compose) up -d --no-deps -t 60

chains:
	DATA_DIR=$(DATA_DIR) docker-compose -p blackbox $(chains-compose-files) up -t 60

stop:
	$(docker-compose) down --remove-orphans

install-services: install-blackbox-service install-updater
	systemctl daemon-reload

uninstall-services: uninstall-blackbox-service uninstall-updater
	systemctl daemon-reload

# Installs the systemd service, enables it and starts it
install-blackbox-service:
	cp services/blackbox.service /etc/systemd/system/
	systemctl enable /etc/systemd/system/blackbox.service
	systemctl start blackbox.service

# Uninstalls the service
uninstall-blackbox-service:
	systemctl stop blackbox.service
	systemctl disable blackbox.service
	rm /etc/systemd/system/blackbox.service

# Installs the systemd service, enables it and starts it
install-updater:
	cp services/updater/updater.service /etc/systemd/system/
	cp services/updater/updater.timer /etc/systemd/system/
	systemctl enable /etc/systemd/system/updater.timer
	systemctl start updater.timer

uninstall-updater:
	systemctl stop updater.timer
	systemctl disable updater.timer
	rm /etc/systemd/system/updater.timer
	rm /etc/systemd/system/updater.service

# PIVX (and maybe other CHAINs) require a swap file to function properly.
# * This must be run as root and is NOT idempotent
# * Use $ swapon --show before running this command!
# * See: https://linuxize.com/post/how-to-add-swap-space-on-ubuntu-18-04/
install-swapfile:
	fallocate -l 2G /swapfile && \
	chmod 600 /swapfile && \
	mkswap /swapfile && \
	swapon /swapfile && \
	echo "/swapfile swap swap defaults 0 0" >> /etc/fstab && \
	swapon --show

install-docker:
	apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	apt-key fingerprint 0EBFCD88
	add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# THIS ONLY WORKS ON x86 CHIPSETS
install-docker-compose:
	curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	docker-compose --version

setup: chain-config

chain-config:
	bash ./scripts/generate-chain-conf.sh

# DATA_DIR=/path/to/pivxdata
check-chains:
ifndef CHAINS
	$(error 'CHAINS' is undefined)
else
	@echo "configured for ${CHAINS}"
endif
