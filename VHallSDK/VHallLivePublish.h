//
//  VHallLivePublish.h
//  VHLivePlay
//
//  Created by liwenlong on 16/2/3.
//  Copyright © 2016年 vhall. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "VHallConst.h"

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


@interface VHallLivePublish : NSObject
/**
 *  推流连接的超时时间，单位为毫秒 默认5000
 */
@property (nonatomic,assign)int publishConnectTimeout;
/**
 *  推流断开重连的次数 默认为 5
 */
@property (nonatomic,assign)int publishConnectTimes;
/**
 *  用来显示摄像头拍摄内容的View
 */
@property (nonatomic,strong,readonly)UIView * displayView;
/**
 *  视频采集的帧率 范围［10～30］
 */
@property (nonatomic,assign)int videoCaptureFPS;
/**
 *  代理
 */
@property (nonatomic,assign)id <VHallLivePublishDelegate> delegate;
/**
 *  视频分辨率 默认值是kGeneralViodeResolution 960*540
 */
@property (nonatomic,assign)VHVideoResolution videoResolution;
/**
 *  视频码率设置
 */
@property (nonatomic,assign)NSInteger videoBitRate;
/**
 *  音频码率设置
 */
@property (nonatomic,assign)NSInteger audioBitRate;
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
 * 是否开启噪声消除，默认开启，最高支持32k的音频采样率,直播前设置，当采样率大于32k时，自动关闭噪声消除
 * 注：开始直播后调用无效
 */
@property(assign,nonatomic)BOOL isOpenNoiseSuppresion;


//初始化
- (id)initWithOrientation:(VHDeviceOrientation)orientation;
/**
 *  初始化 CaptureVideo
 *  @param captureDevicePosition AVCaptureDevicePositionBack 代表后置摄像头 AVCaptureDevicePositionFront 代表前置摄像头
 *  @return 是否成功
 */
- (BOOL)initCaptureVideo:(AVCaptureDevicePosition)captureDevicePosition;

//初始化音频
- (BOOL)initAudio;

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

@end
