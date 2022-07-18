---
title: "fwupd"
draft: false
weight: 50
---
## Install


{{< tabpane "install" >}}
{{< tab "Arch" >}}

```sh
sudo pacman -S fwupd
```

{{< /tab >}}
{{< tab "Ubuntu" >}}

```sh
sudo apt install fwupd
```

{{< /tab >}}
{{< /tabpane >}}

## Usage

- Refresh data from server:

```sh
fwupdmgr refresh
```

- Check device for updates:

```sh
fwupdmgr get-updates
```

- Update and install:

```sh
fwupdmgr update
```

## Troubleshooting

- If the update does not apply, follow the steps below.

1. Download .cab file
2. Install:

```sh
fwupdmgr install [path-to-.cab]
```
