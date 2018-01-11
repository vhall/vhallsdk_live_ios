//
//  VHPlayerView.h
//  UIModel
//
//  Created by vhall on 2017/12/22.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VHPlayerViewDelegate <NSObject>

/**播放按钮代理*/
- (void)Vh_playerButtonAction:(UIButton *)button;

/**全屏按钮事件*/
- (void)Vh_fullScreenButtonAction:(UIButton *)button;

/**开始滑动*/
- (void)Vh_progressSliderTouchBegan:(UISlider *)slider;

/**滑动中*/
- (void)Vh_progressSliderValueChanged:(UISlider *)slider;

/**滑动结束*/
- (void)Vh_progressSliderTouchEnded:(UISlider *)slider;

@end

@interface VHPlayerView : UIButton

/**底部工具条*/
@property (nonatomic,strong) UIView *bottomToolBar;
/**底部工具条播放按钮*/
@property (nonatomic,strong) UIButton *playButton;
/**底部工具条全屏按钮*/
@property (nonatomic,strong) UIButton *fullButton;
/**底部工具条当前播放时间*/
@property (nonatomic,strong) UILabel *currentTimeLabel;
/**底部工具条视频总时间*/
@property (nonatomic,strong) UILabel *totalTimeLabel;
/**缓冲进度条*/
@property (nonatomic,strong) UIProgressView *progress;
/**进度条滑动圆*/
@property (nonatomic,strong) UISlider *proSlider;

@property (nonatomic,weak)id<VHPlayerViewDelegate>delegate;

/**
 *  动画隐藏
 */
- (void)animateHide;

//@property (nonatomic, assign) BOOL isBarShowing;

/**
 *  动画显示
 */
- (void)animateShow;

- (void)autoFadeOutControlBar;

- (void)cancelAutoFadeOutControlBar;


@end
