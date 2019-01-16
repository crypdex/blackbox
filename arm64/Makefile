# Defaults
CHAIN=pivx
DATA_DIR=/root/chaindata/$(CHAIN)
DEFAULT_CONFIG_FILE=$(realpath config/$(CHAIN).conf)

# PIVX variables
PIVX_VERSION=3.1.1
PIVX_FILE=pivx-$(PIVX_VERSION)-aarch64-linux-gnu.tar.gz
PIVX_URL=https://github.com/PIVX-Project/PIVX/releases/download/v$(PIVX_VERSION)/$(PIVX_FILE)
PIVX_BIN=pivx-$(PIVX_VERSION)/bin
PIVX_DIR=/root/.pivx
PIVX_CONF=$(PIVX_DIR)/$(CHAIN).conf

pivx-install: prepare-install
	cd downloads && wget $(PIVX_URL) && \
	tar -xvf $(PIVX_FILE) && \
	cp $(PIVX_BIN)/* /usr/local/bin/ && \
	mkdir -p $(PIVX_DIR) && \
	cp $(DEFAULT_CONFIG_FILE) $(PIVX_DIR)

pivx-start: check-datadir
	mkdir -p $(DATA_DIR) && \
	pivxd -conf=$(PIVX_CONF) -datadir=$(DATA_DIR)

pivx-stop:
	$(CHAIN)-cli -conf=$(PIVX_CONF) stop

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