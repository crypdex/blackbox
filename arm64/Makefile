PIVX_VERSION=3.1.1
PIVX_URL=https://github.com/PIVX-Project/PIVX/releases/download/v$(PIVX_VERSION)/$(PIVX_FILE)
PIVX_FILE=pivx-$(PIVX_VERSION)-aarch64-linux-gnu.tar.gz

prepare-install:
	rm -rf downloads && mkdir -p downloads

install-pivx: prepare-install
	cd downloads && \
	wget $(PIVX_URL) && \
	tar -xvf $(PIVX_FILE) && \
	cp pivx-$(PIVX_VERSION)/bin/* /usr/local/bin/

start-pivx: check-datadir
	pivxd -conf=config/pivx.conf -datadir=$(datadir)

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