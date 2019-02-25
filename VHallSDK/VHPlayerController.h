//
//  VHPlayerController.h
//  Demo
//
//  Created by vhall on 2018/12/5.
//  Copyright © 2018 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VHPlayerController;

NS_ASSUME_NONNULL_BEGIN

#define kDispatchDefinitions (@[@"same",@"720p",@"480p",@"360p",@"a",@"916crop"]) //原画、超高清、高清、标清、纯音频、直播答题裁切分辨率
#define kDispatchTypeRTMP @"rtmp_url"   //直播rtmp
#define kDispatchTypeFLV  @"httpflv_url"//直播flv
#define kDispatchTypeHLS  @"hls_domainname"//点播hls
#define kDispatchTypeMP4  @"mp4_domainname"//点播MP4

typedef NS_ENUM(NSInteger, VHPlayerType) {
    VHPlayerTypeVOD    = 0,  // 回放
    VHPlayerTypeLive   = 1,  // 直播
};

// 播放器状态
typedef NS_ENUM(NSInteger,VHallPlayerState) {
    //初始化时指定的状态，播放器初始化
    VHallPlayerStateUnknow  = 0,
    //播放器正在加载，正在缓冲
    VHallPlayerStateLoading = 1,
    //播放器正在播放
    VHallPlayerStatePlaying = 2,
    //暂停，当播放器处于播放状态时，调用暂停方法，暂停视频
    VHallPlayerStatePause   = 3 ,
    //停止，调用stopPlay方法停止本次播放，停止后需再次调用播放方法进行播放
    VHallPlayerStateStop    = 4,
    //本次播放完
    VHallPlayerStateComplete = 5,
};

// 画面填充模式
typedef NS_ENUM(NSInteger, VHPlayerContentMode) {
    //拉伸至完全填充显示区域
    VHPlayerContentModeFill,
    //将图像等比例缩放，适配最长边，缩放后的宽和高都不会超过显示区域，居中显示，画面可能会留有黑边
    VHPlayerContentModeAspectFit,
    //将图像等比例铺满整个屏幕，多余部分裁剪掉，此模式下画面不会留黑边，但可能因为部分区域被裁剪而显示不全
    VHPlayerContentModeAspectFill,
};
/**
 *  视频清晰度
 */
typedef NS_ENUM(NSInteger,VHPlayerDefinition) {
    VHPlayerDefinitionOrigin             = 0,    //原画
    VHPlayerDefinitionUHD                = 1,    //超高清
    VHPlayerDefinitionHD                 = 2,    //高清
    VHPlayerDefinitionSD                 = 3,    //标清
    VHPlayerDefinitionAudio              = 4,    //纯音频
    VHPlayerDefinitionCrop               = 5,    //916crop 直播答题裁剪模式
};

//流类型
typedef NS_ENUM(NSInteger,VHPlayStreamType){
    VHPlayStreamTypeNone = 0,
    VHPlayStreamTypeVideoAndAudio,
    VHPlayStreamTypeOnlyVideo,
    VHPlayTypeOnlyAudio,
};

// 视频播放模式
typedef NS_ENUM(int,VHVideoRenderModel){
    VHVideoRenderModelOrigin = 1,  //普通视图的渲染
    VHVideoRenderModelVR,          //VR视图的渲染
};


@protocol VHPlayerControllerDelegate <NSObject>

@optional
/**
 *  观看状态回调
 *  @param player   播放器实例
 *  @param state   状态类型
 */
- (void)player:(VHPlayerController *)player playStateDidChanage:(VHallPlayerState)state;

/**
 *  当前点播支持的清晰度列表
 *  @param definitions   支持的清晰度列表
 *  @param definition    当前播放清晰度
 */
- (void)player:(VHPlayerController *)player validDefinitions:(NSArray <__kindof NSNumber*> *)definitions curDefinition:(VHPlayerDefinition)definition;

/**
 *  错误回调
 *  @param player   播放器实例
 *  @param error    错误
 */
- (void)player:(VHPlayerController *)player didStopWithError:(NSError *)error;


/**
 直播下载速度回调
 
 @param speed 下载速度 kb/s
 */
- (void)player:(VHPlayerController *)player loadingWithSpeed:(NSString *)speed;
/**
 *  streamtype 直播流类型
 *
 *  @param player       player
 *  @param streamtype   流类型
 */
- (void)player:(VHPlayerController *)player streamtype:(VHPlayStreamType)streamtype;
/**
 *  content msg content
 *
 *  @param player       player
 *  @param content   msg content
 */
- (void)player:(VHPlayerController *)player cuePointAmfMsg:(NSString *)content;


/**
 *  点播播放时间回调
 *  @param player   播放器实例
 *  @param currentTime    当前播放器时间回调
 */
- (void)player:(VHPlayerController*)player currentTime:(NSTimeInterval)currentTime;

@end


///观看直播、点播
@interface VHPlayerController : NSObject

/**
 初始化方法
 @param playerType 播放器类型
 */
+ (instancetype)playerWithType:(VHPlayerType)playerType;
- (instancetype)initWithType:(VHPlayerType)playerType;
- (instancetype)init NS_UNAVAILABLE;

/**
 播放器类型，只读的
 */
@property (nonatomic, readonly) VHPlayerType playerType;
/**
 播放器状态，只读的
 */
@property (nonatomic ,readonly) VHallPlayerState playerState;
/**
 播放器播放视图层view
 */
@property (nonatomic, strong, readonly) UIView *view;
/**
 播放事件代理
 */
@property (nonatomic, weak) id <VHPlayerControllerDelegate> delegate;

/**
 * 当前播放的清晰度 默认原画
 * 播放开始后设置
 */
@property(nonatomic,assign)VHPlayerDefinition             curDefinition;
/**
 * 设置默认播放的清晰度 默认原画
 * 播放开始前设置
 */
@property(nonatomic,assign)VHPlayerDefinition             defaultDefinition;
/**
 * 调度超时时间 默认1000毫秒，单位为毫秒
 */
@property(nonatomic,assign)int                      timeout;
/**
 * 设置画面的裁剪模式 详见 VHPlayerControllerScalingMode 的定义
 */
@property (nonatomic,assign)VHPlayerContentMode  scalingMode;

/**
 * 开始播放
 * @param streamUrl 流地址，一般是 rtmp、m3u8、MP4地址
 */
- (void)startWithStreamUrl:(NSString *)streamUrl;

/**
 * 开始调度并播放
 * @param dispatchUrl 调度地址
 * 点播  http://wiki.vhallops.com/pages/viewpage.action?pageId=1409525
 * @param defaultJson 默认播放地址，即调度服务失效时使用， 具体结构和上方文档一直，但token是计算后的'
 * json字符串 {"same":[{"hls_domainname/mp4_domainname":"https://xxxxx.e.vhall.com/vhallrecord/xxxxx/xxxxx/record.m3u8?token=计算后的token"}]}
 */
- (void)startWithDispatchUrl:(NSString*)dispatchUrl default:(nullable NSString*)defaultJson;

/**
 * 停止播放
 */
- (void)stop;

/**
 * 暂停播放
 */
- (void)pause;

/**
 * 恢复播放
 */
- (void)resume;

/**
 * 释放播放器
 */
- (void)destroyPlayer;



/**
 * 设置上报日志
 * @param  param 直播日志上报数据结构 根据实际情况调整
 *  "host"：上报地址域名  必传",
 *  "s":"sessionId  必传",
 *  "pf":"平台类型" 0代表iOSAPP 1代表AndroidAPP 2代表flash 3代表wap 4代表IOSSDK 5代表AndroidSDK 6代表小助手
 *  "bu":"区分业务单元，paas=1， saas=0 class=3",
 *  "app_id":"应用ID paas必传"
 *  "uid":"用户id",
 *  "aid":"活动id(房间id)",
 *  "ndi":"设备唯一标志符",
 *  "vid":"直播发起者账号",
 *  "vfid":"直播发起者父账号",
 */
- (void)setLogParam:(NSDictionary *)param;

/**
 * 播放器日志控制台打印开关 默认NO 关闭
 */
- (void)setLogPrintEnable:(BOOL)logPrintEnable;



/**
 seek 点播跳转到音视频流某个时间
 time: 流时间，单位为秒
 */
- (BOOL)seek:(float)time;
/**
 * 点播视频总时长
 */
@property (nonatomic, readonly) NSTimeInterval          duration;
/**
 * 点播可播放时长
 */
@property (nonatomic, readonly) NSTimeInterval          playableDuration;
/**
 * 点播当前播放时间
 */
@property (nonatomic, assign)   NSTimeInterval          currentTime;
/**
 * 点播倍速播放速率
 * 0.50, 0.67, 0.80, 1.0, 1.25, 1.50, and 2.0
 */
@property (nonatomic) float rate;



@property (nonatomic, assign) NSInteger bufferTime;//直播缓冲区时间 默认 6秒 必须>0 值越小延时越小,卡顿增加
@property (assign, readonly) int realityBufferTime;//直播实际的缓冲时间 即延迟时间
@property (nonatomic, assign) BOOL mute;//静音/取消

/**
 *  仅VR播放时可用 设置是否vr播放
 */
- (void)setRenderViewModel:(VHVideoRenderModel)renderViewModel;
/**
 *  是否使用陀螺仪，仅VR播放时可用
 */
- (void)setUsingGyro:(BOOL)usingGyro;
/**
 *  设置视频布局的方向，切要开启陀螺仪,仅VR模式可用
 */
- (void)setUILayoutOrientation:(UIDeviceOrientation)orientation;
@end

NS_ASSUME_NONNULL_END
