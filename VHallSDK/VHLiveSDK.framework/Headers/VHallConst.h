//
//  VHallConst.h
//  VHallSDK
//
//  Created by vhall on 17/08/15.
//  Copyright © 2017年 vhall. All rights reserved.
//

#ifndef VHallConst_h
#define VHallConst_h

//日志类型
typedef NS_ENUM(NSInteger,VHLogType) {
    VHLogType_OFF   = 0,   //关闭日志 默认设置
    VHLogType_ON    = 1,   //开启日志
    VHLogType_ALL   = 2,   //开启全部日志
};

#pragma mark - 发起端常量定义

/**
 * 发直播状态
 *
 * 当kLiveStatusPushConnectError时，content代表出错原因 及具体错误码查看下方错误码定义
 */
typedef NS_ENUM(NSInteger,VHLiveStatus)
{
    VHLiveStatusNone                    = -1,
    VHLiveStatusPushConnectSucceed      = 0,    //直播连接成功
    VHLiveStatusPushConnectError        = 1,      //直播连接失败
    VHLiveStatusParamError              = 6,            //参数错误
    VHLiveStatusSendError               = 8,             //直播发送数据错误
    VHLiveStatusUploadSpeed             = 9,           //直播上传速率
    VHLiveStatusAudioRecoderError       = 24,     //音频采集失败，提示用户查看权限或者重新推流，切记此事件会回调多次，直到音频采集正常为止
    VHLiveStatusUploadNetworkException  = 14,//发起端网络环境差
    VHLiveStatusUploadNetworkOK         = 15,       //发起端网络环境恢复正常
    VHLiveStatusGetUrlError             = 99,           //获取推流地址失败
};

/**
 * 摄像头取景方向 迁移到 VHPublishConfig.h
 *
typedef NS_ENUM(NSInteger,VHDeviceOrientation)
{
    VHDevicePortrait                    = 0,    //摄像头在上边
    VHDeviceLandSpaceLeft               = 1,    //摄像头在左边
    VHDeviceLandSpaceRight              = 2     //摄像头在右边 暂不支持
};
*/
/**
 * 推流视频分辨率 迁移到 VHPublishConfig.h
 *
typedef NS_ENUM(NSInteger,VHVideoResolution)
{
    VHLowVideoResolution                = 0,    //低分边率  352*288
    VHGeneralVideoResolution            = 1,    //普通分辨率 640*480
    VHHVideoResolution                  = 2,    //高分辨率  960*540
    VHHDVideoResolution                 = 3     //超高分辨率 1280*720
};
 */
#pragma mark - 观看端常量定义
/**
 * 观看端错误事件
 * 当VHLivePlayGetUrlError时， content代表出错原因 及具体错误码查看下方错误码定义
 */
typedef NS_ENUM(NSInteger,VHSaasLivePlayErrorType)
{
    VHSaasLivePlayErrorNone                 = -1,
    VHSaasLivePlayParamError                = 6,      //参数错误
    VHSaasLivePlayRecvError                 = 7,       //接受数据错误
    VHSaasLivePlayCDNConnectError           = 3, //CDN链接失败
    VHSaasVodPlayError                      = 98,     //点播播放器错误信息
    VHSaasLivePlayGetUrlError               = 99,     //获取活动信息失败
};

/**
 * 直播播放器视频填充模式，回放使用MPMoviePlayerController 自带填充模式设置
 */
typedef NS_ENUM(NSInteger,VHRTMPMovieScalingMode)
{
    VHRTMPMovieScalingModeNone          = 0,    //填充满video显示view
    VHRTMPMovieScalingModeAspectFit     = 1,    //在保持长宽比的前提下，缩放图片，使得图片在容器内完整显示出来 可能留有黑边
    VHRTMPMovieScalingModeAspectFill    = 2,    //在保持长宽比的前提下，缩放图片，使图片充满容器
};

/**
 * 直播流类型  迁移到 VHPublishConfig.h
 
typedef NS_ENUM(NSInteger,VHStreamType)
{
    VHStreamTypeNone                    = 0,    //未知
    VHStreamTypeVideoAndAudio           = 1,    //音视频
    VHStreamTypeOnlyVideo               = 2,    //纯视频无音频
    VHStreamTypeOnlyAudio               = 3,    //纯音频
};
 */

/**
 *  视频渲染模式
 */
typedef NS_ENUM(NSInteger,VHRenderModel){
    VHRenderModelNone                   = 0,
    VHRenderModelOrigin                 = 1,    //普通视图的渲染
    VHRenderModelDewarpVR               = 2,    //VR视图的渲染
};

/**
 *  播放器状态 直播状态 回放状态由于用户创建的 MPMoviePlayerController 实例获取
 */
typedef NS_ENUM(NSInteger,VHPlayerState) {
    VHPlayerStateStoped                 = 0,    //停止   可调用startPlay: startPlayback: 状态转为VHallPlayerStateStarting
    VHPlayerStateStarting               = 1,    //启动中
    VHPlayerStatePlaying                = 2,    //播放中 可调用stopPlay pausePlay 状态转为VHallPlayerStateStoped/VHallPlayerStatePaused
    VHPlayerStateStreamStoped           = 3,    //直播流停止 暂停pausePlay/流连接错误触发 可调用stopPlay reconnectPlay状态转为VHallPlayerStateStoped/VHallPlayerStatePlaying
    VHPlayerStatePause                  = 4,    //回放暂停状态
};

/**
 *  活动布局模式
 */
typedef NS_ENUM(NSInteger,VHMovieVideoPlayMode) {
    VHMovieVideoPlayModeNone            = 0,    //不存在
    VHMovieVideoPlayModeMedia           = 1,    //单视频
    VHMovieVideoPlayModeTextAndVoice    = 2,    //文档＋声音
    VHMovieVideoPlayModeTextAndMedia    = 3,    //文档＋视频
    VHMovieVideoPlayModeVoice           = 4,    //单音频
};

/**
 *  直播视频清晰度
 */
typedef NS_ENUM(NSInteger,VHMovieDefinition) {
    VHMovieDefinitionOrigin             = 0,    //原画
    VHMovieDefinitionUHD                = 1,    //超高清
    VHMovieDefinitionHD                 = 2,    //高清
    VHMovieDefinitionSD                 = 3,    //标清
    VHMovieDefinitionAudio              = 4,    //纯音频
};

/**
 *  活动状态
 */
typedef NS_ENUM(NSInteger,VHMovieActiveState) {
    VHMovieActiveStateNone              = 0,
    VHMovieActiveStateLive              = 1,    //直播
    VHMovieActiveStateReservation       = 2,    //预约
    VHMovieActiveStateEnd               = 3,    //结束
    VHMovieActiveStateReplay            = 4,    //回放or点播
};

/**
 *  活动互动状态
 */
typedef NS_ENUM(NSInteger,VHInteractiveState) {
    VHInteractiveStateWithOut           = 0,   //当前不允许互动
    VHInteractiveStateHave              = 1,   //当前允许互动
};

/**
 *  互动房间设备操作事件类型(1麦克风，2摄像头)
 */
typedef NS_ENUM(NSInteger,VHInteractiveEvent) {
    VHInteractiveEventMic = 1,
    VHInteractiveEventCamera
};


#endif /* VHallConst_h */

//错误信息info中 错误码code 及 content错误信息

/*
以下是推流连接失败错误码
4001 | 握手失败
4002 | 链接vhost/app失败
4003 | 网络断开 （预留，暂时未使用）
4004 | 无效token
4005 | 不再白名单中
4006 | 在黑名单中
4007 | 流已经存在
4008 | 流被禁掉 （预留，暂时未使用）
4009 | 不支持的视频分辨率（预留，暂时未使用）
4010 | 不支持的音频采样率（预留，暂时未使用）
4011 | 欠费

以下是所有网络接口请求错误的错误码及错误内容
10010 | 活动不存在
10011 | 不是该平台下的活动
10017 | 活动id 不能为空
10030 | 身份验证出错
10040 | 验证出错
10046 | 当前活动已结束
10047 | 您已被踢出，请联系活动组织者
10048 | 活动现场太火爆，已超过人数上限
10049 | 访客数据信息不全
10401 | 活动开始失败
10401 | 活动结束失败
10402 | 当前活动ID错误
10403 | 活动不属于自己
10404 | KEY值验证出错
10405 | 录播不存在
10405 | 微吼用户ID错误
10407 | 查询数据为空
10408 | 当前活动非直播状态
10409 | 参会ID不能为空
10410 | 抽奖ID不能为空
10410 | 活动开始时间不存在
10410 | 用户信息不存在
10410 | 第三方用户对象不存在 【新】
10411 | 用户名称不能为空
10411 | 用户套餐余额不足    【新】
10412 | 用户手机不能为空
10412 | 直播中，获取失败
10413 | 获取条目最多为50
10501 | 用户不存在
10502 | 登陆密码不正确
10806 | 内容不能为空
10807 | 用户id不能为空
10808 | 当前用户未参会
 
以下是所有业务逻辑错误
20001 | AppKey 或 SecretKey 未设置
20002 | 后台接口api错误
20003 | 当前活动未开始
20004 | 当前活动已结束
20005 | 当前活动正在直播
20006 | 当前活动已为回放/点播
20007 | 当前活动状态未知
20008 | 活动id为空
20009 | 未参会
20010 | 未登录状态下email name为空
20011 | 发直播token为空
20012 | 结束活动失败
20013 | 未登录
20014 | 未获取到抽奖ID
20015 | 未获取到签到ID
20016 | 签到已结束
20017 | 未获取到问卷ID
20018 | 请求参数错误
20019 | 正在结束活动请稍等
20020 | 消息中含有禁用关键字
 
以下是网络错误信息
30001 | 请求参数错误
30002 | 网络错误
30003 | 请求错误
30004 | 返回错误
30005 | Json格式错误
30006 | 请求返回错误
*/



