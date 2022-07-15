---
title: "Reverse Engineering (APK)"
draft: false
weight: 20
---

# Reverse Engineering (APK)

This is a page about tools for analyzing APK files, which are application packages for Android, and how to use them.

## Tools

### **Apktool**

A tool for reverse engineering APKs.

{{< tabpane "Apktool" >}}
{{< tab "Arch" >}}

```sh
paru -S android-apktool
```

```sh
paru -S android-apktool-git
```

{{< /tab>}}
{{< /tabpane>}}

### **dex2jar**

A tool to convert Android's dex format to Java's class.

{{< tabpane "dex2jar" >}}
{{< tab "Arch" >}}

```sh
paru -S dex2jar
```

```sh
paru -S dex2jar-git
```

{{< /tab>}}
{{< /tabpane>}}

### **jd-cli**

CLI tool for Java Decompiler.

{{< tabpane "jd-cli" >}}
{{< tab "Black Arch" >}}

```sh
paru -S jd-cli
```

{{< /tab>}}
{{< /tabpane>}}

### **jd-gui**

GUI tool for Java Decompiler.

{{< tabpane "jd-gui" >}}
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
{{< /tabpane>}}

## How to Use

### **When using Apktool**

The source will be extracted to `base/` by executing the command as follows.

```sh
apktool d base.apk
```

### **When using dex2jar, jd-\***

Convert the APK to a jar file with dex2jar as follows.

```sh
dex2jar base.apk
```

Decompile the generated `base-dex2jar.jar`. In case of GUI, run jd-gui and select `base-dex2jar.jar` from File Open. In case of CUI, run jd-cli as follows to extract the file to `src/`.

```sh
jd-cli base-dex2jar.jar -od src
```
