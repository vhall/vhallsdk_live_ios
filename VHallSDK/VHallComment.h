//
//  VHallComment.h
//  VHallSDK
//
//  Created by Ming on 16/8/23.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"

@interface VHallComment : VHallBasePlugin

/**
 *  发表评论内容
 *  成功回调成功Block
 *  失败回调失败Block
 *  		失败Block中的字典结构如下：
 * 		key:code 表示错误码
 *		value:content 表示错误信息
 *  10030 	身份验证出错
 *  10402 	当前活动ID错误
 *  10049	访客数据信息不全
 *  10404 	KEY值验证出错
 *  10046 	当前活动已结束
 *  10047 	您已被踢出，请联系活动组织者
 *  10048 	活动现场太火爆，已超过人数上限
 */
- (BOOL)sendComment:(NSString *)comment success:(void(^)())success failed:(void (^)(NSDictionary* failedData))reslutFailedCallback;

/**
 *获取历史评论记录
 *在进入回放活动后调用
 *@param limit                         每次拉取数据条数，默认每次20条，最多50条
 *@param pos                           从第几条数据开始获取 默认0
 *@param success                       成功回调成功Block 返回评论历史记录
 *@param reslutFailedCallback          失败回调失败Block
 *                                     失败Block中的字典结构如下：
 *                                     key:code 表示错误码
 *                                     value:content 表示错误信息
 *  10030 	身份验证出错
 *  10402 	当前活动ID错误
 *  10403 	活动不属于自己
 *  10407 	查询数据为空
 *  10412 	直播中，获取失败
 *  10413 	获取条目最多为50
 *  10409 	参会信息不存在
 *  10410 	活动开始时间不存在
 */
-(void)getHistoryCommentPageCountLimit:(NSInteger)limit offSet:(NSInteger)pos success:(void(^)(NSArray*msgs))success failed:(void(^)(NSDictionary* failedData))reslutFailedCallback;

@end
