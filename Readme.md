# vhallsdk-live-ios
自助式网络直播SDK

# 微吼直播 SaaS SDK v4.0 库迁移 

**微吼直播 SaaS SDK v4.0 及以后版本迁移至 
[vhallsdk_live_ios_v4.0](https://github.com/vhall/vhallsdk_live_ios_v4.0) 给您带来不便请谅解** <br>

## 集成和调用方式

[官方文档](http://www.vhall.com/saas/doc/310.html)<br>


### APP工程集成SDK基本设置
1、工程中AppDelegate.m 文件名修改为 AppDelegate.mm<br>
2、关闭bitcode 设置<br>
3、plist 中 App Transport Security Settings -> Allow Arbitrary Loads 设置为YES<br>
4、注册`AppKey`  [VHallApi registerApp:`AppKey` SecretKey:`AppSecretKey`]; <br>
5、检查工程 `Bundle ID` 是否与`AppKey`对应 <br>
6、plist中添加相机、麦克风权限 <br>


### 使用CocoaPods 引入SDK
pod 'VHallSDK_Live' , :git => 'https://github.com/vhall/vhallsdk_live_ios.git'<br>

使用美颜功能SDK<br>
pod 'VHallSDK_LiveFilter' , :git => 'https://github.com/vhall/vhallsdk_live_ios.git'<br>

使用互动功能SDK<br>
pod 'VHallSDK_Interactive' , :git => 'https://github.com/vhall/vhallsdk_live_ios.git'<br>

### 版本更新信息
#### 版本 v3.4.7 更新时间：2020.06.23
更新内容：<br>
1、修复互动偶现声音小问题<br>
2、修复变量冲突问题<br>

#### 版本 v3.4.6 更新时间：2020.05.25
更新内容：<br>
1、修复第三方推流可能导致播放花屏问题<br>

#### 版本 v3.4.5 更新时间：2020.01.15
更新内容：<br>
1、修复美颜进入卡顿问题<br>

#### 版本 v3.4.4 更新时间：2019.08.07
更新内容：<br>
1、修复推流bug<br>

#### 版本 v3.4.3 更新时间：2019.06.10
更新内容：<br>
1、新增直播中文档打开关闭功能<br>

#### 版本 v3.4.2 更新时间：2019.05.17
更新内容：<br>
1、回放支持倍速播放<br>

#### 版本 v3.4.0 更新时间：2019.04.15
更新内容：<br>
1、底层优化<br>
2、添加互动邀请，响应PC主持人邀请<br>

#### 版本 v3.3.0 更新时间：2019.02.25
更新内容：<br>
1、底层优化<br>

#### 版本 v3.2.3 更新时间：2018.12.21
更新内容：<br>
1、观看直播新增禁言、取消禁言<br>
2、观看直播新增踢出<br>

#### 版本 v3.2.2 更新时间：2018.11.16
更新内容：<br>
1、互动功能优化<br>
2、互动支持iOS8.0<br>

#### 版本 v3.2.1 更新时间：2018.10.25
更新内容：<br>
1、互动功能优化<br>
2、解决流类型bug<br>
3、新增swiftDemo<br>

#### 版本 v3.2.0 更新时间：2018.08.10
更新内容：<br>
1、新增互动功能<br>
2、优化点播播放器<br>

#### 版本 v3.1.1 更新时间：2018.07.27
更新内容：<br>
1、新增获取问答历史<br>
2、bug修复<br>

#### 版本 v3.1.0 更新时间：2018.06.26
更新内容：<br>
1、回放、点播支持多码率切换<br>
2、回放播放器优化<br>

#### 版本 v3.0.4 更新时间：2018.05.07
更新内容：<br>
1、底层优化<br>
2、bug修复<br>

#### 版本 v3.0.3 更新时间：2018.01.11
更新内容：<br>
1、观看调度，自动切换合适的CDN<br>
2、bug修复<br>

#### 版本 v3.0.2 更新时间：2017.11.21
更新内容：<br>
1、优化播放<br>

#### 版本 v3.0.1 更新时间：2017.10.23
更新内容：<br>
1、增加发送、接收自定义消息功能<br>
2、PPT白板画笔优化<br>
3、提供投屏二次开发基础模块<br>

#### 版本 v3.0 更新时间：2017.08.18
更新内容：<br>
1、性能优化<br>
2、日志上报内容更新<br>
3、滤镜模块优化，修复自定义滤镜bug<br>

#### 版本 v2.9.0 更新时间：2017.06.12
更新内容：<br>
1、性能优化<br>
2、添加推流调度 <br>
3、添加用户信息数据统计 <br>
5、修复iPhone5发起端bug

#### 版本 v2.8.1 更新时间：2017.05.04
更新内容：<br>
1:修复发直播异常Bug

#### 版本 v2.8.0 更新时间：2017.04.14
更新内容：<br>
1:新增观看VR活动以及陀螺仪功能

#### 版本 v2.7.1 更新时间：2017.03.31
更新内容：<br>

1：新增白板和画笔功能<br>


#### 版本 v2.7.0 更新时间：2017.03.13
更新内容：<br>

1：新增问卷功能<br>
2：Demo UI层拆分<br>


### 版本更新信息
#### 版本 v2.6.0 更新时间：2017.03.03
更新内容：<br>

1：新增公告功能<br>
2：新增签到功能<br>
3：DEMO弹幕显示<br>
4：DEMO聊天表情显示<br>

#### 版本 v2.5.4 更新时间：2016.12.30

更新内容：<br>

1：bug修复<br>

#### 版本 v2.5.3 更新时间：2016.12.23

更新内容：<br>

1：新增美颜功能<br>
2：评论相关功能 <br>
3：支持 MP4格式回放 <br>
4：支持 Https 协议<br>

#### 版本 v2.5.0 更新时间：2016.11.10

更新内容：<br>

1：新增抽奖功能<br>
2：新增获取20条最近聊天记录功能<br>

#### 版本 v2.4.0    更新时间：2016.09.26

更新内容：<br>

1、新增登录<br>
2、新增聊天<br>
3、新增问答<br>
4、集成应用签名机制<br>
5、观看直播支持音视频切换<br>
6、优化发直播调用方式<br>


#### 版本：v2.3.0  更新时间：2016.07.25

更新内容：<br>

1、加入美颜滤镜；<br>
2、加入清晰度切换；<br>
3、多线路智能切换；<br>
4、修复iOS返回第一帧图片时的内容泄露；<br>
	 
#### 版本：v2.2.2  更新时间：2016.06.01

更新内容：<br>

1、支持ipv6；<br>
2、修复bug；<br>

#### 版本：v2.2.1  更新时间：2016.05.12

更新内容：<br>

1、新增帧率配置；<br>
   
   
#### 版本：v2.2.0  更新时间：2016.05.06

更新内容：<br>

1、新增文档演示；<br>
2、优化观看体验；<br>


#### 版本：v2.1.2  更新时间：2016.04.14

更新内容：<br>

1、优化重名问题；<br>


#### 版本：v2.1.1  更新时间：2016.03.24

更新内容：<br>

1、pc端rtmp发起直播，sdk观看视频扭曲；<br>
2、sdk关闭播放会有卡顿问题；<br>
3、sdk观看rtmp直播，切换发起端设置，观看端卡顿问题；<br>
