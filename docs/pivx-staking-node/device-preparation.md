

## Odroid C2

The following sequence is followed to prepare a device for delivery.

- Install the [image](https://wiki.odroid.com/odroid-c2/os_images/ubuntu/ubuntu) from Odroid. Armbian does not work as well.
- Add the BlackboxOS repository
    - `deb [trusted=yes] https://apt.fury.io/crypdex/ /`
- Install required software
    - [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
    - [avahi](https://gist.github.com/davisford/5984768)
    - `apt install -y htop iotop bmon`
    - `apt upgrade -y` 
- Change the hostname
    - `nano /etc/hostname`
- Create the default directory
    - `mkdir ~/.blackbox`
- Copy the blockchain data
    - `scp -r root@seedbox.local:~/.blackbox/data/pivx ~/.blackbox/data`
- Put Docker in swarm mode
    - `docker swarm init`
- Change the root password to `crypdex` default
    - `passwd`
- Install a swapfile (only necessary for Odroid distro)
    
    ```shell
	fallocate -l 2G /swapfile && \
	chmod 600 /swapfile && \
	mkswap /swapfile && \
	swapon /swapfile && \
	echo "/swapfile swap swap defaults 0 0" >> /etc/fstab && \
	swapon --show
``` 
- Create a Blackboxfile
    - `nano ~/.blackbox/blackbox.yml`
- Install Docker Compose (optional)
    
    ```
    scp tools/docker-compose-Linux-aarch64 root@crypdex.local:/usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ```
    
### Installing the snapshot

```bash
# From project root
scp dist/blackboxd_v0.0.39-snapshot_linux_arm64v8.deb root@crypdex-0000.local:/root

# On the device
apt install ./blackboxd_v0.0.39-snapshot_linux_arm64v8.deb
blackboxd start
```



## Customer Delivery Preparations

- Remove the Portainer directory
    - `rm -rf ~/.blackbox/data/portainer`
- Remove the blockchain conf (it will be regenerated)
    - `rm -rf ~/.blackbox/data/pivx/pivx.conf`
- Change the hostname to match the serial.