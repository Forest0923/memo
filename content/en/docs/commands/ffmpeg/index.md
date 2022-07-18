---
title: "ffmpeg"
draft: false
weight: 30
---
## Install

{{< tabpane "install" >}}
{{< tab "Arch" >}}

```sh
sudo pacman -S ffmpeg
```

{{< /tab >}}
{{< tab "Ubuntu" >}}

```sh
sudo apt install ffmpeg
```

{{< /tab >}}
{{< /tabpane >}}

## MP4 Manipulation with ffmpeg

|Command|Description|
|:------|:----------|
|`ffmpeg -i input.mp4 -crf 30 output.mp4`|Compression. The higher the crf value, the higher the compression ratio.|
|`ffmpeg -i input.mp4 -an output.mp4`|Mute audio.|
