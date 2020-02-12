---
title: ffmpeg
date: 2020-02-12
---

## Installation
```
$ sudo apt install ffmpeg
```

## Usage

|Command|Description|
|:------|:----------|
|`ffmpeg -i input.mp4 -crf 30 output.mp4`|Compression. The higher the crf value, the higher the compression ratio.|
|`ffmpeg -i input.mp4 -an output.mp4`|Mute.|