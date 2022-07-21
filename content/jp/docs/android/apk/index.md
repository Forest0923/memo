---
title: "リバースエンジニアリング（APK）"
draft: false
weight: 20
---
Android 用のアプリケーションパッケージである APK ファイルを解析するためのツールやその使い方についてのページです．

## ツールのインストール

### **Apktool**

APK の解凍やリビルドを容易に行えるリバースエンジニアリングのためのツール．

{{< tabpane >}}
{{< tab header="Arch" lang="sh">}}

paru -S android-apktool
# or
paru -S android-apktool-git

{{< /tab>}}
{{< /tabpane>}}

### **dex2jar**

Android の dex フォーマットを Java の class に変換するツール．

{{< tabpane >}}
{{< tab header="Arch" lang="sh" >}}

paru -S dex2jar
# or
paru -S dex2jar-git

{{< /tab>}}
{{< /tabpane>}}

### **jd-cli**

Java Decompiler の CLI ツール．

{{< tabpane >}}
{{< tab header="Black Arch" lang="sh" >}}

paru -S jd-cli

{{< /tab>}}
{{< /tabpane>}}

### **jd-gui**

Java Decompiler の GUI ツール．

{{< tabpane >}}
{{< tab header="Arch" lang="sh" >}}

paru -S jd-gui
# or
paru -S jd-gui-git
# or
paru -S jd-gui-bin

{{< /tab>}}
{{< tab header="Black Arch" lang="sh" >}}

paru -S jd-gui

{{< /tab>}}
{{< /tabpane>}}

## 使い方

### **Apktool を使う場合**

下記のようにコマンドを実行することで `base/` にソースが展開されます．

```sh
apktool d base.apk
```

### **dex2jar, jd-\* を使う場合**

次のように dex2jar で APK を jar ファイルに変換します．

```sh
dex2jar base.apk
```

`base-dex2jar.jar` が生成されるので，デコンパイルします．GUI の場合は jd-gui を起動してファイルオープンで `base-dex2jar.jar` を選択します．CUI の場合は次のように jd-cli を実行すると `src/` にファイルが展開されます．

```sh
jd-cli base-dex2jar.jar -od src
```
