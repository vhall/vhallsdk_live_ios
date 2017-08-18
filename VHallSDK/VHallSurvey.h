//
//  VHallSurvey.h
//  VHallSDK
//
//  Created by vhall on 17/2/14.
//  Copyright © 2017年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallBasePlugin.h"

@protocol VHallSurveyDelegate <NSObject>
/**
 *  接收问卷消息
 *
 *
 */
-(void)receiveSurveryMsgs:(NSArray*)msg;
@end
@interface VHallSurvey : VHallBasePlugin
@property(nonatomic,assign) id<VHallSurveyDelegate> delegate;


@property(nonatomic,copy) NSString     *surveyId;//问卷Id;
@property(nonatomic,strong) NSString   *surveyTitle;//问卷标题
@property(nonatomic,copy)   NSArray    *questionArray;//问题列条
@property(nonatomic,copy)   NSString   *liveId;//活动Id
/**
 * 获取问卷内容
 *
 * @param surveyId              调查问卷Id
 *  @param webId                当前活动Id
 * @param success               成功回调成功Block 返回问卷内容
 * @param reslutFailedCallback  失败回调失败Block
 *                              失败Block中的字典结构如下：
 *                              key:code 表示错误码
 *                              value:content 表示错误信息
 */
- (void)getSurveryContentWithSurveyId:(NSString*)surveyId webInarId:(NSString*)webId success:(void(^)(VHallSurvey* msgs))success failed:(void (^)(NSDictionary* failedData))reslutFailedCallback;





/**
 * 发送完成问卷
 *
 * 成功回调成功Block
 * 失败回调失败Block
 * 		失败Block中的字典结构如下：
 * 		key:code 表示错误码
 *		value:content 表示错误信息
 */
- (void)sendMsg:(NSArray *)msg success:(void(^)())success failed:(void (^)(NSDictionary* failedData))reslutFailedCallback;
@end


@interface VHallSurveyQuestion : NSObject
@property(nonatomic,assign)    NSUInteger questionId;// 问题Id
@property(nonatomic,copy)      NSString   *questionTitle;//问题标题
@property(nonatomic,assign)    NSUInteger orderNum;//问题排序
@property(nonatomic,assign)    BOOL       isMustSelect;
@property(nonatomic,assign)    NSUInteger type ;// 选项类型 （0问答 1单选 2多选）
@property(nonatomic,copy)      NSArray    *quesionSelectArray;//问题选项数组 
@end
