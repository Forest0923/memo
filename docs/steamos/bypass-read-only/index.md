---
title: "Bypass Read Only"
draft: false
weight: 999
---

In SteamOS, /usr is read-only by default, so binaries of packages installed by pacman cannot be placed in /usr/bin.

To solve this problem, you can run `steamos-readonly disable`. However, packages installed under /usr with read-only disabled will be deleted when SteamOS is updated.

This page introduces a method to manage packages considering the SteamOS specification.

## Flatpak

Flatpak is the officially recommended method of installing packages.

If the application you need is distributed by Flatpak, you should use this method.

For example, you can see the packages I installed from Flatpak on my Steam Deck [here](../packages/).

If you want to check if a package you want is available, you can search for it in the [Flathub](https://flathub.org/home) or run `flatpak search application`.

### Remotes

By default, only Flathub is added to the repository list, and you need to run `flatpak remote-add name *.flatpakrepo` to add other repositories.

- [Fedora](https://fedoramagazine.org/an-introduction-to-fedora-flatpaks/)

```sh
flatpak remote-add --if-not-exists \
  fedora oci+https://registry.fedoraproject.org
```

- [GNOME](https://wiki.gnome.org/Apps/Nightly)

```sh
flatpak remote-add --if-not-exists \
  gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo
```

- [KDE](https://community.kde.org/Guidelines_and_HOWTOs/Flatpak#Applications)

```sh
flatpak remote-add --if-not-exists \
  kdeapps https://distribute.kde.org/kdeapps.flatpakrepo
```

- Flatpak beta

```sh
flatpak remote-add --if-not-exists \
  flatpak-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
```

> [Flatpak Remotes Other Than Flathub? - reddit](https://www.reddit.com/r/flatpak/comments/ge38f3/flatpak_remotes_other_than_flathub/)

## Create Alternative Root in /home/deck

The next method is to install packages in an arbitrary directory.

Flatpak is a very easy-to-use package manager, but if you are familiar to pacman or aur-helper, you may be inconvenienced by the small number of packages.

If you want to use an application that is only available in pacman repository, you can use `-r` option.

For the first time, run the following commands.

```sh
mkdir -p /home/deck/root/var/lib/pacman
sudo pacman -Sy -r /home/deck/root
```

This will create a database of packages under ~/root/var/lib/pacman.

After that, you can save binaries in ~/root/usr/bin by specifying `-r /home/deck/root` each time you install a package.

```sh
sudo pacman -S -r /home/deck/root application
```

You can run the package by adding ~/root/usr/bin to your PATH.

You can also make ~/.local as root, since ~/.local/bin is often already added to the PATH.

However, if any executable files already exist in ~/.local/bin, the installation of the filesystem package will fail.
(This is because /bin is a symbolic link to /usr/bin.)

## Build packages on your own

Needless to write...
