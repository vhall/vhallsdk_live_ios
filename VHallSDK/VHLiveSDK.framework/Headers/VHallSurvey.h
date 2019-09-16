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

/*flsh活动，发布问卷以下两个方法都会回调。如果使用webView的方式加载问卷，在-receivedSurveyWithURL:处理，如果仍保留旧版加载问卷方式，在-receiveSurveryMsgs:方法处理，处理方式不变。H5活动发布问卷，只回调-receivedSurveyWithURL：。
  */

/**
 *  接收问卷消息
 */
-(void)receiveSurveryMsgs:(NSArray*)msg;

/**
 收到问卷 v4.0.0新增
 @param surveyURL 问卷地址
 */
- (void)receivedSurveyWithURL:(NSURL *)surveyURL;

@end

@interface VHallSurvey : VHallBasePlugin

@property(nonatomic, weak) id<VHallSurveyDelegate> delegate;


@property (nonatomic,copy) NSString   *surveyId;//问卷Id;
@property (nonatomic,copy) NSString   *surveyTitle;//问卷标题
@property (nonatomic,copy) NSArray    *questionArray;//问题列条
@property (nonatomic,copy) NSString   *liveId;//活动Id

/**
 * 获取Flash活动问卷内容，对H5活动无效
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
 获取Flash活动问卷内容，对H5活动无效
 返回参数如下：
 {
 "code": "200",
 "msg": "成功",
 "data": {
 "survey_id": 591,
 "subject": "调查问卷",
 "list": [
 {
 "ques_id": 711,
 "subject": "我是问答题"
 "ordernum": 0,
 "must": 1,
 "type": 0
 },
 {
 "ques_id": 712,
 "subject": "我是单选题",
 "ordernum": 0,
 "must": 0,
 "type": 1,
 "list": [
 {
 "subject": "选项1",
 "type": 0
 },
 {
 "subject": "选项1",
 "type": 0
 },
 {
 "subject": "其他",
 "type": 1
 }
 ]
 },
 {
 "ques_id": 713,
 "subject": "我是多选题",
 "ordernum": 0,
 "must": 0,
 "type": 2,
 "list": [
 {
 "subject": "选项1",
 "type": 0
 },
 {
 "subject": "选项1",
 "type": 0
 },
 {
 "subject": "其他",
 "type": 1
 }
 ]
 },
 {
 "ques_id": 714,
 "subject": "我是城市题",
 "ordernum": 0,
 "must": 0,
 "type": 3
 },
 {
 "ques_id": 715,
 "subject": "我是小节题",
 "ordernum": 0,
 "must": 0,
 "type": 4
 }
 ]
 }
 }


 @discussion 异步函数，获取问卷内容，并将原始数据返回。
 */
- (void)getSurveryRequestWithSurveyId:(NSString *)surveyId webInarId:(NSString *)webId success:(void(^)(NSDictionary *result))success failed:(void (^)(NSDictionary* failedData))failedCallback;



/**
 * 发送Flash活动问卷结果，对H5活动无效
 *
 * 成功回调成功Block
 * 失败回调失败Block
 *         失败Block中的字典结构如下：
 *         key:code 表示错误码
 *        value:content 表示错误信息
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
