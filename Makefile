DATA_DIR?=~/data

# SERVICES = pivx
# compose-files := $(foreach service,$(SERVICES),-f services/$(service)/docker-compose.yml)
#compose-files := $(foreach service,$(SERVICES),-f $(service)/docker-compose.yml)

check-update:
	./check-update.sh

build:
	./build-docker.sh

# DOCKER STACK EXPERIMENTAL
# devup:
# 	DATA_DIR=$(DATA_DIR) docker stack deploy $(compose-files) -c docker-compose.yml blackbox
# devdown:
# 	docker stack rm blackbox
pull:
	DATA_DIR=$(DATA_DIR) docker-compose -p blackbox -f docker-compose.yml pull

start: pull
	DATA_DIR=$(DATA_DIR) docker-compose -d -t 180 -p blackbox -f docker-compose.yml up

stop:
	DATA_DIR=$(DATA_DIR) docker-compose -d -t 180 -p blackbox -f docker-compose.yml down --remove-orphans

install-services: install-blackbox-service install-updater-service
uninstall-services: uninstall-blackbox-service uninstall-updater-service

# Installs the systemd service, enables it and starts it
install-blackbox-service:
	cp services/blackbox.service /etc/systemd/system/
	systemctl enable /etc/systemd/system/blackbox.service
	systemctl start blackbox.service

install-updater-service:
	cp services/updater/updater.service /etc/systemd/system/
	cp services/updater/updater.timer /etc/systemd/system/
	systemctl enable /etc/systemd/system/updater.service
	systemctl enable /etc/systemd/system/updater.timer
#	systemctl start updater.service
	systemctl start updater.timer


# Uninstalls the service
uninstall-blackbox-service:
	systemctl stop blackbox.service
	systemctl disable blackbox.service
	rm /etc/systemd/system/blackbox.service

uninstall-updater-service:
	systemctl stop updater.service
	systemctl stop updater.timer
	systemctl disable updater.service
	systemctl disable updater.timer
	rm /etc/systemd/system/updater.service
	rm /etc/systemd/system/updater.timer

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

# DATA_DIR=/path/to/pivxdata
check-datadir:
ifndef DATA_DIR
	$(error 'DATA_DIR' is undefined)
endif