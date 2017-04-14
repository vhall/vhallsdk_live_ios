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
typedef NS_ENUM(int,DeviceOrgiation)
{
    kDevicePortrait,
    kDeviceLandSpaceRight,
    kDeviceLandSpaceLeft
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
    kLiveStatusCDNStartSwitch = 18,       //CDN切换
    kLiveStatusRecvStreamType = 19        //接受流的类型
   
};

typedef NS_ENUM(int,LivePlayErrorType)
{
    kLivePlayGetUrlError = kLiveStatusGetUrlError,        //获取服务器rtmpUrl错误
    kLivePlayParamError = kLiveStatusParamError,          //参数错误
    kLivePlayRecvError  = kLiveStatusRecvError,           //接受数据错误
    kLivePlayCDNConnectError = kLiveStatusCDNConnectError, //CDN链接失败
    kLivePlayJsonFormalError = 15                          //返回json格式错误
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
 * code	含义
 * 10030	身份验证出错
 * 10401	活动开始失败
 * 10402	当前活动ID错误
 * 10403	活动不属于自己编辑
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

/**
 *  code	   含义
 *  10030	身份验证出错
 *  10402	当前活动ID错误
 *  10404	KEY值验证出错
 *  10046	当前活动已结束
 *  10047	您已被踢出，请联系活动组织者
 *  10048	活动现场太火爆，已超过人数上限
 */
@end
#endif /* OpenCONSTS_h */
