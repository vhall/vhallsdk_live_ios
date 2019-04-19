//
//  VHallMoviePlayer.h
//  VHLivePlay
//
//  Created by liwenlong on 16/2/16.
//  Copyright © 2016年 vhall. All rights reserved.
//
#import <MediaPlayer/MPMoviePlayerController.h>
#import "VHallConst.h"

@protocol VHallMoviePlayerDelegate;
@interface VHallMoviePlayer : NSObject

@property(nonatomic,assign)id <VHallMoviePlayerDelegate> delegate;
@property(nonatomic,strong,readonly)UIView * moviePlayerView;
@property(nonatomic,assign)int timeout;                         //链接的超时时间 默认6000毫秒，单位为毫秒  MP4点播 最小10000毫秒
//@property(nonatomic,assign)int reConnectTimes;                //RTMP 断开后的重连次数 默认 2次
@property(nonatomic,assign)int bufferTime;                      //RTMP 的缓冲时间 默认 6秒 单位为秒 必须>0 值越小延时越小,卡顿增加
@property(assign,readonly)int realityBufferTime;                //获取RTMP播放实际的缓冲时间
@property(nonatomic,assign,readonly)VHPlayerState playerState;  //播放器状态

//点播
@property (nonatomic, readonly) NSTimeInterval          duration;           //视频时长
@property (nonatomic, readonly) NSTimeInterval          playableDuration;   //可播放时长
@property (nonatomic, assign)   NSTimeInterval          currentPlaybackTime;//当前播放时间点

/**
 *  视频View的缩放比例 默认是自适应模式
 */
@property(nonatomic,assign)VHRTMPMovieScalingMode movieScalingMode;

/**
 *  当前视频观看模式 观看直播允许切换观看模式(回放没有)
 */
@property(nonatomic,assign)VHMovieVideoPlayMode playMode;

/**
 *  设置默认播放的清晰度 默认原画
 */
@property(nonatomic,assign)VHMovieDefinition defaultDefinition;

/*! @brief 直播视频清晰度 （只有直播有效）
 *
 *  @return 返回当前视频清晰度 如果和设置的不一致 设置无效保存原有清晰度 设置成功刷新直播，有可能设置失败，请再获取definition查看设置状态
 *   当前视频清晰度 观看直播允许切换清晰度(回放没有) 默认是defaultDefinition
 */
@property(nonatomic,assign)VHMovieDefinition curDefinition;

/**
 *   注意 已废弃内部会自行设置
 *   设置渲染视图 在VideoPlayMode:isVrVideo: 中设置 默认VHRenderModelNone 必须设置否则会出现黑屏
 */
//@property(nonatomic,assign)VHRenderModel renderViewModel;

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
 *  param[@"name"]  = 如已登录可以不传
 *  param[@"email"] = 如已登录可以不传
 *  param[@"pass"]  = 活动如果有K值或密码需要传
 *
 */
-(BOOL)startPlay:(NSDictionary*)param;

/**
 *  发送 申请上麦/取消申请 消息
 *  @param type 1举手，0取消举手
 */
- (BOOL)microApplyWithType:(NSInteger)type;

/**
 *  发送 申请上麦/取消申请 消息
 *  @param type 1举手，0取消举手
 *  @param finishBlock 消息发送结果
 */
- (BOOL)microApplyWithType:(NSInteger)type finish:(void(^)(NSError *error))finishBlock;

/**
 *  收到邀请后 是否同意上麦
 *  @param type 1接受，2拒绝，3超时失败
 *  @param finishBlock 结果回调
 */
- (BOOL)replyInvitationWithType:(NSInteger)type finish:(void(^)(NSError *error))finishBlock;


/**
 *  观看回放/点播视频
 *
 *  @param param
 *  param[@"id"]    = 活动Id 必传
 *  param[@"name"]  = 如已登录可以不传
 *  param[@"email"] = 如已登录可以不传
 *  param[@"pass"]  = 活动如果有K值或密码需要传
 *
 */
-(BOOL)startPlayback:(NSDictionary*)param;

/**
 *  暂停播放 （如果是直播，等同于stopPlay）
 */
-(void)pausePlay;

/**
 *  播放出错/pausePlay后恢复播放
 *  @return NO 播放器不是暂停状态 或者已经结束
 */
-(BOOL)reconnectPlay;

/**
 *  停止播放
 */
-(void)stopPlay;

/**
 *  设置静音
 *
 *  @param mute 是否静音
 */
- (void)setMute:(BOOL)mute;


/**
 *  重连socket
 */
-(BOOL)reconnectSocket;
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
 *  销毁播放器
 */
- (void)destroyMoivePlayer;

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
- (void)setUILayoutOrientation:(UIDeviceOrientation)orientation;

/**
 *  更新DLNA 播放地址
 *  参数为 dlnaControl对象
 */
- (void)dlnaMappingObject:(id)DLNAobj;
@end


@protocol VHallMoviePlayerDelegate <NSObject>
@optional
/**
 *  播放连接成功
 */
- (void)connectSucceed:(VHallMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  缓冲开始回调
 */
- (void)bufferStart:(VHallMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  缓冲结束回调
 */
-(void)bufferStop:(VHallMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  下载速率的回调
 *
 *  @param moviePlayer
 *  @param info        下载速率信息 单位kbps
 */
- (void)downloadSpeed:(VHallMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  Streamtype
 *
 *  @param moviePlayer moviePlayer
 *  @param info        info
 */
- (void)recStreamtype:(VHallMoviePlayer*)moviePlayer info:(NSDictionary*)info;

/**
 *  播放时错误的回调
 *
 *  @param livePlayErrorType 直播错误类型
 */
- (void)playError:(VHLivePlayErrorType)livePlayErrorType info:(NSDictionary*)info;

/**
 *  获取视频活动状态
 *
 *  @param playMode  视频活动状态
 */
- (void)ActiveState:(VHMovieActiveState)activeState;

/**
 *  获取当前视频播放模式
 *
 *  @param playMode  视频播放模式
 */
- (void)VideoPlayMode:(VHMovieVideoPlayMode)playMode isVrVideo:(BOOL)isVrVideo;

/**
 *  获取当前视频支持的所有播放模式
 *
 *  @param playModeList 视频播放模式列表
 */
- (void)VideoPlayModeList:(NSArray*)playModeList;

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

/**
 *  包含文档 获取翻页图片路径
 *
 *  @param changeImage  图片更新
 */
- (void)PPTScrollNextPagechangeImagePath:(NSString*)changeImagePath;

/**
 *  画笔
 *  @param docList    PPT 画笔
 *  @param boardList  白板画笔
 */
- (void)docHandList:(NSArray*)docList whiteBoardHandList:(NSArray*)boardList;

/**
 *  是否允许举手申请上麦 回调。
 *  @param player         VHallMoviePlayer实例
 *  @param isInteractive  当前活动是否支持互动功能
 *  @param state          主持人是否允许举手
 */
- (void)moviePlayer:(VHallMoviePlayer *)player isInteractiveActivity:(BOOL)isInteractive interactivePermission:(VHInteractiveState)state;

/**
 *  主持人是否同意上麦申请回调
 *  @param player       VHallMoviePlayer实例
 *  @param attributes   参数 收到的数据
 *  @param error        错误回调 nil 同意上麦 不为空为不同意上麦
 */
- (void)moviePlayer:(VHallMoviePlayer *)player microInvitationWithAttributes:(NSDictionary *)attributes error:(NSError *)error;

/**
 *  主持人邀请你上麦
 *  @param player       VHallMoviePlayer实例
 *  @param attributes   参数 收到的数据
 */
- (void)moviePlayer:(VHallMoviePlayer *)player microInvitation:(NSDictionary *)attributes;

/**
 *  被踢出
 *
 *  @param player player
 *  @param isKickout 被踢出 取消踢出后需要重新进入
 */
- (void)moviePlayer:(VHallMoviePlayer*)player isKickout:(BOOL)isKickout;
#pragma mark - 点播
/**
 *  statusDidChange
 *
 *  @param player player
 *  @param state  VHPlayerState
 */
- (void)moviePlayer:(VHallMoviePlayer *)player statusDidChange:(int)state;

/**
 *  currentTime
 *
 *  @param player player
 *  @param currentTime 回放当前播放时间点 1s 回调一次可用于UI刷新
 */
- (void)moviePlayer:(VHallMoviePlayer*)player currentTime:(NSTimeInterval)currentTime;

@end
