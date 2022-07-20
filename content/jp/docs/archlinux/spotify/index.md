---
title: "Spotify の設定"
draft: false
weight: 100
---
Spotify の設定やトラブルシューティングについてのページです．

## HiDPI

高解像度のモニタを使う場合にはデフォルトだと UI が小さすぎるので設定を変えて見やすくします．
`/usr/share/applications/spotify.desktop` を下記のように修正することで，Spotify を GUI で起動したときにスケールを変えることができます．

```diff
-Exec=spotify %U
+Exec=spotify --force-device-scale-factor=1.5 %U
```

## Download Error

Spotify はダウンロードエラーが多いので，以下にエラー内容や解決策を雑記しておきます．

- Error:

```text
==> ERROR: Failure while downloading http://repository.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.1.56.595.g2d2da0de_amd64.deb
```

- Solution:

```sh
cd ~/.cache/paru/clone/spotify/
wget --continue http://repository.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.1.56.595.g2d2da0de_amd64.deb
mv spotify-client_1.1.56.595.g2d2da0de_amd64.deb spotify-1.1.56.595-x86_64.deb
paru -Syu
```

- Error:

```text
==> Verifying source file signatures with gpg...
    spotify-1.1.72.439-3-Release ... FAILED (unknown public key 5E3C45D7B312C643)
==> ERROR: One or more PGP signatures could not be verified!
error: failed to download sources for 'spotify-1:1.1.72.439-3':
```

```text
:: Downloading PKGBUILDs...
 PKGBUILDs up to date
 nothing new to review
:: keys need to be imported:)
     F9A211976ED662F00E59361E5E3C45D7B312C643 wanted by: spotify-1:1.1.72.439-3
:: import? [Y/n]:
gpg: key 5E3C45D7B312C643: public key "Spotify Public Repository Signing Key <tux@spotify.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1
fetching devel info...
```
