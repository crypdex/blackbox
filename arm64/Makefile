# Defaults
CHAIN=pivx
CHAIN_DIR=/root/.$(CHAIN)
CHAIN_CONF=$(CHAIN_DIR)/$(CHAIN).conf
DATA_DIR=$(CHAIN_DIR)
DEFAULT_CONFIG_FILE=$(realpath config/$(CHAIN).conf)

# PIVX variables
PIVX_VERSION=3.1.1
PIVX_FILE=pivx-$(PIVX_VERSION)-aarch64-linux-gnu.tar.gz
PIVX_URL=https://github.com/PIVX-Project/PIVX/releases/download/v$(PIVX_VERSION)/$(PIVX_FILE)
PIVX_BIN=pivx-$(PIVX_VERSION)/bin


pivx-install: prepare-install
	cd downloads && wget $(PIVX_URL) && \
	tar -xvf $(PIVX_FILE) && \
	cp $(PIVX_BIN)/* /usr/local/bin/ && \
	mkdir -p $(CHAIN_DIR) && \
	cp $(DEFAULT_CONFIG_FILE) $(CHAIN_DIR)

start: check-datadir
	mkdir -p $(DATA_DIR) && \
	$(CHAIN)d -conf=$(CHAIN_CONF) -datadir=$(DATA_DIR)

stop:
	$(CHAIN)-cli -conf=$(CHAIN_CONF) stop

# Utility targets

prepare-install:
	rm -rf downloads && mkdir -p downloads

# Installs the systemd service, enables it and starts it
systemd-install:
	cp services/$(CHAIN).service /etc/systemd/system/
	systemctl enable /etc/systemd/system/$(CHAIN).service
	systemctl start $(CHAIN).service

# Uninstalls the service
systemd-uninstall:
	systemctl stop $(CHAIN).service
	systemctl disable $(CHAIN).service
	rm /etc/systemd/system/$(CHAIN).service

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
	fallocate -l 4G /swapfile && \
	chmod 600 /swapfile && \
	mkswap /swapfile && \
	swapon /swapfile && \
	echo "/swapfile swap swap defaults 0 0" >> /etc/fstab && \
	swapon --show