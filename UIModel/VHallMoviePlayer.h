//
//  VHallMoviePlayer.h
//  VHLivePlay
//
//  Created by liwenlong on 16/2/16.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import "VHMoviePlayer.h"
/**
 *  视频播放模式
 */
typedef NS_ENUM(NSInteger,VHallMovieVideoPlayMode) {
    VHallMovieVideoPlayModeNone = 0,         //不存在
    VHallMovieVideoPlayModeMedia = 1,        //单视频
    VHallMovieVideoPlayModeTextAndVoice = 2, //文档＋声音
    VHallMovieVideoPlayModeTextAndMedia = 3, //文档＋视频
    VHallMovieVideoPlayModeVoice = 4,        //单音频
};

/**
 *  直播视频清晰度
 */
typedef NS_ENUM(NSInteger,VHallMovieDefinition) {
    VHallMovieDefinitionOrigin = 0,     //原画
    VHallMovieDefinitionUHD = 1,        //超高清
    VHallMovieDefinitionHD = 2,         //高清
    VHallMovieDefinitionSD = 3,         //标清
    VHallMovieDefinitionAudio = 4,      //无视频
};

/**
 *  活动状态
 */
typedef NS_ENUM(NSInteger,VHallMovieActiveState) {
    VHallMovieActiveStateNone = 0 ,
    VHallMovieActiveStateLive = 1,           //直播
    VHallMovieActiveStateReservation = 2,    //预约
    VHallMovieActiveStateEnd = 3,            //结束
    VHallMovieActiveStateReplay = 4,         //回放
};



@class VHallMoviePlayer;

@protocol VHallMoviePlayerDelegate <NSObject, VHMoviePlayerDelegate>
@optional

/**
 *  包含文档 获取翻页图片路径
 *
 *  @param changeImage  图片更新
 */
- (void)PPTScrollNextPagechangeImagePath:(NSString*)changeImagePath;

/**
 *  画笔
 *
 *
 */
- (void)docHandList:(NSArray*)docList whiteBoardHandList:(NSArray*)boardList;

/**
 *  获取当前视频播放模式
 *
 *  @param playMode  视频播放模式
 */
- (void)VideoPlayMode:(VHallMovieVideoPlayMode)playMode;
/**
 *  获取当前视频支持的所有播放模式
 *
 *  @param playModeList 视频播放模式列表
 */
- (void)VideoPlayModeList:(NSArray*)playModeList;
/**
 *  获取视频活动状态
 *
 *  @param playMode  视频活动状态
 */
- (void)ActiveState:(VHallMovieActiveState)activeState;
/**
 *  该直播支持的清晰度列表
 *
 *  @param definitionList  支持的清晰度列表
 */
- (void)VideoDefinitionList:(NSArray*)definitionList;
/**
 *  直播结束消息
 *
 *  直播结束消息
 */
- (void)LiveStoped;

/**
 *  播主发布公告
 *
 *  播主发布公告消息
 */
- (void)Announcement:(NSString*)content publishTime:(NSString*)time;
@end
@interface VHallMoviePlayer : VHMoviePlayer

/**
 *  当前视频观看模式 观看直播允许切换观看模式(回放没有)
 */
@property(nonatomic,assign)VHallMovieVideoPlayMode playMode;

/**
 *  当前视频清晰度 观看直播允许切换清晰度(回放没有) 默认是原画播放
 */
@property(nonatomic,assign,readonly)VHallMovieDefinition curDefinition;

/*! @brief 设置直播视频清晰度 （只有直播有效）
 *
 *  @return 返回当前视频清晰度 如果和设置的不一致 设置无效保存原有清晰度 设置成功刷新直播
 */

- (VHallMovieDefinition)setDefinition:(VHallMovieDefinition)definition;


/**
 *  初始化VHMoviePlayer对象
 *
 *  @param delegate
 *
 *  @return   返回VHMoviePlayer的一个实例
 */
- (instancetype)initWithDelegate:(id <VHallMoviePlayerDelegate>)delegate;

/**
 *  观看直播视频
 *
 *  @param param
 *  param[@"id"]    = 活动Id 必传
 *  param[@"name"]  = 如未登录SDK要传
 *  param[@"email"] = 如未登录SDK要传
 *  param[@"pass"]  = 活动如果有K值或密码需要传
 *
 */
-(BOOL)startPlay:(NSDictionary*)param;


/**
 *  重连直播视频(直播功能)
 *
 *  @param param
 *  param[@"id"]    = 活动Id 必传
 *  param[@"name"]  = 如未登录SDK要传
 *  param[@"email"] = 如未登录SDK要传
 *  param[@"pass"]  = 活动如果有K值或密码需要传
 *
 */
-(BOOL)reconnectPlay:(NSDictionary*)param;
/**
 *  观看回放视频   (仅HLS可用)
 *
 *  @param param
 *  param[@"id"]    = 活动Id 必传
 *  param[@"name"]  = 如未登录SDK要传
 *  param[@"email"] = 如未登录SDK要传
 *  param[@"pass"]  = 活动如果有K值或密码需要传
 *
 *  @param moviePlayerController MPMoviePlayerController 对象
 */
-(void)startPlayback:(NSDictionary*)param moviePlayer:(MPMoviePlayerController *)moviePlayerController;

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
 *  暂停直播播放(直播功能)
 */
-(void)pausePlay;

/**
 *  销毁播放器
 */
- (void)destroyMoivePlayer;


/**
 *  观看直播视频   (仅HLS可用) 已弃用 不再维护
 *
 *  @param param
 *  param[@"id"]    = 活动Id 必传
 *  param[@"name"]  = 如未登录SDK要传
 *  param[@"email"] = 如未登录SDK要传
 *  param[@"pass"]  = 活动如果有K值或密码需要传）
 *
 *  @param moviePlayerController MPMoviePlayerController 对象
 */
-(void)startPlay:(NSDictionary*)param moviePlayer:(MPMoviePlayerController *)moviePlayerController __attribute__ ((deprecated));
@end
