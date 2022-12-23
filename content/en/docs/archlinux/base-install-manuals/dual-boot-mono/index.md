---
title: "Dual boot (with Windows 10) + btrfs + grub"
draft: false
weight: 30
---
## System

| Settings        |             |
| --------------- | ----------- |
| Dual Booting    | Windows 10  |
| Filesystem      | Btrfs       |
| Boot Loader     | GRUB        |
| Disk            | single-disk |
| Disk Encryption | false       |

- Preinstalled OS: Windows 10 (64 bit Home)
- CPU: Intel
- Storage: `/dev/sda`

## Preparation in Windows 10

First, install Windows 10, then run Disk Management to create a free space for the Linux installation. The layout before and after creating the free partition will look like this.

- Before:
![disk-layout-before](dual-boot-disk-before.png)
- After:
![disk-layout-after](dual-boot-disk-after.png)

Then, install Arch Linux as follows.

## Install

### **Change Keymaps**

Change the keymap to the one you use for the installation. For a Japanese keyboard, use jp106.

```sh
loadkeys jp106
```

### **Time Settings**

Execute the following command to use the NTP (Network Time Protocol).

```sh
timedatectl set-ntp true
```

### **Optimizing Mirrorlist**

Optimize the mirror list using reflector to access mirror servers with fast access during installation.

```sh
pacman -Syy
pacman -S reflector # `python` might be required
reflector -c Japan --sort rate -a 6 --save /etc/pacman.d/mirrorlist
```

The meaning of the reflector option is as follows.

| Options                           | Description                                      |
| --------------------------------- | ------------------------------------------------ |
| `-c Japan`                        | Restrict mirrors to selected countries.          |
| `--sort rate`                     | Sort by download rate.                           |
| `-a 6`                            | Restrict to servers synchronized within 6 hours. |
| `--save /etc/pacman.d/mirrorlist` | Save the mirror list to the specified path.      |

### **Disk Partitioning and Formatting**

We will assume that the partition in `/dev/sda` is as follows.

```text
sda
├─sda1 <-- EFI Partition
├─sda2
├─sda3
├─sda4
└─sda5 <-- Empty Partition for Linux Filesystem
```

First, update the partition table so that the empty partition you created is used as Linux Filesystem.

```sh
cfdisk /dev/sda
```

Format the Linux filesystem partition with BTRFS, create a subvolume, and mount it.

```sh
mkfs.btrfs /dev/sda5
mount /dev/sda5 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@var_log
umount /mnt
mount -o noatime,compress=lzo,space_cache=v2,subvol=@ /dev/sda5 /mnt
mkdir -p /mnt/{boot,home,.snapshots,var/log}
mount -o noatime,compress=lzo,space_cache=v2,subvol=@home /dev/sda5 /mnt/home
mount -o noatime,compress=lzo,space_cache=v2,subvol=@snapshots /dev/sda5 /mnt/.snapshots
mount -o noatime,compress=lzo,space_cache=v2,subvol=@var_log /dev/sda5 /mnt/var/log
mount /dev/sda5 /mnt/boot
```

### **Base install**

Install the package in the root directory, `/mnt`.

```sh
pacstrap /mnt base linux linux-firmware vim intel-ucode
```

### **fstab**

Generate the fstab file, which holds the information about which device to mount.

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

### **Change the Root Directory**

Use chroot to set `/mnt` as the root directory.

```sh
arch-chroot /mnt
```

### **Localization**

Create a symbolic link to `/etc/localtime` to change the time zone.

```sh
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
```

Set the hardware clock to the current system clock. The system clock is the clock managed by the OS, and the hardware clock is the clock managed by the motherboard (hardware). when the OS is rebooted, the system clock stored in memory is lost, so the time is obtained from the hardware clock.

```sh
hwclock --systohc
```

To set the locale, first generate the locale. Uncomment the entries you want to use in `/etc/locale.gen` and run `locale-gen`.

```sh
vim /etc/locale.gen
```

```diff
- # en_US.UTF-8 UTF-8
+ en_US.UTF-8 UTF-8
```

```sh
locale-gen
```

Execute the following command to set the locale of the system.

```sh
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo KEYMAP=jp106 >> /etc/vconsole.conf
```

### **Hostname**

Register hostname in `/etc/hostname`.

```sh
vim /etc/hostname
```

```udiff
+ arch
```

Edit `/etc/hosts` and set IP address corresponding to hostname.

```sh
vim /etc/hosts
```

```diff
+ 127.0.0.1   localhost
+ ::1         localhost
+ 127.0.1.1   arch.localdomain    arch
```

### **Root Password**

Set the password of root user.

```sh
passwd
```

### **Install Additional Packages**

```sh
pacman -S grub efibootmgr networkmanager network-manager-applet \
 dialog os-prober mtools dosfstools base-devel linux-headers snapper \
reflector cron git xdg-utils xdg-user-dirs ntfs-3g
```

### **Configuring mkinitcpio**

Change the configurations, and reflect the changes with mkinitcpio.

```sh
vim /etc/mkinitcpio.conf
```

```diff
- MODULES=()
+ MODULES=(btrfs)
```

```sh
mkinitcpio -p linux
```

### **Bootloader**

Install Grub and create config file.

```sh
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

### **Systemd**

Enables NetworkManager.

```sh
systemctl enable NetworkManager
```

Enables Bluetooth.

```sh
systemctl enable bluetooth
```

Enables reflector. The execution options are written in `/etc/xdg/reflector/reflector.conf`.

```sh
systemctl enable reflector.service  # update mirrorlist every boot
```

```sh
systemctl enable reflector.timer    # update mirrorlist weekly
```

### **Add User**

Add user with useradd and set the password.

```sh
useradd -mG wheel mori
passwd mori
```

Give the user priviledges.

```sh
EDITOR=vim visudo
```

```diff
- # %wheel ALL=(ALL) ALL
+ %wheel ALL=(ALL) ALL
```

### **Reboot**

```sh
exit
umount -a
reboot
```

## Trouble shooting

- Boot entry of windows disappears from grub boot loader
  - Add `GRUB_DISABLE_OS_PROBER=false` to `/etc/default/grub` and recreate grub.cfg
  - The problem is deactivated os-prober. os-prober automatically finds operating systems and adds their boot entry, but sometimes it is deactivated. The option reactivate os-prober.
