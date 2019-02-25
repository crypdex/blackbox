DATA_DIR?=~/data
SERVICES?=ouroboros smtp-relay pivx
compose-files := $(foreach service,$(SERVICES),-f ./services/$(service)/docker-compose.yml)

build:
	./build-docker.sh

docker-compose = DATA_DIR=$(DATA_DIR) docker-compose -p blackbox -f ./docker-compose.yml $(compose-files)

configuration:
	$(docker-compose) config

pull:
	$(docker-compose) pull

start: pull
	$(docker-compose) up -t 60

update: pull
	$(docker-compose) up -d -t 60

stop:
	$(docker-compose) down --remove-orphans

install-services: install-blackbox-service
	systemctl daemon-reload

uninstall-services: uninstall-blackbox-service
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
	apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common && \
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
	apt-key fingerprint 0EBFCD88 && \
	add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" && \
	apt-get update && \
	apt-get install -y docker-ce docker-ce-cli containerd.io

# DATA_DIR=/path/to/pivxdata
check-datadir:
ifndef DATA_DIR
	$(error 'DATA_DIR' is undefined)
endif
