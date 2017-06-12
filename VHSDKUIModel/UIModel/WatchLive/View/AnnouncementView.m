//
//  AnnouncementView.m
//  VHallSDKDemo
//
//  Created by vhall on 17/2/14.
//  Copyright © 2017年 vhall. All rights reserved.
//

#import "AnnouncementView.h"
@interface AnnouncementView()
{
    UILabel *_contentLabel;
    UIView  *_containView;
}
@end


@implementation AnnouncementView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame content:(NSString*)content time:(NSString*)time
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = MakeColorRGB(0xf5f5f5);
        
       
        
        _content = content;
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _contentLabel.text = [NSString stringWithFormat:@"公告: %@",content];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        _contentLabel.textColor = MakeColorRGB(0x909090);
        [_contentLabel sizeToFit];
        _contentLabel.centerY = self.height/2;
        _contentLabel.left =  VH_SW-self.height;
         [self addSubview:_contentLabel];
        UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UIModel.bundle/公告.tiff"]];
        [imageView setFrame:CGRectMake(10, self.height/2-12, 24, 24)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.width -30 , 5,30, 30)];
        [btn setImage:[UIImage imageNamed:@"UIModel.bundle/关闭.tiff"] forState:UIControlStateNormal];
        btn.layer.cornerRadius = (self.height-8)/2;
        btn.layer.masksToBounds= YES;
        [btn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
//        UIView *containerView=[[UIView alloc] initWithFrame:CGRectMake(10+imageView.width, 0, VH_SW-10-imageView.width-10-18, self.height)];
//        containerView.backgroundColor=[UIColor yellowColor];
//        _containView=containerView;
//        [self addSubview:containerView];
       
        
        
        UIView *left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10+imageView.width, self.height)];
        left.backgroundColor=MakeColorRGB(0xf5f5f5);
        [self insertSubview:left aboveSubview:_contentLabel];
        [self insertSubview:imageView aboveSubview:left];
        
        
        UIView *right =[[UIView alloc] initWithFrame:btn.frame];
        right.backgroundColor=MakeColorRGB(0xf5f5f5);
        [self insertSubview:right aboveSubview:_contentLabel];
        [self insertSubview:btn aboveSubview:right];
        
        
        [self startAnimation];
    }
    return self;
}

/*动画代码*/
- (void)startAnimation{
    float t = 5;
    float len = _contentLabel.width+self.width;
    CGAffineTransform endpos = CGAffineTransformMakeTranslation(-len, 0);
    [UIView animateWithDuration:(t*len/self.width) delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _contentLabel.transform = endpos;
    } completion:^(BOOL finished) {
        if (finished) {//必须写上，@selector(endAnimation)中的方法才有用
            _contentLabel.transform = CGAffineTransformMakeTranslation(0,0);
            [self startAnimation];
        }
    }];
}

- (void)endAnimation{
    [_contentLabel.layer removeAllAnimations];//会结束动画，使finished变量返回Null
}

- (void)setContent:(NSString *)content
{
    self.hidden = NO;
    _content = content;
    if(content)
    {
        [self endAnimation];
        _contentLabel.text = [NSString stringWithFormat:@"公告: %@",_content];
        [_contentLabel sizeToFit];
        _contentLabel.transform = CGAffineTransformMakeTranslation(0,0);
        _contentLabel.left =  VH_SW-self.height;
        [self startAnimation];
    }
}

- (void)hideView
{
    self.hidden = YES;
}

@end
