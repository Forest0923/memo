---
title: 「Rust で始める TCP 自作入門」を読んだメモ
date: 2024-03-07
---

## TCP・ネットワーク関連

### Socket

- stream socket: TCP
- datagram socket: UDP
- raw socket: データリンク層のフレームを直接操作する
- packet socket: ネットワーク層のパケットを直接操作する

### TCP header

### スライディングウィンドウ

### TCP の問題点、QUIC

## Rust 関連

### Error Handling

[Rust エラー処理](https://cha-shu00.hatenablog.com/entry/2020/12/08/060000)

### thread

### Arc

## ツール関連

### WireShark

- Install

```sh
paru -S wireshark-qt

sudo usermod -aG wireshark $USER
```

- loop back デバイスの 5000 番ポートへの TCP 通信をキャプチャする

```sh
tshark -i lo -f "tcp port 5000"
```

- キャプチャ例: nc で 5000 番ポートに接続

```text
% tshark -i lo -f "tcp port 5000"
Capturing on 'Loopback: lo'
    1 0.000000000          ::1 → ::1          TCP 94 45276 → 5000 [SYN] Seq=0 Win=33280 Len=0 MSS=65476 SACK_PERM TSval=1034799462 TSecr=0 WS=128
    2 0.000007955          ::1 → ::1          TCP 74 5000 → 45276 [RST, ACK] Seq=1 Ack=1 Win=0 Len=0
    3 0.000057822    127.0.0.1 → 127.0.0.1    TCP 74 52950 → 5000 [SYN] Seq=0 Win=33280 Len=0 MSS=65495 SACK_PERM TSval=2869984391 TSecr=0 WS=128
    4 0.000068765    127.0.0.1 → 127.0.0.1    TCP 54 5000 → 52950 [RST, ACK] Seq=1 Ack=1 Win=0 Len=0
```

### nc

- リスニング状態で待機

```sh
nc -l 5000
```

- 5000 番ポートに接続

```sh
nc localhost 5000
```

```text
% nc -l 5000
hello

% nc localhost 5000
hello
```

- ポートスキャン

```sh
nc -zv localhost <port>-<port>
```

```text
% nc -zv localhost 22
Connection to localhost (::1) 22 port [tcp/ssh] succeeded!
```

### ip

- Network namespace の作成

```sh
sudo ip netns add host0
sudo ip netns add host1
```

- Virtual Ethernet Device の作成
  - veth type のデバイスを作成し、veth0 と veth1 という名前でペアを作成する
  - 仮想的に 2 つのネットワークインタフェースが接続された状態になる
  - veth のドライバが必要

```sh
sudo ip link add name veth0 type veth peer name veth1
```

- namespace に作成したネットワークインタフェースを割り当てる
  - veth1 を host1 という namespace に割り当てる

```sh
sudo ip link set veth1 netns host1
```

- namespace 内でのコマンド実行

```sh
sudo ip netns exec host1 <command>
```

- ネットワークインタフェースを有効にする

```sh
sudo ip netns exec host1 ip link set veth1 up
```

### ethtool

### iptables
