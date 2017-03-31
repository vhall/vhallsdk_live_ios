//
//  VHallApi.h
//  VHallSDK
//
//  Created by vhall on 16/8/23.
//  Copyright © 2016年 vhall. All rights reserved.
//

#ifndef VHallApi_h
#define VHallApi_h
#import "VHallLivePublish.h"
#import "VHallMoviePlayer.h"
#import "VHallChat.h"
#import "VHallQAndA.h"
#import "VHallLottery.h"
#import "VHallMsgModels.h"
#import "VHallComment.h"
#import "VHallSign.h"
#import "VHallSurvey.h"

@interface VHallApi : NSObject 

/*！
 * 用来获得当前sdk的版本号
 * return 返回sdk版本号
 */
+(NSString *) sdkVersion;

/*！
 *  注册app
 *  需要在 application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 中调用
 *  @param appKey       vhall后台注册生成的appkey
 *  @param secretKey    vhall后台注册生成的appsecretKey
 *
 */
+ (void)registerApp:(NSString *)appKey SecretKey:(NSString *)secretKey;

#pragma mark - 使用用户系统相关功能需登录SDK
/*!
 *  登录 (如使用聊天，问答等功能必须登录)
 *
 *  @param aAccount         账号  需服务器调用微吼注册API 注册该用户账号密码
 *  @param aPassword        密码
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 */
+ (void)loginWithAccount:(NSString *)aAccount
                password:(NSString *)aPassword
                success:(void (^)())aSuccessBlock
                failure:(void (^)(NSError *error))aFailureBlock;

/*!
 *  退出当前账号
 *
 *  @param aSuccessBlock    成功的回调
 *  @param aFailureBlock    失败的回调
 *
 *  @result 错误信息
 */
+ (void)logout:(void (^)())aSuccessBlock
              failure:(void (^)(NSError *error))aFailureBlock;

/*!
 *  获取当前登录状态
 *
 *  @result 当前是否已登录
 */
+ (BOOL)isLoggedIn;

/*!
 *  获取当前登录用户账号
 *
 *  @result 前登录用户账号
 */
+ (NSString *)currentAccount;

/*!
 *  获取当前登录用户id
 *
 *  @result 前登录用户id
 */
+ (NSString *)currentUserID;



/*!
 *  获取当前登录用户头像
 *
 *  @result 当前登陆用户头像地址
 */
+(NSString*)currentUserHeadUrl;


/*!
 *  获取当前登录用户昵称
 *
 *  @result 当前登陆用户昵称
 */
+(NSString*)currentUserNickName;

//以下是所有接口请求错误的错误码及错误内容
/*
| 10010 | 活动不存在                     |
| 10011 | 不是该平台下的活动             |
| 10017 | 活动id 不能为空                |
| 10030 | 身份验证出错                   |
| 10040 | 验证出错                       |
| 10046 | 当前活动已结束                 |
| 10046 | 当前活动已结束                 |
| 10047 | 您已被踢出，请联系活动组织者   |
| 10048 | 活动现场太火爆，已超过人数上限 |
| 10049 | 访客数据信息不全               |
| 10401 | 活动开始失败                   |
| 10401 | 活动结束失败                   |
| 10402 | 当前活动ID错误                 |
| 10403 | 活动不属于自己                 |
| 10404 | KEY值验证出错                  |
| 10405 | 录播不存在                     |
| 10405 | 微吼用户ID错误                 |
| 10407 | 查询数据为空                   |
| 10408 | 当前活动非直播状态             |
| 10409 | 参会ID不能为空                 |
| 10409 | 参会信息不存在                 |
| 10410 | 抽奖ID不能为空                 |
| 10410 | 活动开始时间不存在             |
| 10410 | 活动开始时间不存在             |
| 10410 | 用户信息不存在                 |
| 10410 | 第三方用户对象不存在 【新】    |
| 10411 | 用户名称不能为空               |
| 10411 | 用户套餐余额不足    【新】     |
| 10412 | 用户手机不能为空               |
| 10412 | 直播中，获取失败               |
| 10413 | 获取条目最多为50               |
| 10501 | 用户不存在                     |
| 10502 | 登陆密码不正确                 |
| 10806 | 内容不能为空                   |
| 10807 | 用户id不能为空                 |
| 10808 | 当前用户未参会                 |
*/

@end

#endif /* VHApi_h */
