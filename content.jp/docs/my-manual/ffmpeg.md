---
title: "MP4 Manipulation with ffmpeg"
description: ""
lead: ""
date: 2021-11-29T12:37:05+09:00
lastmod: 2021-11-29T12:37:05+09:00
draft: false
images: []
menu: 
  docs:
    parent: "my-manual"
weight: 30
toc: true
---

## Installation

```sh
sudo apt install ffmpeg
```

## Usage

|Command|Description|
|:------|:----------|
|`ffmpeg -i input.mp4 -crf 30 output.mp4`|Compression. The higher the crf value, the higher the compression ratio.|
|`ffmpeg -i input.mp4 -an output.mp4`|Mute.|
