---
title: "platformio"
draft: false
weight: 40
---
## Install

- PlatformIO is written in Python. You can install following command:

```sh
pip3 install platformio
```

## Basic usage

- You can use `pio` instead of `platformio`.

| Command | Description|
|:--------|:-----------|
|`pio boards [Query]`|You can see supported boards.|
|`pio init --board [ID]`|Initialize current directory.|
|`pio lib search [Query]`|Search library.|
|`pio lib show [Query]`|Show description of the library.|
|`pio lib install [ID or Name]`|Install library.|
|`pio lib uninstall [ID or Name]`|Uninstall library.|
|`pio run`|Build program.|
|`pio run --target upload`|Upload program.|
|`pio device monitor`|Show serial monitor.|
|`pio device list`|Show list of device which is connected.|

## Directory structure

- The directory structure looks like this.

```text
./
├── .gitignore
├── .pio
│   └── libdeps
│       └── leonardo
│           └── ArduinoSTL_ID750
│               ├── .gitignore
│               ├── .library.json
│               ├── LICENSE
│               ├── README.md
│               ├── keywords.txt
│               ├── library.properties
│               └── src
├── .travis.yml
├── include
│   └── README
├── lib
│   └── README
├── platformio.ini
├── src
│   └── main.cpp
└── test
    └── README
```

- Your program have to be saved in the `src/`.
- `.pio` sometimes has an useful example code.
