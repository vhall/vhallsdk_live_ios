//
//  VHRenderView.h
//  VHInteractive
//
//  Created by vhall on 2018/4/18.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const VHSimulcastLayersKey;   //推流参数-同时推流数  默认:1 只推1路流   2，发起端推送大小两路流，用于超多人互动场景

extern NSString * const VHStreamOptionStreamType;//推流类型   VHInteractiveStreamType VHInteractiveStreamTypeAudioAndVideo 音视频
extern NSString * const VHFrameResolutionTypeKey;//推流分辨率 VHFrameResolutionValue VHFrameResolution192x144

extern NSString * const VHStreamOptionVideo;  //视频
extern NSString * const VHStreamOptionAudio;  //音频

//如果设置VHFrameResolutionTypeKey 以下参数可以不用设置
extern NSString * const VHVideoWidthKey;        //推流视频宽度 默认192
extern NSString * const VHVideoHeightKey;       //推流视频高度 默认144
extern NSString * const VHVideoFpsKey;          //推流视频帧率 默认30
extern NSString * const VHMaxVideoBitrateKey;   //推流最大码率 默认300
extern NSString * const VHCurrentBitrateKey;   //当前推流码率
extern NSString * const VHMinBitrateKbpsKey;   //推流最小码率 默认100

/*
 * 摄像头及推流参数设置
 */
typedef NS_ENUM(NSInteger, VHPushType) {
    VHPushTypeNone, //未知，使用默认设置
    VHPushTypeSD,   //默认192x144
    VHPushTypeHD,   //352x288
    VHPushTypeUHD,  //480x360
    VHPushTypeCUSTOM//
};

/*
 * 画面填充模式
 */
typedef NS_ENUM(int,VHRenderViewScalingMode){
    VHRenderViewScalingModeNone,       // 画面拉伸填充
    VHRenderViewScalingModeAspectFit,  // 画面等比缩放到最大边填满 可能会有留边
    VHRenderViewScalingModeAspectFill, // 画面等比缩放到最小边填满 可能会裁剪掉部分画面
};

/*
 * 互动流类型
 */
typedef NS_ENUM(int, VHInteractiveStreamType) {
    VHInteractiveStreamTypeOnlyAudio       = 0,//纯音频
    VHInteractiveStreamTypeOnlyVideo       = 1,//纯视频
    VHInteractiveStreamTypeAudioAndVideo   = 2,//音视频 默认
    VHInteractiveStreamTypeScreen          = 3,//共享桌面 暂不支持
    VHInteractiveStreamTypeFile            = 4 //插播  暂不支持
};

typedef NS_ENUM(int, VHFrameResolutionValue) {
    VHFrameResolution192x144 = 0,
    VHFrameResolution240x160 = 1,
    VHFrameResolution320x240 = 2,
    VHFrameResolution480x360 = 3, //
    VHFrameResolution570x432 = 4, //
    VHFrameResolution640x480 = 5  //
};
/*
 * 流状态监听回调block定义
 */
typedef void(^StatsCallback)(NSString* mediaType, long kbps, NSDictionary<NSString *, NSString *> * values);
typedef void(^FinishBlock)(int code, NSString * _Nullable message);//code 200 成功

@class VHRenderView;


///推流摄像头view类，该类定义了摄像头视图的创建、推流等Api，通过此类进行互动推流。使用此类请先在plist文件中添加对于摄像头和麦克风的权限描述。
@interface VHRenderView : UIView

/*
 * 创建本地摄像头view
 * 默认参数 使用服务器配置参数
 */
- (instancetype)initCameraViewWithFrame:(CGRect)frame;
/*
 * 创建本地摄像头view 使用自定义 视频参数
 * type       type 推流清晰度设置 设置后 options可设置为nil
 * @param options   type = VHPushTypeCUSTOM 时有效   @{VHFrameResolutionTypeKey:@(VHFrameResolution192x144),VHStreamOptionStreamType:@(VHInteractiveStreamTypeAudioAndVideo)}
 */
- (instancetype)initCameraViewWithFrame:(CGRect)frame pushType:(VHPushType)type options:(NSDictionary*)options;

/*
 * 创建本地摄像头view 使用自定义 视频参数
 * @param options  如：@{VHFrameResolutionTypeKey:@(VHFrameResolution192x144),VHStreamOptionStreamType:@(VHInteractiveStreamTypeAudioAndVideo)}
 */
- (instancetype)initCameraViewWithFrame:(CGRect)frame options:(NSDictionary*)options;

/*
 * 更新推流参数 要求推流之前设置有效 本地流有效
 * @param options  如：@{VHFrameResolutionTypeKey:@(VHFrameResolution192x144),VHStreamOptionStreamType:@(VHInteractiveStreamTypeAudioAndVideo)}
 */
- (void)updateOptions:(NSDictionary*)options;

// 设置预览画面方向
- (BOOL)setDeviceOrientation:(UIDeviceOrientation)deviceOrientation;

/*
 * 画面填充模式
 * 默认 VHRenderViewScalingModeAspectFit
 */
@property (nonatomic, assign) VHRenderViewScalingMode scalingMode;

/*
 * 流类型 VHInteractiveStreamType
 */
@property (nonatomic, assign, readonly) int streamType;

/*
 * 流ID
 */
@property (nonatomic, copy, readonly) NSString      *streamId;

/*
 * 用户id
 */
@property (nonatomic, copy, readonly) NSString      *userId;

/*
 * 用户数据进入房间时传的数据
 */
@property (nonatomic, copy, readonly) NSString      *userData;

/*
 * 用户推流上麦时所传数据
 */
@property (nonatomic, copy, readonly) NSString      *streamAttributes;

/*
 * 设置的音视频参数
 */
@property (nonatomic, copy, readonly) NSDictionary  *options;

/*
 * 是否是本地相机view
 */
@property (nonatomic,assign,readonly) BOOL          isLocal;

/*
 * 是否在推流
 */
@property (nonatomic,assign) BOOL isPublish;

/*
 * 是否已订阅
 */
@property (nonatomic,assign) BOOL isSubscribe;

/*
 * 变音 注意只在本地相机renderview , 只能在推流成功后调用有效
 * 0 不变音 1是变音
 */
@property (nonatomic,assign) int voiceChangeType;

/*
 * 此流是否是支持大小流切换，支持几路切换
 * 1 一路流  2两路流
 */
@property (nonatomic, assign, readonly) int simulcastLayers;

/*
 * 此流的 流音视频开启情况
 * 数据结构 @{@"video":@(NO),@"audio":@(NO)} YES代表禁止，NO代表不禁止 可以用来更新ui状态
 */
@property (strong, nonatomic) NSDictionary * remoteMuteStream;//推流端
@property (nonatomic,strong, readonly) NSDictionary *muteStream;//订阅端 本地相机view 只有这一个属性

/*
 * 此流视频宽高
 */
@property (nonatomic,assign, readonly) CGSize videoSize;

/*
 * 设置推流时流中携带自定义数据 通过订阅view 的 streamAttributes 读取
 */
- (void)setAttributes:(NSString *_Nonnull)attributes;

/*
 * 是否有音频
 */
- (BOOL) hasAudio;

/*
 * 是否有视频
 */
- (BOOL) hasVideo;

/*
 * 关闭音频
 */
- (void) muteAudio;
- (void) muteAudioWithFinish:(FinishBlock _Nullable)finish;

/*
 * 取消关闭音频
 */
- (void) unmuteAudio;
- (void) unmuteAudioWithFinish:(FinishBlock _Nullable)finish;

/*
 * 关闭视频
 */
- (void) muteVideo;
- (void) muteVideoWithFinish:(FinishBlock _Nullable)finish;

/*
 * 取消关闭视频
 */
- (void) unmuteVideo;
- (void) unmuteVideoWithFinish:(FinishBlock _Nullable)finish;

/*
 * 切换前后摄像头
 */
- (BOOL) switchCamera;

/*
 * 流状态监听
 * 注意：如果开启了流状态监听，必须调用stopStats 停止监听，否则无法释放造成内存泄漏
 */
- (BOOL) startStatsWithCallback:(StatsCallback )callback;

/*
 * 停止流状态监听
 */
- (void) stopStats;

/**
 *  当前设备支持的分辨率列表 移动端不建议设置480*360分辨率以上推流
 */
+ (NSArray<NSString *> *)availableVideoResolutions;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
@end

