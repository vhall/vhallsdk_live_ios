播放SDK
=============
## 简介

rtmp player 是微吼媒体库的一部分，负责RTMP流的接收、解码、渲染。


## 编译环境

## 类介绍
* `RtmpReader`  Rtmp读取库，读取RTMP流的audio/video/metedata。
* `MediaDecode` 解码类，负责压缩数据的队列缓存管理及解码。目前支持AAC、H264的解码。
* `MediaRender` 渲染控制类。渲染的时间同步管理




## Architecture
![image](https://gitlab.vhall.com/mobile_media/vhall_mobile_sdk/blob/dev/vinnylive_common/rtmp_player/rtmp_player.png)
<pre>               
      
</pre>