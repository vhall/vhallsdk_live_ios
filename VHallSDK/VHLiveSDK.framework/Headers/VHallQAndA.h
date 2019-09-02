//
//  VHallQAndA.h
//  VHallSDK
//
//  Created by Ming on 16/8/23.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"

@class VHallQAndA;

@protocol VHallQADelegate <NSObject>
@optional
//主播开启问答
- (void)vhallQAndADidOpened:(VHallQAndA *)QA;
//主播关闭问答
- (void)vhallQAndADidClosed:(VHallQAndA *)QA;
//问答消息
- (void)reciveQAMsg:(NSArray *)msgs;

@end

///问答
@interface VHallQAndA : VHallBasePlugin

@property (nonatomic, assign) id <VHallQADelegate> delegate;

//问答是否开启
@property (nonatomic, assign, readonly) BOOL isOpen;

/**
 *  发送提问内容
 *  成功回调成功Block
 *  失败回调失败Block
 *  		失败Block中的字典结构如下：
 * 		key:code 表示错误码
 *		value:content 表示错误信息
 */
- (void)sendMsg:(NSString *)msg success:(void(^)(void))success failed:(void (^)(NSDictionary* failedData))reslutFailedCallback;

/**
 * 获取问答历史记录
 * 在进入直播活动后调用
 * @param showAll               保留字段
 * @param success               成功回调成功Block 返回问答历史记录
 * @param reslutFailedCallback  失败回调失败Block
 *                              失败Block中的字典结构如下：
 *                              key:code 表示错误码
 *                              value:content 表示错误信息
 */
- (void)getQAndAHistoryWithType:(BOOL)showAll success:(void(^)(NSArray* msgs))success failed:(void (^)(NSDictionary* failedData))reslutFailedCallback;
@end
