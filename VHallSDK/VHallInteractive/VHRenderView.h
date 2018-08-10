//
//  VHRenderView.h
//  VHInteractive
//
//  Created by vhall on 2018/4/18.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const VHVideoWidthKey;        //推流视频宽度 默认192
extern NSString * const VHVideoHeightKey;       //推流视频高度 默认144
extern NSString * const VHVideoFpsKey;          //推流视频帧率 默认30
extern NSString * const VHMaxVideoBitrateKey;   //推流最大码率 默认200
extern NSString * const VHStreamOptionStreamType;//推流类型

/*
 * 摄像头及推流参数设置
 */
typedef NS_ENUM(NSInteger, VHPushType) {
    VHPushTypeNone, //未知，使用默认设置
    VHPushTypeSD,   //默认192x144
    VHPushTypeHD,   //352x288
    VHPushTypeUHD,  //480x360
    VHPushTypeCUSTOM//此版本暂不支持 等同于 VHPushTypeSD
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
    VHInteractiveStreamTypeScreen          = 3,//共享桌面
    VHInteractiveStreamTypeFile            = 4 //插播
};

/*
 * 流状态监听回调block定义
 */
typedef void(^StatsCallback)(NSString* mediaType, long kbps, NSDictionary<NSString *, NSString *> * values);


@interface VHRenderView : UIView

/*
 * 创建本地摄像头view
 * 默认参数 使用服务器配置参数
 */
- (instancetype)initCameraViewWithFrame:(CGRect)frame;
/*
 * 创建本地摄像头view 使用自定义 视频参数
 * type       type 推流清晰度设置
 * @param options   type = VHPushTypeCUSTOM 时有效   @{VHVideoWidthKey:@(192),VHVideoHeightKey:@(144),VHVideoFpsKey:@(30),VHMaxVideoBitrateKey:@(200),VHStreamOptionStreamType:@(2)}
 */
- (instancetype)initCameraViewWithFrame:(CGRect)frame pushType:(VHPushType)type options:(NSDictionary*)options;

/*
 * 创建本地摄像头view 使用自定义 视频参数
 * @param options  如： @{VHVideoWidthKey:@(192),VHVideoHeightKey:@(144),VHVideoFpsKey:@(30),VHMaxVideoBitrateKey:@(200),VHStreamOptionStreamType:@(2)}
 */
- (instancetype)initCameraViewWithFrame:(CGRect)frame options:(NSDictionary*)options;

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
 * 设置的音视频参数
 */
@property (nonatomic, copy, readonly) NSDictionary  *options;

/*
 * 是否是本地相机view
 */
@property (nonatomic,assign,readonly) BOOL          isLocal;

/*
 * 是否有音频
 */
- (BOOL) hasAudio;

/*
 * 是否有视频
 */
- (BOOL) hasVideo;

/*
 * 静音
 */
- (void) muteAudio;

/*
 * 取消静音
 */
- (void) unmuteAudio;

/*
 * 关闭视频
 */
- (void) muteVideo;

/*
 * 取消关闭视频
 */
- (void) unmuteVideo;

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

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
@end

