//
//  VHallLivePublish.h
//  VHLivePlay
//
//  Created by liwenlong on 16/2/3.
//  Copyright © 2016年 vhall. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VHallConst.h"
#import "VHPublishConfig.h"

@protocol VHallLivePublishDelegate;
@interface VHallLivePublish : NSObject

/**
 *  用来显示摄像头拍摄内容的View
 */
@property (nonatomic,strong,readonly)UIView * displayView;

/**
 *  代理
 */
@property (nonatomic,assign)id <VHallLivePublishDelegate> delegate;

/**
 *  设置静音
 */
@property (assign,nonatomic)BOOL isMute;

/**
 *  判断用户使用是前置还是后置摄像头
 */
@property (nonatomic,assign,readonly)AVCaptureDevicePosition captureDevicePosition;

/**
 *  当前推流状态
 */
@property (assign,nonatomic,readonly)BOOL isPublishing;

/**
 *  初始化
 *  @param config  config参数
 */
- (instancetype)initWithConfig:(VHPublishConfig*)config;

//开始视频采集 显示视频预览
- (BOOL)startVideoCapture;

//停止视频采集 关闭视频预览
- (BOOL)stopVideoCapture;

/**
 *  开始发起直播 要在 initWithOrgiation initCaptureVideo initAudio startVideoCapture之后调用
 *  @param param
 *  param[@"id"]           = 活动Id 必传
 *  param[@"access_token"] = 必传
 */
- (void)startLive:(NSDictionary*)param;

/**
 * 结束直播
 * 与startLive成对出现，如果调用startLive，则需要调用stopLive以释放相应资源
 */
- (void)stopLive;

/**
 *  断开推流的连接,注意app进入后台时要手动调用此方法 回到前台要reconnect重新直播
 */
- (void)disconnect;

/**
 *  重连流
 */
-(void)reconnect;

/**
 *  切换摄像头
 *  @param captureDevicePosition
 *  @return 是否切换成功
 */
- (BOOL)swapCameras:(AVCaptureDevicePosition)captureDevicePosition;

//手动对焦
-(void)setFoucsFoint:(CGPoint)newPoint;
/**
 *  变焦
 *  @param zoomSize 变焦的比例
 */
- (void)captureDeviceZoom:(CGFloat)zoomSize;

/**
 * 设置闪关灯的模式
 */
- (BOOL)setDeviceTorchModel:(AVCaptureTorchMode)captureTorchMode;

/**
 *  销毁初始化数据
 */
- (void)destoryObject;

/**
 设置音频增益大小，注意只有当开启噪音消除时可用
 
 @param size 音频增益的大小 [0.0,1.0]
 */
- (void)setVolumeAmplificateSize:(float)size;

/**
 *  本地相机预览填充模式
 */
- (void)setContentMode:(VHRTMPMovieScalingMode)contentMode;

@end



@protocol VHallLivePublishDelegate <NSObject>

/**
 *  发起直播时的状态
 *  @param liveStatus 直播状态
 */
-(void)publishStatus:(VHLiveStatus)liveStatus withInfo:(NSDictionary*)info;
@optional
/**
 *  采集到第一帧的回调
 *  @param image 第一帧的图片
 */
-(void)firstCaptureImage:(UIImage*)image;
@end
