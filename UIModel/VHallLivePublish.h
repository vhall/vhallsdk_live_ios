//
//  VHallLivePublish.h
//  VHLivePlay
//
//  Created by liwenlong on 16/2/3.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import "CameraEngineRtmp.h"

@interface VHallLivePublish : CameraEngineRtmp

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

//停止音频采集
- (BOOL)stopAudioCapture;

/**
 *  开始发起直播
 *
 *  @param param
 *  param[@"id"]           = 活动Id 必传
 *  param[@"access_token"] = 必传
 *
 */
- (void)startLive:(NSDictionary*)param;

/**
 * 停止直播
 * 与startLive成对出现，如果调用startLive，则需要调用stopLive以释放相应资源
 */
- (void)stopLive;

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

//重连流
-(void)reconnect;

/**
 *  销毁初始化数据
 */
- (void)destoryObject;

/**
 *  断开推流的连接,注意app进入后台时要手动调用此方法
 */
- (void)disconnect;


@end
