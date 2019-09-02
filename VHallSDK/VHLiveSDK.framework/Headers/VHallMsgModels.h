//
//  VHallMsgModels.h
//  VHallSDK
//
//  Created by Ming on 16/8/25.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHallMsgModels : NSObject
@property (nonatomic, copy) NSString * join_id;         //参会id
@property (nonatomic, copy) NSString * account_id;      //微吼用户ID
@property (nonatomic, copy) NSString * user_name;       //参会时的昵称
@property (nonatomic, copy) NSString * avatar;          //头像url，如果没有则为空字符串
@property (nonatomic, copy) NSString * room;            //房间号，即活动id
@property (nonatomic, copy) NSString * time;            //发送时间，根据服务器时间确定
@property (nonatomic, copy) NSString * role;            //用户类型 host:主持人 guest：嘉宾 assistant：助手 user：观众
@end

/**
 *  上下线消息
 */
@interface VHallOnlineStateModel : VHallMsgModels
@property (nonatomic, copy) NSString * event;          //online/offline:上下线消息
@property (nonatomic, copy) NSString * concurrent_user;//房间内当前用户数
@property (nonatomic, copy) NSString * attend_count;   //参会人数
@property (nonatomic, copy) NSString * tracksNum;      //PV
@end

/**
 *  聊天消息
 */
typedef NS_ENUM(NSInteger,ChatMsgType) {
    ChatMsgTypeText,
    ChatMsgTypeImage,
    ChatMsgTypeLink,
    ChatMsgTypeVideo,
    ChatMsgTypeVoice,
};

@interface VHallChatModel : VHallMsgModels
@property (nonatomic, copy) NSString * text;            //聊天消息
@property (nonatomic, assign) ChatMsgType type;         //聊天消息类型
@end
/**
 *  自定义消息
 */
@interface VHallCustomMsgModel : VHallMsgModels
@property (nonatomic, copy) NSString * jsonstr;          //头像url，如果没有则为空字符串
@end

/**
 *  历史评论
 */

@interface VHCommentModel : VHallMsgModels
@property (nonatomic, copy) NSString * text;            //评论内容
@property(nonatomic,copy)   NSString *commentId;        //评论ID
@end

/**
 *  提问消息
 */
@interface VHallQuestionModel : NSObject
@property (nonatomic, copy) NSString * type;            //类型
@property (nonatomic, copy) NSString * question_id;     //问题ID
@property (nonatomic, copy) NSString * nick_name;       //昵称
@property (nonatomic, copy) NSString * content;         //提问内容
@property (nonatomic, copy) NSString * join_id;         //参会id
@property (nonatomic, copy) NSString * created_at;      //提问时间
@property (nonatomic, copy) NSString * avatar;          //头像
@end

/**
 *  回答消息
 */
@interface VHallAnswerModel : VHallQuestionModel
@property (nonatomic, copy) NSString * answer_id;       //回答ID
@property (nonatomic, copy) NSString * role_name;       //角色
@property (nonatomic, assign)BOOL      is_open;         //是否公开回答
@property (nonatomic, copy) NSString * avatar;
@end

/**
 *  问答消息
 */
@interface VHallQAModel : VHallMsgModels
@property (nonatomic, strong) VHallQuestionModel * questionModel;                   //提问消息
@property (nonatomic, strong) NSMutableArray<VHallAnswerModel *> * answerModels;    //回答消息数组
@end

/**
 *  抽奖消息
 */
@interface VHallLotteryModel : NSObject
@property (nonatomic, copy) NSString * lottery_id;      //抽奖ID
@property (nonatomic, copy) NSString * survey_id;       //活动ID
@end

/**
 *  开始抽奖消息
 */
@interface VHallStartLotteryModel : VHallLotteryModel
@property (nonatomic, copy) NSString * num;             //抽奖人数
@end

/**
 *  抽奖结果
 */
@interface VHallLotteryResultModel : NSObject
@property (nonatomic, copy) NSString * nick_name;       //中奖人昵称
@end

/**
 *  结束抽奖消息
 */
@interface VHallEndLotteryModel : VHallLotteryModel
@property (nonatomic, assign) BOOL isWin;               //是否中奖
@property (nonatomic, copy) NSString * account;         //登录账号
@property (nonatomic, copy) NSMutableArray<VHallLotteryResultModel *> * resultModels; //中奖结果
@end

/**
 *  调查问卷消息
 */
@interface VHallSurveyModel : NSObject
@property(nonatomic,copy) NSString * releaseTime;//发起时间
@property(nonatomic,copy) NSString * surveyId;//问卷ID
@property(nonatomic,copy) NSString * joinId;
@property (nonatomic, copy) NSURL *surveyURL;//问卷URL地址v4.0.4新增
@end


#pragma mark -
#pragma mark - PPT/白板画笔
/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger,VHFlashMsgType) {
    VHFlashMsgType_FlipOver = 0,    //ppt翻页
    VHFlashMsgType_ShowBoard = 1,   //显示白板
    VHFlashMsgType_HideBoard = 2,   //隐藏白板
    VHFlashMsgType_Doc  = 3,        //ppt相关消息
    VHFlashMsgType_Board = 4,       //白板相关消息
    VHFlashMsgType_ShowDoc = 5,   //显示文档区域
    VHFlashMsgType_HideDoc = 6,   //隐藏文档区域
};

/**
 *  绘制类型
 */
typedef NS_ENUM(NSInteger,VHDrawType) {
    VHDrawType_Default     = 0 ,    //默认
    VHDrawType_Handwriting = 1 ,    //笔迹
    VHDrawType_Circle = 20 ,        //圆/椭圆
    VHDrawType_Rectangle = 22 ,     //矩形
    VHDrawType_Arrow = 30 ,         //单箭头
    VHDrawType_DoubleArrow = 31 ,   //双箭头
    VHDrawType_Text = 4 ,           //文字
    VHDrawType_Anchor = 7 ,         //锚点
    VHDrawType_Del = 8 ,            //删除
    VHDrawType_DelAll = 9 ,         //删除全部绘制
};

@interface VHFlashMsg : NSObject
@property(nonatomic,assign) CGFloat         created_at ;    //消息时间点
@property(nonatomic,copy)   NSString        *pageID;        //pptId
@property(nonatomic,copy)   NSString        *imageUrl;      //ppt图片地址
@property(nonatomic,assign) VHFlashMsgType  flashMsgType;   //消息类型
@property(nonatomic,assign) VHDrawType      drawType;       //绘制类型
@end


@interface VHFlashMsg_FlipOver : VHFlashMsg
@property(nonatomic,copy)   NSString      *doc;      //文档名
@property(nonatomic,copy)   NSString      *page;     //该doc文档当前页数
@property(nonatomic,copy)   NSString      *totalPage;//该doc文档总页数
@property(nonatomic,copy)   NSString      *uid;      //用户ID
@end


@interface VHFlashMsg_Graph : VHFlashMsg    //白板内容类型 1画笔
@property(nonatomic,assign) NSInteger     drawId;//绘制内容ID
@property(nonatomic,assign) NSInteger     color ;//画笔颜色
@end

/**
 *  画笔
 */
@interface VHFlashMsg_Handwriting : VHFlashMsg_Graph    //白板内容类型 1画笔
@property(nonatomic,assign) NSInteger     lineSize;//画笔尺寸
@property(nonatomic,copy)   NSArray       *points; //坐标点
@end

/**
 *  锚点
 */
@interface VHFlashMsg_Anchor : VHFlashMsg_Graph    //锚点
@property(nonatomic,copy)   NSArray       *point;  //坐标点
@end

/**
 *  文字
 */
@interface VHFlashMsg_Text  : VHFlashMsg_Graph
@property(nonatomic,assign) NSInteger   fb;//粗体
@property(nonatomic,copy)   NSArray     *point;// 起始坐标
@property(nonatomic,assign) NSInteger   fi;//斜体
@property(nonatomic,assign) NSInteger   fs;//字体字号
@property(nonatomic,copy)   NSString    *text;//文本
@end

/**
 *  图形 //20画圆,31双箭头,单箭头30 ，22矩形
 */
@interface VHFlashMsg_Shape : VHFlashMsg_Graph
@property(nonatomic,copy)   NSArray     *startPoint;//起始坐标
@property(nonatomic,copy)   NSArray     *endPoint; //结束坐标
@end

/**
 *  删除/清空
 */
@interface VHFlashMsg_Del : VHFlashMsg
@property(nonatomic,assign)  NSInteger   drawId;//要擦除的白板内容
@end



