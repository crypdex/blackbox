
build-all:
	./scripts/build-all.sh

# Build docker images for protocol
build: require-service
	./scripts/build.sh ${service}

require-service:
ifndef service
	$(error 'service' is undefined)
endif



##################
## SYSTEM SERVICES
##################

# Installs the systemd service, enables it and starts it
install-service:
	cp services/blackbox.service /etc/systemd/system/
	systemctl enable /etc/systemd/system/blackbox.service
	systemctl start blackbox.service

# Uninstalls the service
uninstall-service:
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

setup:
	bash ./scripts/generate-chain-conf.sh

# DATA_DIR=/path/to/pivxdata
check-chains:
ifndef CHAINS
	$(error 'CHAINS' is undefined)
else
	@echo "configured for ${CHAINS}"
endif



##################
## DEVELOPMENT
##################

TAG?=

release: require-tag
	git tag ${TAG}
	git push origin ${TAG}
	goreleaser --rm-dist --release-notes=docs/release-notes/latest.md
	curl -F package=@dist/blackbox-os_${TAG}_linux_arm64v8.deb https://${GEMFURY_PUSH_TOKEN}@push.fury.io/crypdex/ && \
	curl -F package=@dist/blackbox-os_${TAG}_linux_armv7.deb https://${GEMFURY_PUSH_TOKEN}@push.fury.io/crypdex/ && \
	curl -F package=@dist/blackbox-os_${TAG}_linux_x86_64.deb https://${GEMFURY_PUSH_TOKEN}@push.fury.io/crypdex/

release-test:
	goreleaser --snapshot --skip-publish --rm-dist --release-notes=docs/release-notes/latest.md

# The Dockerfile uses the vendor dir to work around context issues.
#release: require-tag
#	git tag ${TAG}
#	git push origin ${TAG}

require-tag:
ifndef TAG
	$(error 'TAG' is undefined)
else
	@echo "configured for ${TAG}"
endif

test-dist:
	docker run -it -v $(shell pwd)/dist:/dist ubuntu:bionic

	# apt install ./dist/blackbox_v0.0.16-snapshot_linux_x86_64.deb && ls /var/lib/blackbox/

publish-docs:
	cd website && USE_SSH=true yarn publish-gh-pages

.PHONY: docs
docs:
	cd website && yarn start

##################
## CIRCLE CI
##################

release-docker-images:
	@bash scripts/release-docker-images.sh
