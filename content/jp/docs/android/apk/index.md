---
title: "リバースエンジニアリング（APK）"
draft: false
weight: 20
---

# リバースエンジニアリング（APK）

Android 用のアプリケーションパッケージである APK ファイルを解析するためのツールやその使い方についてのページです．

## ツールのインストール

### **Apktool**

APK の解凍やリビルドを容易に行えるリバースエンジニアリングのためのツール．

{{< tabs "Apktool" >}}
{{< tab "Arch" >}}

```sh
paru -S android-apktool
```

```sh
paru -S android-apktool-git
```

{{< /tab>}}
{{< /tabs>}}

### **dex2jar**

Android の dex フォーマットを Java の class に変換するツール．

{{< tabs "dex2jar" >}}
{{< tab "Arch" >}}

```sh
paru -S dex2jar
```

```sh
paru -S dex2jar-git
```

{{< /tab>}}
{{< /tabs>}}

### **jd-cli**

Java Decompiler の CLI ツール．

{{< tabs "jd-cli" >}}
{{< tab "Black Arch" >}}

```sh
paru -S jd-cli
```

{{< /tab>}}
{{< /tabs>}}

### **jd-gui**

Java Decompiler の GUI ツール．

{{< tabs "jd-gui" >}}
{{< tab "Arch" >}}

```sh
paru -S jd-gui
```

```sh
paru -S jd-gui-git
```

```sh
paru -S jd-gui-bin
```

{{< /tab>}}
{{< tab "Black Arch" >}}

```sh
paru -S jd-gui
```

{{< /tab>}}
{{< /tabs>}}

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
