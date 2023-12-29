---
title: "Reverse Engineering (APK)"
draft: false
weight: 20
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

This is a page about tools for analyzing APK files, which are application packages for Android, and how to use them.

## Tools

### **Apktool**

A tool for reverse engineering APKs.

<Tabs groupId="OS" queryString>
  <TabItem value="arch" label="Arch">

    ```sh
    paru -S android-apktool
    # or
    paru -S android-apktool-git
    ```

  </TabItem>
</Tabs>

### **dex2jar**

A tool to convert Android's dex format to Java's class.

<Tabs groupId="OS" queryString>
  <TabItem value="arch" label="Arch">

    ```sh
    paru -S dex2jar
    # or
    paru -S dex2jar-git
    ```

  </TabItem>
</Tabs>

### **jd-cli**

CLI tool for Java Decompiler.

<Tabs groupId="OS" queryString>
  <TabItem value="arch" label="Arch">

    ```sh
    paru -S jd-cli
    ```

  </TabItem>
</Tabs>

### **jd-gui**

GUI tool for Java Decompiler.

<Tabs groupId="OS" queryString>
  <TabItem value="arch" label="Arch">

    ```sh
    paru -S jd-gui
    # or
    paru -S jd-gui-git
    # or
    paru -S jd-gui-bin
    ```

  </TabItem>
  <TabItem value="blackarch" label="Black Arch">

    ```sh
    paru -S jd-gui
    ```

  </TabItem>
</Tabs>

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
