# Make is used as a utility for coordinating various parts of the Blackbox
#
# Environment variables are used to parameterize the application.
# Values are imported from a .env file formatted as "VAR=value".
#
# NB: !! This .env will overwrite values from the environment   !!
# NB: !! If .env contains CHAINS= then no chains will be loaded !!
#
# CHAINS
# DATA_DIR

##############
## ENVIRONMENT
##############

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
DATA_DIR?=/root/data
BLACKBOX_DIR?=/root/blackbox

# CHAINS can be empty to allow for configuration
CHAINS?=

################
## ENTRY TARGETS
################

start:
	@bash ./scripts/start.sh

# make stop
stop: stop-docker

restart: update-docker restart-admin

############
## ADMIN APP
############

build-admin:
	@cd admin && bash ./scripts/build.sh

start-admin:
	@bash ./admin/scripts/start.sh

restart-admin:
	systemctl restart blackbox.admin.service

#################
## DOCKER COMPOSE
#################

# API and ADMIN services are in by default

docker-compose = DATA_DIR=$(DATA_DIR) BLACKBOX_DIR=$(BLACKBOX_DIR) \
	docker-compose -p blackbox \
	-f ./services/api/docker-compose.yml \
	-f ./services/admin/docker-compose.yml \
	$(foreach service,$(CHAINS),-f ./services/$(service)/docker-compose.yml)

build:
	./scripts/build-docker.sh

configuration:
	$(docker-compose) config

pull: setup
	$(docker-compose) pull

start-docker: pull
	$(docker-compose) up -t 60

# update and start are the same
update-docker: start-docker

stop-docker:
	$(docker-compose) down --remove-orphans

log:
	$(docker-compose) logs -f


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
	goreleaser --rm-dist --debug

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
	docker run -it -v $(shell pwd)/dist:/dist arm64v8/ubuntu:bionic

	# apt install ./dist/blackbox_v0.0.24-snapshot_linux_arm64v8.deb && ls /var/lib/blackbox/
