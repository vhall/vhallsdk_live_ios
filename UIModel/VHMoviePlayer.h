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
@property(nonatomic,assign)int timeout;     //RTMP链接的超时时间 默认2秒，单位为毫秒
@property(nonatomic,assign)int reConnectTimes; //RTMP 断开后的重连次数 默认 2次
@property(nonatomic,assign)int bufferTime; //RTMP 的缓冲时间 默认 2秒 单位为秒 必须>0 值越小延时越小,卡顿增加
@property(assign,readonly)int realityBufferTime; //获取RTMP播放实际的缓冲时间
/**
 *  视频View的缩放比例 默认是自适应模式
 */
@property(nonatomic,assign)RTMPMovieScalingMode movieScalingMode;

/**
 *  初始化VHMoviePlayer对象
 *
 *  @param delegate
 *
 *  @return   返回VHMoviePlayer的一个实例
 */
- (instancetype)initWithDelegate:(id <VHMoviePlayerDelegate>)delegate;

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
-(void)stopPlay;

/**
 *  销毁播放器，异步销毁的
 */
- (void)destroyMoivePlayer;

//直播状态的通知
-(void)liveStatues:(NSNotification*)notification;

@end
