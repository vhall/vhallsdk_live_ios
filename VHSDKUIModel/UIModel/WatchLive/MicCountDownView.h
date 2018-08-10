//
//  MicCountDownView.h
//  LightEnjoy
//
//  Created by vhall on 2018/7/13.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MicCountDownView;

@protocol MicCountDownViewDelegate <NSObject>

//倒计时结束回调
- (void)countDownViewDidEndCountDown:(MicCountDownView *)view;

@end


@interface MicCountDownView : UIView

@property (nonatomic, weak) id <MicCountDownViewDelegate> delegate;

@property (nonatomic, strong) UIButton *button;

- (void)countdDown:(NSUInteger)count;

- (void)hiddenCountView;
- (void)showCountView;

- (void)stopCountDown;

@end
