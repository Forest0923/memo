---
title: "ffmpeg"
draft: false
weight: 30
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Install

<Tabs groupId="ffmpeg" queryString>
  <TabItem value="arch" label="Arch">
  ```sh
sudo pacman -S ffmpeg
  ```
  </TabItem>
  <TabItem value="ubuntu" label="Ubuntu">
  ```sh
sudo apt install ffmpeg
  ```
  </TabItem>
</Tabs>

## MP4 Manipulation with ffmpeg

|Command|Description|
|:------|:----------|
|`ffmpeg -i input.mp4 -crf 30 output.mp4`|Compression. The higher the crf value, the higher the compression ratio.|
|`ffmpeg -i input.mp4 -an output.mp4`|Mute audio.|
