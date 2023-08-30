---
title: "OpenVPN Server の設定"
draft: false
weight: 50
---

Raspberry Pi 4B で Open VPN サーバを立てたときのメモです。
いくつか方法を試したのでそれぞれについて簡単に記録しておきます。

## 方法1: pivpn

一番簡単で確実な方法だと思います。
下記のコマンドを実行してあとは指示に従うだけでセットアップできます。

```sh
curl -L https://install.pivpn.io | bash
```

- [pivpn/pivpn - GitHub](https://github.com/pivpn/pivpn)

## 方法2: Docker

ちゃんと動いてくれればこの方法で実現したかったのですが、arm64 に対応していなかったり、コンテナがすぐ再起動してしまってうまく動かなかったりしました。

試したイメージはこんな感じ:

- [mje-nz/rpi-docker-openvpn](https://github.com/mje-nz/rpi-docker-openvpn)
  - kylemanna/openvpn のフォークで rpi に対応
  - 起動したあとに失敗して再起動ループ
- [evolvedm/openvpn-rpi](https://hub.docker.com/r/evolvedm/openvpn-rpi/)
  - rpi に対応した openvpn server
  - 起動したあとに失敗して再起動ループ
- [linuxserver/openvpn-as](https://hub.docker.com/r/linuxserver/openvpn-as/)
  - アーキテクチャのサポートが x86_64 のみ
- [kylemanna/openvpn](https://github.com/kylemanna/docker-openvpn)
  - アーキテクチャのサポートが x86_64 のみ

自分がうまく使いこなせていないだけで上の2つは動くかもしれないです。

## 方法3: Arch wiki などを見て地道にやる

下記URLをみて進めればなんとかなりそう。

- [Easy-RSA](https://wiki.archlinux.jp/index.php/Easy-RSA)
- [OpenVPN](https://wiki.archlinux.jp/index.php/OpenVPN)

仕組みを理解したいとかであれば頑張ってみるのも良さそうですが、ただ VPN サーバをラズパイで立てたいだけであれば pivpn がおすすめです。

ちなみに私も Easy RSA のクライアントファイル作成まではやってみましたが、もっといい方法があるだろうということで途中でやめました。
