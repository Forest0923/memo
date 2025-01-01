---
title: 「RISC-V で学ぶコンピュータアーキテクチャ完全入門」を読んだメモ
date: 2024-12-31
---

## MEMO

### Verilog

- [Verilog HDL Quick Reference Guide](https://www.cs.columbia.edu/~sedwards/classes/2002/w4115/verilog_ref.pdf)
- [Style guide](https://github.com/lowRISC/style-guides)

### RISC-V

- [RISC-V Technical Specifications](https://lf-riscv.atlassian.net/wiki/spaces/HOME/pages/16154769/RISC-V+Technical+Specifications)

### パイプライン

- クリティカルパスを分割してクロック周波数を上げる
- 書籍の実装では Instruction Fetch、Instruction Decode、Execution、Memory Access、Write Back の 5 ステージパイプライン
- [List of Intel CPU microarchitectures (Wikipedia)](https://en.wikipedia.org/wiki/List_of_Intel_CPU_microarchitectures)
  - https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html
  - 現在の Intel CPU は 10~20 ステージくらいのパイプラインがあるっぽい

### 分岐予測

- 本来であれば分岐命令が実行されて次のPCが決まるまで (Execution stage の完了まで) 待たなければならないため、他の pipeline が stall する
  - 分岐先を予測すれば stall を回避して先に instruction fetch できる

- 分岐予測の種類
  - ① 分岐命令かどうかの予測
  - ② 飛び先アドレスの予測
    - ⇒ Branch Target Buffer (BTB) を用いる
    - **分岐命令のアドレス**と**ジャンプ先のアドレス**を保持したテーブルがあればいい ← このテーブルが BTB
    - 実行時に PC の下位ビットをインデックスとして BTB のエントリにアクセス
    - エントリの分岐アドレスが PC と一致すればジャンプ先アドレスを取り出す
  - ③ 分岐結果の予測
    - ⇒ Pattern History Table (PHT) を用いる
    - 分岐履歴を保持しておいて，その履歴から分岐の結果を予測
    - BTB と同じように PC の下位ビットをインデックスとして PHT にアクセス
    - PHT には分岐の結果が格納されているため、これをもとに各分岐命令ごとの結果を予測
- PHT の履歴をどのように記録していくかのアルゴリズムによって性能は変わる
  - PHT が 1 bit で一つ前の結果を記録する
  - bimodal 分岐予測
  - gshare 分岐予測
- bimodal 分岐予測
  - 2 bit のカウンタを用いて分岐の結果を記録
    - 00: weak not taken
    - 01: weak taken
    - 10: strong not taken
    - 11: strong taken
  - 上位ビットが 1 ならば成立と予測
  - 実際に分岐が成立した場合はカウンタをインクリメントし、成立しなかった場合はデクリメント
- gshare 分岐予測
  - 過去 n 回の分岐履歴を保存して予測する → Branch History Register (BHR)
  - PC と n bit の BHR を XOR してインデックスを生成
  - そのインデックスを用いて bimoal 分岐予測と同じように予測を行う

### キャッシュ

- メインメモリへのアクセスはどうしても遅いので、容量は小さくていいので高速なメモリを CPU に持たせる
- DRAM を使おうとすると遅延が大きく、読み書きするたびに後続の処理を stall させる必要が出てしまう
- ダイレクトマップ方式
  - 分岐予測と同じように PC の下位ビットをインデックスとして命令キャッシュにアクセス
  - PC とキャッシュのタグが一致 (ヒット) したらメインメモリにアクセスせずに命令を取り出す
- キャッシュラインを使用することで空間的局所性を利用
  - あるアドレスを読み込んだときにその周辺のアドレスも読み込む
- n way セットアソシアティブキャッシュ
  - index が衝突した場合にダイレクトマップでは1つしかキャッシュラインを使えないが、n way ならば n 個のキャッシュラインを使える
  - n 個のキャッシュテーブルがあるイメージ。n が多すぎると hit 確認でクリティカルパスが長くなり遅延が増える
- キャッシュは命令だけでなくデータキャッシュもある
  - データキャッシュは読み書きが発生するため、メインメモリとの同期も必要
  - Write Through/Write Back
  - メインメモリへの書き込みは遅いので書き込みが終わるまで stall するのは避けたい
  - Write Buffer に書き込んでおいて、メインメモリへの書き込みはメモリコントローラに任せる
  - Write Buffer が溢れた場合やメモリからの読み込みが発生した場合はメモリコントローラがプロセッサを stall させる

### Vivado

- flatpak で install すると楽

```bash
flatpak install com.github.corna.Vivado
```

- 事前にアカウントの作成はする必要がある
- バージョンによって名前が違いそうだが、ML edition は特定のボードを除いて無料で使用できる

- flatpak はサンドボックス環境で動作していてアクセス権限が絞られている
- home ディレクトリはアクセス権があったほうがいいので設定を変更する

```bash
flatpak override com.github.corna.Vivado --filesystem=home
```

```txt
% flatpak info --show-permissions com.github.corna.Vivado
[Context]
shared=network;ipc;
sockets=x11;
devices=all;
filesystems=xdg-documents;xdg-desktop;home;xdg-download;~/.Xilinx:create;
persistent=.;

[Session Bus Policy]
org.gnome.SessionManager=talk

[Environment]
LD_LIBRARY_PATH=/app/lib
TERMINFO=/app/share/terminfo
LC_ALL=en_US.UTF-8
```

- board の driver がない場合に Hardware Manager の auto connect ができないので、下記でドライバをインストールする

```bash
cd $HOME/.var/app/com.github.corna.Vivado/data/xilinx-install/Vivado/2024.2/data/xicom/cable_drivers/lin64/install_script/install_drivers
sudo ./install_drivers
```

```text
% sudo ./install_drivers
[sudo] password for mmori:
INFO: Installing cable drivers.
INFO: Script name = ./install_drivers
INFO: HostName = strix
INFO: RDI_BINROOT= .
INFO: Current working dir = /home/mmori/.var/app/com.github.corna.Vivado/data/xilinx-install/Vivado/2024.2/data/xicom/cable_drivers/lin64/install_script/install_drivers
INFO: Kernel version = 6.6.64-1-lts.
INFO: Arch = x86_64.
Successfully installed Digilent Cable Drivers
--File /etc/udev/rules.d/52-xilinx-ftdi-usb.rules does not exist.
--File version of /etc/udev/rules.d/52-xilinx-ftdi-usb.rules = 0000.
--Updating rules file.
--File /etc/udev/rules.d/52-xilinx-pcusb.rules does not exist.
--File version of /etc/udev/rules.d/52-xilinx-pcusb.rules = 0000.
--Updating rules file.

INFO: Digilent Return code = 0
INFO: Xilinx Return code = 0
INFO: Xilinx FTDI Return code = 0
INFO: Return code = 0
INFO: Driver installation successful.
CRITICAL WARNING: Cable(s) on the system must be unplugged then plugged back in order for the driver scripts to update the cables.
```

- その他参考
  - https://www.acri.c.titech.ac.jp/wordpress/
