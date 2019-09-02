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
@property (nonatomic,weak)id <VHallLivePublishDelegate> delegate;

/**
 *  设置静音，开始直播后设置有效
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
 *  开始发起直播
 *  @param param
 *  param[@"id"]           = 活动Id 必传
 *  param[@"access_token"] = 必传
 */
- (void)startLive:(NSDictionary*)param;;

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
 * 设置闪关灯的模式，开始直播后设置有效
 */
- (BOOL)setDeviceTorchModel:(AVCaptureTorchMode)captureTorchMode;

/**
 *  销毁初始化数据
 */
- (void)destoryObject;

/**
 设置音频增益大小，注意只有当开启噪音消除时可用，开始直播后设置有效
 
 @param size 音频增益的大小 [0.0,1.0]
 */
- (void)setVolumeAmplificateSize:(float)size;

/**
 *  本地相机预览填充模式，开始直播后设置有效
 */
- (void)setContentMode:(VHRTMPMovieScalingMode)contentMode;

/**
 *  美颜参数设置
 *  VHPublishConfig beautifyFilterEnable为YES时设置生效 根据具体使用情况微调
 *  @param beautify   磨皮   默认 2.0f  取值范围[1.0, 10.0]  10.0 正常图片没有磨皮
 *  @param brightness 亮度   默认 1.20f 取值范围[0.0, 2.0]  1.0 正常亮度
 *  @param saturation 饱和度 默认 1.0f  取值范围[0.0, 2.0]  1.0 正常饱和度
 *  @param sharpness  锐化   默认 0.5f  取值范围[-4.0，4.0] 0.0 正常锐化
 */
- (void)setBeautify:(CGFloat)beautify Brightness:(CGFloat)brightness Saturation:(CGFloat)saturation Sharpness:(CGFloat)sharpness;

@end



@protocol VHallLivePublishDelegate <NSObject>

@required

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
