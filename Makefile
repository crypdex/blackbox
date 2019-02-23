DATA_DIR?=~/data

SERVICES = pivx
compose-files := $(foreach service,$(SERVICES),-f services/$(service)/docker-compose.yml)
#compose-files := $(foreach service,$(SERVICES),-f $(service)/docker-compose.yml)

build:
	./docker-build.sh

# DOCKER STACK EXPERIMENTAL
# devup:
# 	DATA_DIR=$(DATA_DIR) docker stack deploy $(compose-files) -c docker-compose.yml blackbox
# devdown:
# 	docker stack rm blackbox

devup:
	DATA_DIR=$(DATA_DIR) docker-compose -p blackbox $(compose-files) -f docker-compose.yml up
devdown:
	DATA_DIR=$(DATA_DIR) docker-compose -p blackbox $(compose-files) -f docker-compose.yml down

start:
	git pull origin master && \
	DATA_DIR=$(DATA_DIR) docker-compose -p blackbox $(compose-files) -f docker-compose.yml pull &&\
	DATA_DIR=$(DATA_DIR) docker-compose -p blackbox $(compose-files) -f docker-compose.yml up

stop:
	DATA_DIR=$(DATA_DIR) docker-compose -p blackbox $(compose-files) -f docker-compose.yml down --remove-orphans

# Installs the systemd service, enables it and starts it
systemd-install:
	cp services/blackbox.service /etc/systemd/system/
	systemctl enable /etc/systemd/system/blackbox.service
	systemctl start blackbox.service

# Uninstalls the service
systemd-uninstall:
	systemctl stop blackbox.service
	systemctl disable blackbox.service
	rm /etc/systemd/system/blackbox.service

# DATA_DIR=/path/to/pivxdata
check-datadir:
ifndef DATA_DIR
	$(error 'DATA_DIR' is undefined)
endif

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
