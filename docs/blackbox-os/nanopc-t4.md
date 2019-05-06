The NanoPC T4 has 16GB eMMC card on the board. It has Android pre-installed. You can install Ubuntu Core by using FriendlyElec's "eFlasher".

Here is how to do that

1. Download the eFlasher image [here](https://drive.google.com/drive/folders/1gaLKSlIHvqhJ5cASTFGSjJ9XvtgosZFQ). The file is called `rk3399-eflasher-friendlycore-bionic-4.4-arm64-20190308.img.zip`.
2. Using Etcher (or an equivalent), flash this image to a microSD card. Any size will do.
3. Insert the card into the NanoPC T4 and boot it.
4. Click install from the GUI. The end.

Detailed instructions can be found here:

- http://wiki.friendlyarm.com/wiki/index.php/NanoPC-T4#Flash_Image_to_eMMC

## Install M.2 disk

Following the tutorial here:

- https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux

```bash
# Identify the disk
lsblk

# Choose a partitioning standard
parted /dev/nvme0n1 mklabel gpt

# Create the new partition over the whole disk
parted -a opt /dev/nvme0n1 mkpart primary ext4 0% 100%

# Create a filesystem with a label "data"
# ... notice that we are using the new partition
mkfs.ext4 -L data /dev/nvme0n1p1
```

### Mount the filesystem on boot

```bash
# Make a mount dir
mkdir -p /mnt/data

# edit the fstab
nano /etc/fstab

# Add this line:
LABEL=data /mnt/data ext4 defaults,nofail 0 2
```
