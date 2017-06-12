//
//  OpenCONSTS.h
//  VHMoviePlayer
//
//  Created by liwenlong on 15/10/14.
//  Copyright © 2015年 vhall. All rights reserved.
//

#ifndef OpenCONSTS_h
#define OpenCONSTS_h

/**
 *  打开VHall Debug 模式
 *
 *  @param enable true 打开 false 关闭
 */
extern void EnableVHallDebugModel(BOOL enable);

//设置摄像头取景方向
typedef NS_ENUM(int,DeviceOrientation)
{
    kDevicePortrait,
    kDeviceLandSpaceRight,
    kDeviceLandSpaceLeft
};

//直播流格式
typedef NS_ENUM(int,LiveFormat)
{
   kLiveFormatNone = 0,
   kLiveFormatRtmp,
   kLiveFormatFlV
};

typedef NS_ENUM(int,VideoResolution)
{
    kLowVideoResolution = 0,         //低分边率       352*288
    kGeneralVideoResolution,         //普通分辨率     640*480
    kHVideoResolution,               //高分辨率       960*540
    kHDVideoResolution               //超高分辨率     1280*720
};

typedef NS_ENUM(int,LiveStatus)
{
    kLiveStatusNone           = -1,
    kLiveStatusBufferingStart = 0,      //播放缓冲开始
    kLiveStatusBufferingStop  = 1,      //播放缓冲结束
    kLiveStatusPushConnectSucceed =2,   //直播连接成功
    kLiveStatusPushConnectError =3,     //直播连接失败
    kLiveStatusCDNConnectSucceed =4,    //播放CDN连接成功
    kLiveStatusCDNConnectError =5,      //播放CDN连接失败
    kLiveStatusParamError =6,           //参数错误
    kLiveStatusRecvError =7,            //播放接受数据错误
    kLiveStatusSendError =8,            //直播发送数据错误
    kLiveStatusDownloadSpeed =9,        //播放下载速率
    kLiveStatusUploadSpeed =10,         //直播上传速率
    kLiveStatusNetworkStatus =11,       //保留字段，暂时无用
    kLiveStatusGetUrlError =12,         //获取推流地址失败
    kLiveStatusWidthAndHeight =13,      //返回播放视频的宽和高
    kLiveStatusAudioInfo  =14,          //音频流的信息
    kLiveStatusAudioRecoderError  =15,  //音频采集失败，提示用户查看权限或者重新推流，切记此事件会回调多次，直到音频采集正常为止
    kLiveStatusUploadNetworkException=16,//发起端网络环境差
    kLiveStatusUploadNetworkOK = 17,     //发起端网络环境恢复正常
    kLiveStatusCDNStartSwitch = 18,      //CDN切换
    kLiveStatusRecvStreamType = 19       //接受流的类型
};

typedef NS_ENUM(int,LivePlayErrorType)
{
    kLivePlayGetUrlError = kLiveStatusGetUrlError,        //获取服务器rtmpUrl错误
    kLivePlayParamError = kLiveStatusParamError,          //参数错误
    kLivePlayRecvError  = kLiveStatusRecvError,           //接受数据错误
    kLivePlayCDNConnectError = kLiveStatusCDNConnectError,//CDN链接失败
    kLivePlayJsonFormalError = 15                         //返回json格式错误
};

//RTMP 播放器View的缩放状态
typedef NS_ENUM(int,RTMPMovieScalingMode)
{
    kRTMPMovieScalingModeNone,       // No scaling
    kRTMPMovieScalingModeAspectFit,  // Uniform scale until one dimension fits
    kRTMPMovieScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
};

//流类型
typedef NS_ENUM(int,VHallStreamType)
{
   kVHallStreamTypeNone = 0,
   kVHallStreamTypeVideoAndAudio,
   kVHallStreamTypeOnlyVideo,
   kVHallStreamTypeOnlyAudio,
};

typedef NS_ENUM(int,VHallRenderModel){
   kVHallRenderModelNone = 0,
   kVHallRenderModelOrigin,  //普通视图的渲染
   kVHallRenderModelDewarpVR, //VR视图的渲染
};

@protocol CameraEngineRtmpDelegate <NSObject>
/**
 *  采集到第一帧的回调
 *
 *  @param image 第一帧的图片
 */
-(void)firstCaptureImage:(UIImage*)image;
/**
 *  发起直播时的状态
 *
 *  @param liveStatus 直播状态
 */
-(void)publishStatus:(LiveStatus)liveStatus withInfo:(NSDictionary*)info;

/**
 * 当liveStatus == kLiveStatusPushConnectError时，content代表出错原因
 * 4001   握手失败
 * 4002   链接vhost/app失败
 * 4003   网络断开 （预留，暂时未使用）
 * 4004   无效token
 * 4005   不再白名单中
 * 4006   在黑名单中
 * 4007   流已经存在
 * 4008   流被禁掉 （预留，暂时未使用）
 * 4009   不支持的视频分辨率（预留，暂时未使用）
 * 4010   不支持的音频采样率（预留，暂时未使用）
 * 4011   欠费
 */
@end

@class VHMoviePlayer;

@protocol VHMoviePlayerDelegate <NSObject>

@optional
/**
 *  播放连接成功
 */
- (void)connectSucceed:(VHMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  缓冲开始回调
 */
- (void)bufferStart:(VHMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  缓冲结束回调
 */
-(void)bufferStop:(VHMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  下载速率的回调
 *
 *  @param moviePlayer
 *  @param info        下载速率信息 单位kbps
 */
- (void)downloadSpeed:(VHMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  cdn 发生切换时的回调
 *
 *  @param moviePlayer
 *  @param info      
 */
- (void)cdnSwitch:(VHMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  Streamtype
 *
 *  @param moviePlayer moviePlayer
 *  @param info        info
 */
- (void)recStreamtype:(VHMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  播放时错误的回调
 *
 *  @param livePlayErrorType 直播错误类型
 */
- (void)playError:(LivePlayErrorType)livePlayErrorType info:(NSDictionary*)info;

@end
#endif /* OpenCONSTS_h */
