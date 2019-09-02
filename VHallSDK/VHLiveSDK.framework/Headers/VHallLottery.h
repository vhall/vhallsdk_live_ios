//
//  VHallLottery.h
//  VHallSDK
//
//  Created by Ming on 16/10/13.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallMsgModels.h"
#import "VHallBasePlugin.h"

@protocol VHallLotteryDelegate <NSObject>
@optional

- (void)startLottery:(VHallStartLotteryModel *)msg;
- (void)endLottery:(VHallEndLotteryModel *)msg;

@end

@interface VHallLottery : VHallBasePlugin

@property (nonatomic, assign) id <VHallLotteryDelegate> delegate;

/**
 *  提交个人中奖信息
 *  @param info   个人信息 @{@"name":用户名,@"phone":电话}
 *  成功回调成功Block
 *  失败回调失败Block
 *  		失败Block中的字典结构如下：
 * 		key:code 表示错误码
 *		value:content 表示错误信息
 */
- (void)submitLotteryInfo:(NSDictionary *)info success:(void(^)(void))success failed:(void (^)(NSDictionary *failedData))reslutFailedCallback;

@end
