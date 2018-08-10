//
//  MicCountDownView.m
//  LightEnjoy
//
//  Created by vhall on 2018/7/13.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "MicCountDownView.h"

@interface MicCountDownView ()
{
    NSUInteger timeCount;
}
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation MicCountDownView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.titleLabel.font = [UIFont systemFontOfSize:10.0];
        self.button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.button];
        [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageNamed:@"UIModel.bundle/icon_video_upper wheat.tiff"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.button.frame = self.bounds;
    self.button.layer.cornerRadius = self.button.width * 0.5;
    
    self.button.backgroundColor = [UIColor lightGrayColor];
}



- (void)countdDown:(NSUInteger)count {
    //重置倒计时
    [self stopTimer];
    //重置
    timeCount = count;
    //初始时间
    self.button.titleLabel.text = [NSString stringWithFormat:@"%lus",(unsigned long)count];
    self.hidden = NO;
    //开始倒计时
    self.timer.fireDate = [NSDate distantPast];
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return _timer;
}
- (void)removeTimer {
    if (_timer) {
        //停止timer
        [self stopTimer];
        
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)stopTimer {
    //停止timer
    _timer.fireDate = [NSDate distantFuture];
}

- (void)timerAction
{
    if (timeCount <= 0) {
        
        [self stopTimer];
        
        if ([self.delegate respondsToSelector:@selector(countDownViewDidEndCountDown:)]) {
            [self.delegate countDownViewDidEndCountDown:self];
        }
        
        [self.button setTitle:@" " forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageNamed:@"UIModel.bundle/icon_video_upper wheat.tiff"] forState:UIControlStateNormal];

        self.button.selected = NO;
    }
    else {
        
        timeCount--;
        
        [self.button setTitle:[NSString stringWithFormat:@"%lus",(unsigned long)timeCount] forState:UIControlStateNormal];
        [self.button setBackgroundImage:nil forState:UIControlStateNormal];

    }
}
- (void)hiddenCountView {
    [self stopCountDown];
    [UIView animateWithDuration:.3 animations:^{
        
        self.hidden = YES;
    }];
}
- (void)showCountView {
    [UIView animateWithDuration:.3 animations:^{
        
        self.hidden = NO;
    }];
}

- (void)stopCountDown {
    [self.button setTitle:@" " forState:UIControlStateNormal];
    [self.button setBackgroundImage:[UIImage imageNamed:@"UIModel.bundle/icon_video_upper wheat.tiff"] forState:UIControlStateNormal];
    
    self.button.selected = NO;

    [self removeTimer];
}


- (void)dealloc {
    
    [self removeTimer];
}

@end
