//
//  CameraEngine.h
//  Encoder Demo
//
//  Created by Geraint Davies on 19/02/2013.
//  Copyright (c) 2013 Vhall
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "OpenCONSTS.h"

@interface CameraEngineRtmp : NSObject
{
    
}
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
@property(nonatomic,strong,readonly)UIView * displayView;
/**
 *  视频采集的帧率 范围［10～30］
 */
@property(nonatomic,assign) int videoCaptureFPS;
/**
 *  代理
 */
@property(nonatomic,assign)id <CameraEngineRtmpDelegate> delegate;
/**
 *  视频分辨率 默认值是kGeneralViodeResolution 960*540
 */
@property(nonatomic,assign)VideoResolution videoResolution;
/**
 *  视频码率设置
 */
@property(nonatomic,assign)NSInteger videoBitRate;
/**
 *  音频码率设置
 */
@property(nonatomic,assign)NSInteger audioBitRate;
/**
 *  设置静音
 */
@property(assign,nonatomic)BOOL isMute;
/**
 *  判断用户使用是前置还是后置摄像头
 */
@property(nonatomic,assign,readonly)AVCaptureDevicePosition captureDevicePosition;

/**
 *  滤镜的回调，在此回调中做滤镜处理
 */
@property (nonatomic, strong) void (^captureVideoBuf)(CMSampleBufferRef sampleBuffer);
/**
 *  当前推流状态
 */
@property(assign,nonatomic,readonly)BOOL isPublishing;

//采集设备初始化
- (id)initWithOrgiation:(DeviceOrgiation)orgiation;

/**
 *  初始化 CaptureVideo
 *
 *  @param captureDevicePosition AVCaptureDevicePositionBack 代表后置摄像头 AVCaptureDevicePositionFront 代表前置摄像头
 *
 *  @return 是否成功
 */
- (BOOL)initCaptureVideo:(AVCaptureDevicePosition)captureDevicePosition;

//初始化音频
- (BOOL)initAudio;

//开始视频采集
- (BOOL)startVideoCapture;

//停止视频采集
- (BOOL)stopVideoCapture;

//开启音频采集;
- (BOOL)startAudioCapture;

//暂停音频采集
- (BOOL)pauseAudioCapture;

//停止音频采集,此方法调用了，就要在调用initAudio方法初始化
- (BOOL)stopAudioCapture;

/**
 *  切换摄像头
 *
 *  @param captureDevicePosition
 *
 *  @return 是否切换成功
 */
- (BOOL)swapCameras:(AVCaptureDevicePosition)captureDevicePosition;

//手动对焦
-(void)setFoucsFoint:(CGPoint)newPoint;

/**
 *  变焦
 *
 *  @param zoomSize 变焦的比例
 */
- (void)captureDeviceZoom:(CGFloat)zoomSize;

/**
 * 设置闪关灯的模式
 */
- (BOOL)setDeviceTorchModel:(AVCaptureTorchMode)captureTorchMode;

/**
 * 断网后重练
 */
-(BOOL)reconnect;

/**
 *  销毁初始化数据，同步销毁，如果感觉销毁太慢，可以开线程去销毁
 */
- (void)destoryObject;

/**
 *  断开推流的连接,注意app进入后台时要手动调用此方法
 */
- (void)disconnect;

/**
 *  推送视频数据
 *
 *  @param sampleBuffer YUV420sp数据
 */
- (void)pushVideoData:(CMSampleBufferRef)sampleBuffer;

//直播状态
-(void)liveStatus:(NSNotification*)notification;

@end
