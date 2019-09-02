//
//  SueveyBackGroundView.m
//  UIModel
//
//  Created by vhall on 2019/8/23.
//  Copyright © 2019 www.vhall.com. All rights reserved.
//

#import "SueveyBackGroundView.h"

@interface SueveyBackGroundView ()

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end


@implementation SueveyBackGroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        [self addSubview:self.progressView];
        [self bringSubviewToFront:self.progressView];
    }
    return self;
}


- (UIView *)progressView {
    if (!_progressView)
    {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 3)];
        _progressView.layer.cornerRadius = 1.5;
        
        _gradientLayer = [CAGradientLayer layer];
        
        //  设置 gradientLayer 的 Frame
        _gradientLayer.frame = _progressView.frame;
        
        //  创建渐变色数组，需要转换为CGColor颜色
        _gradientLayer.colors = @[(id)[UIColor whiteColor].CGColor,
                                  
                                  (id)[UIColor redColor].CGColor];
        
        //  设置三种颜色变化点，取值范围 0.0~1.0
        _gradientLayer.locations = @[@(0.1f) ,@(1.0f)];
        
        //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
        //  添加渐变色到创建的 UIView 上去
        [_progressView.layer addSublayer:_gradientLayer];
    }
    return _progressView;
}

- (void)setProgress:(float)progress {
    
    NSLog(@"*******%f",progress);
    
    self.progressView.width = progress * CGRectGetWidth(self.frame);
    self.gradientLayer.frame = self.progressView.frame;
    
    if (progress == 1) {
        [self performSelector:@selector(removeProgress) withObject:nil afterDelay:0.5];
    }
}

- (void)removeProgress {
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = nil;
    
    [self.progressView removeFromSuperview];
    self.progressView = nil;
}

@end
