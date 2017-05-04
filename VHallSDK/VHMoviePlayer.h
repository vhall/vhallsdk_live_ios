//
//  VHMoviePlayer.h
//  MoviePlayer
//
//  Created by vhall on 15/6/18.
//  Copyright (c) 2015年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import "OpenCONSTS.h"

@class VHMoviePlayer;

@interface VHMoviePlayer : NSObject
{
    
}
@property(nonatomic,assign)id <VHMoviePlayerDelegate> delegate;
@property(nonatomic,strong,readonly)UIView * moviePlayerView;
@property(nonatomic,assign)int timeout;     //RTMP链接的超时时间 默认5秒，单位为毫秒
@property(nonatomic,assign)int reConnectTimes; //RTMP 断开后的重连次数 默认 2次
@property(nonatomic,assign)int bufferTime; //RTMP 的缓冲时间 默认 2秒 单位为秒 必须>0 值越小延时越小,卡顿增加
@property(assign,readonly)int realityBufferTime; //获取RTMP播放实际的缓冲时间
/**
 *  推流格式
 */
@property(assign,nonatomic)LiveFormat liveFormat;
/**
 *  视频View的缩放比例 默认是自适应模式
 */
@property(nonatomic,assign)RTMPMovieScalingMode movieScalingMode;

/**
 *  初始化VHMoviePlayer对象
 *
 *  @param delegate
 *
 *  @return  返回VHMoviePlayer的一个实例
 */
- (instancetype)initWithDelegate:(id <VHMoviePlayerDelegate>)delegate;
/**
 *  设置渲染视图 在startPlayWithUrl:之前设置，之后设置无效
 */
- (void)setRenderViewModel:(VHallRenderModel)renderModel;
/**
 *  设置监控日志的参数 注意参数是json string,开始直播前设置，之后设置无效
 *  param:{
 *  "vid":"直播发起者账号",
 *  "vfid":"直播发起者父账号",
 *  "guid":"观众唯一标识",
 *  "vtype":"直播视频类别",
 *  "topic":"活动话题"
 *  }
 *  return 0设置成功，-1是json解析失败
 */
- (int)setMonitorLogParam:(NSString*)param;
/**
 *  开始观看
 *
 *  @param urls rtmpUrls(注意数组中的地址是完整地址)
 */
- (void)startPlayWithUrl:(NSArray *)urls;

/**
 *  设置静音
 *
 *  @param mute 是否静音
 */
- (void)setMute:(BOOL)mute;

/**
 *  设置系统声音大小
 *
 *  @param size float  [0.0~1.0]
 */
+ (void)setSysVolumeSize:(float)size;

/**
 *  获取系统声音大小
 */
+ (float)getSysVolumeSize;

/**
 *  停止播放
 */
- (void)stopPlay;
/**
 *  清空视频剩余的最后一帧画面
 */
- (void)cleanLastFrame;
/**
 *  是否使用陀螺仪，仅VR播放时可用
 */
- (void)setUsingGyro:(BOOL)usingGyro;
/**
 *  设置视频布局的方向，仅VR模式可用,切要开启陀螺仪
 */
- (void)setUILayoutOrientation:(DeviceOrientation)orientation;

/**
 *  销毁播放器，异步销毁的
 */
- (void)destroyMoivePlayer;

//直播状态的通知
- (void)liveStatues:(NSNotification*)notification;

@end
