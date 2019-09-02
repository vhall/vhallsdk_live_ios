//
//  VHallChat.h
//  VHallSDK
//
//  Created by Ming on 16/8/23.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"

@protocol VHallChatDelegate <NSObject>
@optional
/**
 * 收到上下线消息
 */
- (void)reciveOnlineMsg:(NSArray *)msgs;
/**
 * 收到聊天消息
 */
- (void)reciveChatMsg:(NSArray *)msgs;
/**
 * 收到自定义消息
 */
- (void)reciveCustomMsg:(NSArray *)msgs;

/**
 * 收到被禁言/取消禁言
 */
- (void)forbidChat:(BOOL)forbidChat;

/**
 * 收到全体禁言/取消全体禁言
 */
- (void)allForbidChat:(BOOL)allForbidChat;

@end

@interface VHallChat : VHallBasePlugin

@property (nonatomic, assign) id <VHallChatDelegate> delegate;

/**
 * 是否被禁言
 */
@property (nonatomic, assign,readonly) BOOL isSpeakBlocked;

/**
 * 发送聊天内容
 * 在进入直播活动后调用
 * 成功回调成功Block
 * 失败回调失败Block
 * 		失败Block中的字典结构如下：
 * 		key:code 表示错误码
 *		value:content 表示错误信息
 */
- (void)sendMsg:(NSString *)msg success:(void(^)(void))success failed:(void (^)(NSDictionary* failedData))reslutFailedCallback;


/**
 * 获取聊天历史记录
 * 在进入直播活动后调用
 * @param showAll               NO 只显示当次直播聊天最多为20条, YES显示所有聊天最条为20条
 * @param success               成功回调成功Block 返回聊天历史记录
 * @param reslutFailedCallback  失败回调失败Block
 *                              失败Block中的字典结构如下：
 *                              key:code 表示错误码
 *                              value:content 表示错误信息
 */
- (void)getHistoryWithType:(BOOL)showAll success:(void(^)(NSArray* msgs))success failed:(void (^)(NSDictionary* failedData))reslutFailedCallback;


/**
 * 发送自定义消息
 * 在进入直播活动后调用
 * 成功回调成功Block
 * 失败回调失败Block
 *         失败Block中的字典结构如下：
 *         key:code 表示错误码
 *        value:content 表示错误信息
 */
- (void)sendCustomMsg:(NSString *)jsonStr success:(void(^)(void))success failed:(void (^)(NSDictionary* failedData))reslutFailedCallback;
@end
