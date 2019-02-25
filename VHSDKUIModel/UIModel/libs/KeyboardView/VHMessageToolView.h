//
//  VHMessageToolView.h
//  vhall1
//
//  Created by vhallrd01 on 14-6-20.
//  Copyright (c) 2014年 vhallrd01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHMessageTextView.h"
#import "DXFaceView.h"

#define kInputTextViewMinHeight 34
#define kInputTextViewMaxHeight 100
#define kHorizontalPadding 50
#define kVerticalPadding 8.5

@protocol VHMessageToolBarDelegate <NSObject>

- (void)didSendText:(NSString *)text;
@optional
- (void)didChangeFrameToHeight:(CGFloat)toHeight;

- (void)cancelTextView;

@end

@interface VHMessageToolView : UIView<UITextViewDelegate,DXFaceDelegate>
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
    
}

@property (strong, nonatomic) UIView *toolBackGroundView;

@property (strong, nonatomic) VHMessageTextView *msgTextView;

@property (strong, nonatomic) UIButton *cancelButton;

@property (nonatomic) CGFloat maxTextInputViewHeight;

@property (weak, nonatomic) id<VHMessageToolBarDelegate> delegate;

@property (strong, nonatomic) UIButton *smallButton;

@property (nonatomic) CGRect faceRect;
@property(nonatomic,assign) int  maxLength;//最大字符个数

/**
 *  表情的附加页面
 */
//@property (strong, nonatomic) UIView *faceView;

/**
 *  底部扩展页面
 */
@property (nonatomic) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面

@property (nonatomic) NSInteger type;

+(CGFloat)defaultHeight;

-(BOOL)endEditing:(BOOL)force;

-(void)beginFaceViewInView;
-(void)beginTextViewInView;

//type 1详情页  2聊天
- (id)initWithFrame:(CGRect)frame type:(NSInteger)type;

- (void)addKeyBoardNoti;
- (void)removeKeyBoardNoti;
//重置聊天框高度
- (void)resetMessageTextHeight;
@end
