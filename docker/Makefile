
DATA_DIR=/root/chaindata
# Default configs ... good in lockdown case
CONF_DIR=$(realpath config)


chains = pivx blocknetdx zcoin dash
compose-files := $(foreach chain,$(chains),-f $(chain)/docker-compose.yml)

start:
	DATA_DIR=$(DATA_DIR) CONF_DIR=$(CONF_DIR) docker-compose -p chains $(compose-files) -f docker-compose.yml up

stop:
	DATA_DIR=$(DATA_DIR) CONF_DIR=$(CONF_DIR) docker-compose -p chains $(compose-files) -f docker-compose.yml down

config-all:
	DATA_DIR=$(DATA_DIR) CONF_DIR=$(CONF_DIR) docker-compose -p chains $(compose-files) -f docker-compose.yml config

up: check-chain
	DATA_DIR=$(DATA_DIR) CONF_DIR=$(CONF_DIR) docker-compose -p $(chain) -f $(chain)/docker-compose.yml up --build

# .PHONY: config
config: check-chain
	DATA_DIR=$(DATA_DIR) CONF_DIR=$(CONF_DIR) docker-compose -p $(chain) -f $(chain)/docker-compose.yml config

# Installs the systemd service, enables it and starts it
systemd-install:
	cp chains.service /etc/systemd/system/
	systemctl enable /etc/systemd/system/chains.service
	systemctl start chains.service

# Uninstalls the service
systemd-uninstall:
	systemctl stop chains.service
	systemctl disable chains.service
	rm /etc/systemd/system/chains.service

# PIVX (and maybe other chains) require a swap file to function properly.
# - This must be run as root and is NOT idempotent
# - Use $ swapon --show before running this command!
# - See: https://linuxize.com/post/how-to-add-swap-space-on-ubuntu-18-04/
# https://opensource.com/article/18/9/swap-space-linux-systems
swapsize = 4G
install-swapfile:
	fallocate -l $(swapsize) /swapfile && \
	chmod 600 /swapfile && \
	mkswap /swapfile && \
	swapon /swapfile && \
	echo "/swapfile swap swap defaults 0 0" >> /etc/fstab && \
	swapon --show

check-chain:
ifndef chain
	$(error chain is undefined)
endif



