---
title: "Upgrade Ubuntu 23.04 to 24.04 LTS"
date: 2025-04-18
tags: ["Linux", "Ubuntu"]
---

## About

Raspberry Pi で Ubuntu 23.04 から 24.04 LTS にアップグレードしようとしたら、`do-release-upgrade` でエラーが出たのでメモ。

## Log

元の環境の lunar はすでに EOL で repository が参照できない状態だったため `apt update` でエラーが出ていた。

```text
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 23.04"
NAME="Ubuntu"
VERSION_ID="23.04"
VERSION="23.04 (Lunar Lobster)"
VERSION_CODENAME=lunar
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=lunar
LOGO=ubuntu-logo
```

下記 URL を参考にして、`do-release-upgrade` を実行

- https://documentation.ubuntu.com/server/how-to/software/upgrade-your-release/index.html

```text
$ sudo do-release-upgrade
Checking for a new Ubuntu release
Your Ubuntu release is not supported anymore.
For upgrade information, please visit:
http://www.ubuntu.com/releaseendoflife


= Welcome to Ubuntu 24.04 LTS 'Noble Numbat' =

The Ubuntu team is proud to announce Ubuntu 24.04 LTS 'Noble Numbat'.

To see what's new in this release, visit:
  https://wiki.ubuntu.com/NobleNumbat/ReleaseNotes

Ubuntu is a Linux distribution for your desktop or server, with a fast
and easy install, regular releases, a tight selection of excellent
applications installed by default, and almost any other software you
can imagine available through the network.

We hope you enjoy Ubuntu.

== Feedback and Helping ==

If you would like to help shape Ubuntu, take a look at the list of
ways you can participate at

  http://www.ubuntu.com/community/participate/

Your comments, bug reports, patches and suggestions will help ensure
that our next release is the best release of Ubuntu ever.  If you feel
that you have found a bug please read:

  http://help.ubuntu.com/community/ReportingBugs

Then report bugs using apport in Ubuntu.  For example:

  ubuntu-bug linux

will open a bug report in Launchpad regarding the linux package.

If you have a question, or if you think you may have found a bug but
aren't sure, first try asking on the #ubuntu or #ubuntu-bugs IRC
channels on Libera.Chat, on the Ubuntu Users mailing list, or on the
Ubuntu forums:

  http://help.ubuntu.com/community/InternetRelayChat
  http://lists.ubuntu.com/mailman/listinfo/ubuntu-users
  http://www.ubuntuforums.org/


== More Information ==

You can find out more about Ubuntu on our website, IRC channel and wiki.
If you're new to Ubuntu, please visit:

  http://www.ubuntu.com/


To sign up for future Ubuntu announcements, please subscribe to Ubuntu's
very low volume announcement list at:

  http://lists.ubuntu.com/mailman/listinfo/ubuntu-announce


Continue [yN] y
Get:1 Upgrade tool signature [833 B]
Get:2 Upgrade tool [1277 kB]
Fetched 1278 kB in 0s (0 B/s)
authenticate 'noble.tar.gz' against 'noble.tar.gz.gpg'
extracting 'noble.tar.gz'
[screen is terminating]
```

```text
Reading cache

Checking package manager

Can not upgrade

An upgrade from 'lunar' to 'noble' is not supported with this tool.
=== Command detached from window (Fri Apr 18 20:12:30 2025) ===
=== Command terminated with exit status 1 (Fri Apr 18 20:12:40 2025) ===
```

うまくいかなかったので調べていると下記のドキュメントがあったので実施

- https://help.ubuntu.com/community/EOLUpgrades#Unsupported_upgrades
  - https://changelogs.ubuntu.com/meta-release

```bash
cd $(mktemp -d)
mkdir noble
wget http://archive.ubuntu.com/ubuntu/dists/noble-updates/main/dist-upgrader-all/current/noble.tar.gz
tar xf noble.tar.gz -C noble
cd noble
sudo ./noble
```

結局先ほどと同じエラーが出た。lunar -> noble のアップデートはサポートされていないみたい。

```text
Reading cache

Checking package manager

Can not upgrade

An upgrade from 'lunar' to 'noble' is not supported with this tool.
=== Command detached from window (Fri Apr 18 22:04:35 2025) ===
```

一旦 lunar -> mantic にアップグレードできないか試してみる。

```bash
cd ..
wget http://old-releases.ubuntu.com/ubuntu/dists/mantic-updates/main/dist-upgrader-all/current/mantic.tar.gz
mkdir mantic
tar xf mantic.tar.gz -C mantic/
cd mantic
sudo ./mantic --frontend=DistUpgradeViewText
```

```text
Reading cache

Checking package manager

Continue running under SSH?

This session appears to be running under ssh. It is not recommended
to perform a upgrade over ssh currently because in case of failure it
is harder to recover.

If you continue, an additional ssh daemon will be started at port
'1022'.
Do you want to continue?

Continue [yN] y

Starting additional sshd

To make recovery in case of failure easier, an additional sshd will
be started on port '1022'. If anything goes wrong with the running
ssh you can still connect to the additional one.
If you run a firewall, you may need to temporarily open this port. As
this is potentially dangerous it's not done automatically. You can
open the port with e.g.:
'iptables -I INPUT -p tcp --dport 1022 -j ACCEPT'

To continue please press [ENTER]

Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Hit https://download.docker.com/linux/ubuntu lunar InRelease
Hit http://packages.openvpn.net/as/debian jammy InRelease
Ign http://ports.ubuntu.com/ubuntu-ports lunar InRelease
Ign http://ports.ubuntu.com/ubuntu-ports lunar-updates InRelease
Ign http://ports.ubuntu.com/ubuntu-ports lunar-backports InRelease
Ign http://ports.ubuntu.com/ubuntu-ports lunar-security InRelease
Err http://ports.ubuntu.com/ubuntu-ports lunar Release
  404  Not Found [IP: 2620:2d:4000:1::19 80]
Err http://ports.ubuntu.com/ubuntu-ports lunar-updates Release
  404  Not Found [IP: 2620:2d:4000:1::19 80]
Hit http://old-releases.ubuntu.com/ubuntu lunar InRelease
Err http://ports.ubuntu.com/ubuntu-ports lunar-backports Release
  404  Not Found [IP: 2620:2d:4000:1::19 80]
Hit http://old-releases.ubuntu.com/ubuntu lunar-updates InRelease
Err http://ports.ubuntu.com/ubuntu-ports lunar-security Release
  404  Not Found [IP: 2620:2d:4000:1::19 80]
Hit http://old-releases.ubuntu.com/ubuntu lunar-security InRelease
Fetched 0 B in 0s (0 B/s)
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done

Checking for installed snaps

Calculating snap size requirements

Updating repository information

Third party sources disabled

Some third party entries in your sources.list were disabled. You can
re-enable them after the upgrade with the 'software-properties' tool
or your package manager.

To continue please press [ENTER]

Hit https://download.docker.com/linux/ubuntu lunar InRelease
Hit http://packages.openvpn.net/as/debian jammy InRelease
Fetched 0 B in 0s (0 B/s)

Checking package manager
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done

Invalid package information

After updating your package information, the essential package
'ubuntu-minimal' could not be located. This may be because you have
no official mirrors listed in your software sources, or because of
excessive load on the mirror you are using. See /etc/apt/sources.list
for the current list of configured software sources.
In the case of an overloaded mirror, you may want to try the upgrade
again later.


Restoring original system state

Aborting
      g package lists... 3%
*** Collecting problem information

The collected information can be sent to the developers to improve the
application. This might take a few minutes.
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
=== Command terminated with exit status 1 (Fri Apr 18 22:10:12 2025) ===

```

ubuntu-minimal が見つからないというエラーが出ていそう？
一度 `/etc/apt/sources.list` を修正して `http://old-releases.ubuntu.com/ubuntu/` のみにして再実行してみる。

```text
Reading cache

Checking package manager
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Hit http://packages.openvpn.net/as/debian jammy InRelease
Hit https://download.docker.com/linux/ubuntu lunar InRelease
Hit http://old-releases.ubuntu.com/ubuntu lunar InRelease
Hit http://old-releases.ubuntu.com/ubuntu lunar-updates InRelease
Hit http://old-releases.ubuntu.com/ubuntu lunar-security InRelease
Hit http://old-releases.ubuntu.com/ubuntu lunar-backports InRelease
Fetched 0 B in 0s (0 B/s)
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done

Checking for installed snaps

Calculating snap size requirements

Updating repository information

No valid mirror found

While scanning your repository information no mirror entry for the
upgrade was found. This can happen if you run an internal mirror or
if the mirror information is out of date.

Do you want to rewrite your 'sources.list' file anyway? If you choose
'Yes' here it will update all 'lunar' to 'mantic' entries.
If you select 'No' the upgrade will cancel.

Continue [yN] y
Hit https://download.docker.com/linux/ubuntu lunar InRelease
Hit http://packages.openvpn.net/as/debian jammy InRelease
Get:1 http://old-releases.ubuntu.com/ubuntu mantic InRelease [256 kB]
Get:2 http://old-releases.ubuntu.com/ubuntu mantic-updates InRelease [127 kB]
Get:3 http://old-releases.ubuntu.com/ubuntu mantic-security InRelease [127 kB]
Get:4 http://old-releases.ubuntu.com/ubuntu mantic-backports InRelease [127 kB]
Get:5 http://old-releases.ubuntu.com/ubuntu mantic/main arm64 Packages [1384 kB]
Get:6 http://old-releases.ubuntu.com/ubuntu mantic/main Translation-en [517 kB]
Get:7 http://old-releases.ubuntu.com/ubuntu mantic/main arm64 c-n-f Metadata [29.9 kB]
Get:8 http://old-releases.ubuntu.com/ubuntu mantic/restricted arm64 Packages [108 kB]
Get:9 http://old-releases.ubuntu.com/ubuntu mantic/restricted Translation-en [22.6 kB]
Get:10 http://old-releases.ubuntu.com/ubuntu mantic/restricted arm64 c-n-f Metadata [420 B]
Get:11 http://old-releases.ubuntu.com/ubuntu mantic/universe arm64 Packages [14.8 MB]
Get:12 http://old-releases.ubuntu.com/ubuntu mantic/universe Translation-en [5951 kB]
Get:13 http://old-releases.ubuntu.com/ubuntu mantic/universe arm64 c-n-f Metadata [295 kB]
Get:14 http://old-releases.ubuntu.com/ubuntu mantic/multiverse arm64 Packages [195 kB]
Get:15 http://old-releases.ubuntu.com/ubuntu mantic/multiverse Translation-en [113 kB]
Get:16 http://old-releases.ubuntu.com/ubuntu mantic/multiverse arm64 c-n-f Metadata [7168 B]
Get:17 http://old-releases.ubuntu.com/ubuntu mantic-updates/main arm64 Packages [369 kB]
Get:18 http://old-releases.ubuntu.com/ubuntu mantic-updates/main Translation-en [109 kB]
Get:19 http://old-releases.ubuntu.com/ubuntu mantic-updates/main arm64 c-n-f Metadata [9460 B]
Get:20 http://old-releases.ubuntu.com/ubuntu mantic-updates/restricted arm64 Packages [217 kB]
Get:21 http://old-releases.ubuntu.com/ubuntu mantic-updates/restricted Translation-en [35.7 kB]
Get:22 http://old-releases.ubuntu.com/ubuntu mantic-updates/restricted arm64 c-n-f Metadata [472 B]
Get:23 http://old-releases.ubuntu.com/ubuntu mantic-updates/universe arm64 Packages [404 kB]
Get:24 http://old-releases.ubuntu.com/ubuntu mantic-updates/universe Translation-en [158 kB]
Get:25 http://old-releases.ubuntu.com/ubuntu mantic-updates/universe arm64 c-n-f Metadata [14.3 kB]
Get:26 http://old-releases.ubuntu.com/ubuntu mantic-updates/multiverse arm64 Packages [5336 B]
Get:27 http://old-releases.ubuntu.com/ubuntu mantic-updates/multiverse Translation-en [2900 B]
Get:28 http://old-releases.ubuntu.com/ubuntu mantic-updates/multiverse arm64 c-n-f Metadata [228 B]
Get:29 http://old-releases.ubuntu.com/ubuntu mantic-security/main arm64 Packages [316 kB]
Get:30 http://old-releases.ubuntu.com/ubuntu mantic-security/main Translation-en [90.4 kB]
Get:31 http://old-releases.ubuntu.com/ubuntu mantic-security/main arm64 c-n-f Metadata [6880 B]
Get:32 http://old-releases.ubuntu.com/ubuntu mantic-security/restricted arm64 Packages [210 kB]
Get:33 http://old-releases.ubuntu.com/ubuntu mantic-security/restricted Translation-en [35.0 kB]
Get:34 http://old-releases.ubuntu.com/ubuntu mantic-security/restricted arm64 c-n-f Metadata [448 B]
Get:35 http://old-releases.ubuntu.com/ubuntu mantic-security/universe arm64 Packages [312 kB]
Get:36 http://old-releases.ubuntu.com/ubuntu mantic-security/universe Translation-en [129 kB]
Get:37 http://old-releases.ubuntu.com/ubuntu mantic-security/universe arm64 c-n-f Metadata [11.5 kB]
Get:38 http://old-releases.ubuntu.com/ubuntu mantic-security/multiverse arm64 Packages [4128 B]
Get:39 http://old-releases.ubuntu.com/ubuntu mantic-security/multiverse Translation-en [1732 B]
Get:40 http://old-releases.ubuntu.com/ubuntu mantic-security/multiverse arm64 c-n-f Metadata [232 B]
Get:41 http://old-releases.ubuntu.com/ubuntu mantic-backports/main arm64 c-n-f Metadata [112 B]
Get:42 http://old-releases.ubuntu.com/ubuntu mantic-backports/restricted arm64 c-n-f Metadata [116 B]
Get:43 http://old-releases.ubuntu.com/ubuntu mantic-backports/universe arm64 Packages [3944 B]
Get:44 http://old-releases.ubuntu.com/ubuntu mantic-backports/universe Translation-en [1392 B]
Get:45 http://old-releases.ubuntu.com/ubuntu mantic-backports/universe arm64 c-n-f Metadata [172 B]
Get:46 http://old-releases.ubuntu.com/ubuntu mantic-backports/multiverse arm64 c-n-f Metadata [116 B]
Fetched 26.5 MB in 6s (201 kB/s)
```

log を取りそこねたが、アップグレードにあたっていくつかのパッケージが削除されたりするけど良い？みたいな確認が出た。

`Continue [yN]  Details [d]` とプロンプトが出たので `d` を選ぶと具体的なパッケージのリストが出てきた。

```text
No longer supported: util-linux-extra


Remove: iptables-persistent

Remove (was auto installed) libevent-core-2.1-7a libsgutils2-2
  netfilter-persistent


Install: appstream dhcpcd-base dracut-install libduktape207 libeac3
  libsframe1 libsgutils2-1.46-2 linux-headers-6.5.0-1020-raspi
  linux-image-6.5.0-1020-raspi linux-modules-6.5.0-1020-raspi
  linux-raspi-headers-6.5.0-1020 netplan-generator python3-netplan
  systemd-dev ubuntu-pro-client xml-core


Upgrade: adduser apparmor apport apt apt-transport-https apt-utils
  ...
```

`y` を選択して進めると、無事にアップグレードが完了。

```text
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 23.10"
NAME="Ubuntu"
VERSION_ID="23.10"
VERSION="23.10 (Mantic Minotaur)"
VERSION_CODENAME=mantic
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=mantic
LOGO=ubuntu-logo
```

再起動して ssh 接続すると下記のようにログが出た。

```text
Your Ubuntu release is not supported anymore.
For upgrade information, please visit:
http://www.ubuntu.com/releaseendoflife

New release '24.04.2 LTS' available.
Run 'do-release-upgrade' to upgrade to it.
```

```text
$ sudo do-release-upgrade
[sudo] password for mmori:
Checking for a new Ubuntu release
Your Ubuntu release is not supported anymore.
For upgrade information, please visit:
http://www.ubuntu.com/releaseendoflife

Please install all available updates for your release before upgrading.
$ sudo apt update -y && sudo apt upgrade -y
...
E: dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem.
$ sudo dpkg --configure -a
$ sudo apt update -y && sudo apt upgrade -y
$ sudo systemctl reboot
$ sudo do-release-upgrade
```

いくつか追加で処理が必要だったが、無事にアップグレードできた。

```text
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 24.04.2 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.2 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
```
