//
//  RefreshAnimationView.m
//  VhallIphone
//
//  Created by vhall on 16/6/3.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import "RefreshAnimationView.h"
@interface RefreshAnimationView()
{
    UIImageView *_imageViewIn;
    UIImageView *_imageViewOUT;
    CABasicAnimation* _rotationAnimation;
}
@end



@implementation RefreshAnimationView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotationAnimation.duration = 1;
        _rotationAnimation.cumulative = YES;
        _rotationAnimation.repeatCount = 1000000;

        _imageViewIn = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageViewIn.image = [UIImage imageNamed:@"UIModel.bundle/loadingin.tiff"];
        _imageViewIn.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imageViewIn];
        
        _imageViewOUT = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageViewOUT.contentMode = UIViewContentModeScaleToFill;
        _imageViewOUT.image = [UIImage imageNamed:@"UIModel.bundle/loadingout.tiff"];
        [self addSubview:_imageViewOUT];
    }
    return self;
}

- (void)startAnimating
{
    _rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    [_imageViewIn.layer addAnimation:_rotationAnimation forKey:@"rotationAnimation"];
    _rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * -2.0 ];
    [_imageViewOUT.layer addAnimation:_rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimating
{
    [_imageViewIn.layer removeAnimationForKey:@"rotationAnimation"];
    [_imageViewOUT.layer removeAnimationForKey:@"rotationAnimation"];
}
@end
