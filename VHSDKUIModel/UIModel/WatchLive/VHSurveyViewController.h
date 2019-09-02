//
//  VHSurveyViewController.h
//  UIModel
//
//  Created by vhall on 2019/7/10.
//  Copyright © 2019年 www.vhall.com. All rights reserved.
//

#import "VHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class VHSurveyViewController;

@protocol VHSurveyViewControllerDelegate <NSObject>

@required
//关闭按钮时间回调
- (void)surveyviewControllerDidCloseed:(UIButton *)sender;
//web关闭按钮事件回调
- (void)surveyViewControllerWebViewDidClosed:(VHSurveyViewController *)vc;
//提交成功
- (void)surveyViewControllerWebViewDidSubmit:(VHSurveyViewController *)vc msg:(NSDictionary *)body;

@end

@interface VHSurveyViewController : VHBaseViewController

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, weak) id <VHSurveyViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
