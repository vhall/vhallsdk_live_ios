//
//  VHPlayerView.m
//  UIModel
//
//  Created by vhall on 2017/12/22.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "VHPlayerView.h"

//顶部底部工具条高度
#define ToolBarHeight     40

@interface VHPlayerView()

@property (nonatomic, assign) BOOL isBarShowing;

@end

@implementation VHPlayerView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        
        [self initViews];
        //单点手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

-(void)initViews
{
    [self addSubview:self.bottomToolBar]; //底部工具条
    [self.bottomToolBar addSubview:self.playButton];
    [self.bottomToolBar addSubview:self.fullButton];
    [self.bottomToolBar addSubview:self.currentTimeLabel];
    [self.bottomToolBar addSubview:self.totalTimeLabel];
    [self.bottomToolBar addSubview:self.progress];
    [self.bottomToolBar addSubview:self.proSlider];
    self.bottomToolBar.backgroundColor = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.20000f];
}

#pragma mark---布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bottomToolBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - ToolBarHeight, CGRectGetWidth(self.bounds), ToolBarHeight);
    
    self.playButton.frame = CGRectMake(CGRectGetMinX(self.bottomToolBar.bounds), CGRectGetHeight(self.bottomToolBar.bounds)/2 - CGRectGetHeight(self.playButton.bounds)/2, CGRectGetWidth(self.playButton.bounds), CGRectGetHeight(self.playButton.bounds));
    
    self.fullButton.frame = CGRectMake(CGRectGetWidth(self.bottomToolBar.bounds)-35,  CGRectGetHeight(self.bottomToolBar.bounds)/2 - CGRectGetHeight(self.fullButton.bounds)/2, CGRectGetWidth(self.fullButton.bounds), CGRectGetHeight(self.fullButton.bounds));
    
    self.currentTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.playButton.bounds)+10,0, 45, 40);
    
    self.totalTimeLabel.frame = CGRectMake(CGRectGetWidth(self.bounds)-CGRectGetMaxX(self.playButton.bounds)-55,0, 45, 40);
    
    //缓冲条

    self.proSlider.frame = CGRectMake(95,  CGRectGetHeight(self.bottomToolBar.bounds)/2 - CGRectGetHeight(self.proSlider.bounds)/2, CGRectGetWidth(self.bounds)-190, CGRectGetHeight(self.proSlider.bounds));
    //滑杆
    // self.progress.frame = CGRectMake(105,CGRectGetHeight(self.bottomToolBar.bounds)/2-1, self.width-210, 2);
    
}

#pragma mark ---懒加载
- (UIView *)bottomToolBar
{
    if (_bottomToolBar == nil) {
        _bottomToolBar = [[UIView alloc]init];
        _bottomToolBar.userInteractionEnabled = YES;
    }
    return _bottomToolBar;
}

- (UIButton *) playButton{
    if (_playButton == nil){
        _playButton = [[UIButton alloc] init];
        _playButton.frame = CGRectMake(0, 0, 30, 30);
        // VHPlayBtn
        [_playButton setImage:[UIImage imageNamed:@"UIModel.bundle/VHPlayBtn"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"UIModel.bundle/VHPauseBtn"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(Vh_playerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

//全屏按钮
- (UIButton *) fullButton{
    if (_fullButton == nil){
        _fullButton = [[UIButton alloc] init];
        _fullButton.frame = CGRectMake(0, 0, 35, 35);
        [_fullButton setImage:[UIImage imageNamed:@"video-player-screen"] forState:UIControlStateNormal];
        [_fullButton setImage:[UIImage imageNamed:@"video-player-screen"] forState:UIControlStateSelected];
        [_fullButton addTarget:self action:@selector(Vh_fullScreenButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullButton;
}
//当前播放时间
- (UILabel *) currentTimeLabel{
    if (_currentTimeLabel == nil){
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.adjustsFontSizeToFitWidth = YES;
        _currentTimeLabel.text = @"00:00:00";
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}
//总时间
- (UILabel *) totalTimeLabel{
    if (_totalTimeLabel == nil){
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.adjustsFontSizeToFitWidth = YES;
        _totalTimeLabel.text = @"00:00:00";
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}
//缓冲条
- (UIProgressView *) progress{
    if (_progress == nil){
        _progress = [[UIProgressView alloc] init];
        //缓冲条
        _progress.trackTintColor = [UIColor colorWithRed:0.54118
                                                   green:0.51373
                                                    blue:0.50980
                                                   alpha:1.00000];
        _progress.progressTintColor = [UIColor colorWithRed:0.84118
                                                      green:0.81373
                                                       blue:0.80980
                                                      alpha:1.00000];
    }
    return _progress;
}

//滑动条
- (UISlider *) proSlider{
    
    if (!_proSlider){
        _proSlider = [[UISlider alloc] init];
        [_proSlider setThumbImage:[UIImage imageNamed:@"video-player-point"] forState:UIControlStateNormal];
        _proSlider.minimumTrackTintColor = [UIColor whiteColor];
        _proSlider.maximumTrackTintColor = [UIColor lightGrayColor];
        _proSlider.value = 0.f;
        _proSlider.continuous = YES;
        //   slider开始滑动事件
        [_proSlider addTarget:self action:@selector(Vh_progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_proSlider addTarget:self action:@selector(Vh_progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_proSlider addTarget:self action:@selector(Vh_progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        //右边颜色
        //   _progressSlider.maximumTrackTintColor = [UIColor clearColor];
    }
    
    return _proSlider;
}

- (void)onTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isBarShowing) {
            [self animateHide];
        } else {
            [self animateShow];
        }
    }
}

- (void)animateHide
{
    if (!self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomToolBar.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = NO;
    }];
}

- (void)animateShow
{
    if (self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomToolBar.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = YES;
        [self autoFadeOutControlBar];
    }];
}
- (void)autoFadeOutControlBar
{
    if (!self.isBarShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:5];
}

- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}

#pragma mark----按钮点击事件
- (void)Vh_playerButtonAction:(UIButton *)button;
{
    button.selected = !button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(Vh_playerButtonAction:)]) {
        [_delegate Vh_playerButtonAction:button];
    }else
    {
        NSLog(@"没有实现代理或设置代理人");
    }

}
- (void)Vh_fullScreenButtonAction:(UIButton *)button
{
     button.selected = !button.selected;
    if (_delegate&&[_delegate respondsToSelector:@selector(Vh_fullScreenButtonAction:)]) {
        
        [_delegate Vh_fullScreenButtonAction:button];
    }else{
        NSLog(@"没有实现代理或设置代理人");
    }

}
- (void)Vh_progressSliderTouchBegan:(UISlider *)slider
{
    if (_delegate&&[_delegate respondsToSelector:@selector(Vh_progressSliderTouchBegan:)]) {
        [_delegate Vh_progressSliderTouchBegan:slider];
    }else{
        NSLog(@"没有实现代理或设置代理人");
    }
    
}
- (void)Vh_progressSliderValueChanged:(UISlider *)slider
{
    if (_delegate&&[_delegate respondsToSelector:@selector(Vh_progressSliderValueChanged:)]) {
        [_delegate Vh_progressSliderValueChanged:slider];
    }else{
        NSLog(@"没有实现代理或设置代理人");
    }
    
}
- (void)Vh_progressSliderTouchEnded:(UISlider *)slider
{
    if (_delegate&&[_delegate respondsToSelector:@selector(Vh_progressSliderTouchEnded:)]) {
        [_delegate Vh_progressSliderTouchEnded:slider];
    }else{
        NSLog(@"没有实现代理或设置代理人");
    }
    
}

#pragma mark - 获取资源图片
- (UIImage *)getPictureWithName:(NSString *)name{
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"UIModel" ofType:@"bundle"]];
    NSString *path   = [bundle pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

@end
