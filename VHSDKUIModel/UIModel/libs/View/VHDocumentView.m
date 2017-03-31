//
//  VHDocumentView.m
//  UIModel
//
//  Created by vhall on 17/3/21.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "VHDocumentView.h"
#import "VHDrawView.h"
#import "UIImageView+WebCache.h"
@interface VHDocumentView()
@property(nonatomic,strong) VHDrawView *pptDrawView;
@property(nonatomic,strong) UIView     *boardContainer;//白板容器
@property(nonatomic,strong) VHDrawView *boardDrawView;
@end

@implementation VHDocumentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImagePath:(NSString *)imagePath
{
    _imagePath = imagePath;
     self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
    
    
}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    
//}

- (void)drawDocHandList:(NSArray*)docList whiteBoardHandList:(NSArray*)boardList
{
    

    //NSLog(@"%lu %lu",(unsigned long)docList.count,(unsigned long)boardList.count);
    if(docList)
    {
        if(!_pptDrawView)
        {
            _pptDrawView = [[VHDrawView alloc]init];
            _pptDrawView.backgroundColor = [UIColor clearColor];
            [self addSubview:_pptDrawView];
        }
         _pptDrawView.drawData = docList;
        [self pptDrawPoint];
       
        [self bringSubviewToFront:_pptDrawView];
    }
    else
    {
        [_pptDrawView removeFromSuperview];
        _pptDrawView = nil;
    }
    
    
    if (boardList)
    {
        if (!_boardContainer)
        {
            _boardContainer =[[UIView alloc] initWithFrame:self.bounds];
            _boardContainer.backgroundColor=MakeColorRGB(0xe2e8eb);
            [self addSubview:_boardContainer];
        }
        if (!_boardDrawView)
        {
            _boardDrawView =[[VHDrawView alloc] init];
            _boardDrawView.backgroundColor = [UIColor whiteColor];
        }
        [_boardContainer addSubview:_boardDrawView];
         _boardDrawView.drawData = boardList;
        [self whiteBoardPoint];
        [self bringSubviewToFront:_boardContainer];
    }else
    {
        [_boardContainer removeFromSuperview];
        _boardContainer =nil;
    }

}

-(void)layoutSubviews
{
//    if (_pptDrawView) {
//         _pptDrawView.frame = CGRectMake(0,0,self.image.size.width,self.image.size.height);
//    }
    
    [self pptDrawPoint];
    [self whiteBoardPoint];
}

-(void)pptDrawPoint
{
    if (_pptDrawView)
    {
        _pptDrawView.transform = CGAffineTransformIdentity;
        _pptDrawView.frame = CGRectMake(0,0,self.image.size.width,self.image.size.height);
       
        float s  = self.width/self.image.size.width;
        float s1 = self.height/self.image.size.height;
        s = (s<s1)?s:s1;
        _pptDrawView.transform = CGAffineTransformMakeScale(s,s);
        _pptDrawView.center = CGPointMake(self.width/2,self.height/2);
    }
}

-(void)whiteBoardPoint
{
    if (_boardContainer)
    {
        [_boardContainer setFrame:self.bounds];
        _boardDrawView.transform = CGAffineTransformIdentity;
        _boardDrawView.frame =CGRectMake(0,0,1024,768);
        float s  = _boardContainer.width/1024;
        float s1 = _boardContainer.height/768;
        s = (s<s1)?s:s1;
        _boardDrawView.transform = CGAffineTransformMakeScale(s,s);
        _boardDrawView.center = CGPointMake(_boardContainer.width/2,_boardContainer.height/2);
    }
}


@end
