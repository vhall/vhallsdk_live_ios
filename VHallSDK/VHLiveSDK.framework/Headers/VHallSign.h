//
//  VHallSign.h
//  VHallSDK
//
//  Created by vhall on 17/2/14.
//  Copyright © 2017年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"

@protocol VHallSignDelegate <NSObject>
/**
 *  开始签到
 *
 *  开始签到消息
 */
- (void)startSign;

@optional
/**
 *  距签到结束剩余时间
 *
 *  距签到结束剩余时间
 */
- (void)signRemainingTime:(NSTimeInterval)remainingTime;
/**
 *  签到结束
 *
 *  签到结束消息
 */
- (void)stopSign;

@end

@interface VHallSign : VHallBasePlugin

@property (nonatomic, assign) id <VHallSignDelegate> delegate;
/**
 *  签到
 *  成功回调成功Block
 *  失败回调失败Block
 *  		失败Block中的字典结构如下：
 * 		key:code 表示错误码
 *		value:content 表示错误信息
 * 10010 	活动不存在
 * 10011 	不是该平台下的活动
 * 10017 	活动id 不能为空
 * 10807 	用户id不能为空
 * 10813 	签名ID不能为空
 * 10814 	用户名称不能为空
 * 10815 	当前用户已签到
 */
- (BOOL)signSuccess:(void(^)())success failed:(void (^)(NSDictionary* failedData))reslutFailedCallback;

/**
 *  取消签到
 *
 *  取消签到
 */
- (void)cancelSign;
@end
