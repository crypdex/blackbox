# Defaults
chain=pivx
datadir=/root/chaindata/$(chain)
configfile=config/$(chain).conf

PIVX_VERSION=3.1.1
PIVX_URL=https://github.com/PIVX-Project/PIVX/releases/download/v$(PIVX_VERSION)/$(PIVX_FILE)
PIVX_FILE=pivx-$(PIVX_VERSION)-aarch64-linux-gnu.tar.gz

install-pivx: prepare-install
	cd downloads && wget $(PIVX_URL) && tar -xvf $(PIVX_FILE) && \
	cp pivx-$(PIVX_VERSION)/bin/* /usr/local/bin/

start-pivx: check-datadir
	mkdir -p $(datadir) && \
	pivxd -conf=$(realpath $(configfile)) -datadir=$(datadir)

stop-pivx:
	$(chain)-cli -conf=$(realpath $(configfile)) stop

# Utility targets

prepare-install:
	rm -rf downloads && mkdir -p downloads

# Installs the systemd service, enables it and starts it
install-systemd:
	cp services/$(chain).service /etc/systemd/system/
	systemctl enable /etc/systemd/system/$(chain).service
	systemctl start $(chain).service

# Uninstalls the service
uninstall-systemd: uninstall
	systemctl stop $(chain).service
	systemctl disable $(chain).service
	rm /etc/systemd/system/$(chain).service

# datadir=/path/to/pivxdata
check-datadir:
ifndef datadir
	$(error 'datadir' is undefined)
endif


# PIVX (and maybe other chains) require a swap file to function properly.
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