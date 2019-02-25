/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "FacialView.h"
//[UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait


#define NumPerLine 7
#define Lines    3
#define VHScreenWidth   ([UIScreen mainScreen].bounds.size.width)
//#define FaceSize  VHScreenWidth/7
///*
// ** 两边边缘间隔
// */
//#define EdgeDistance 0
///*
// ** 上下边缘间隔
// */
//#define EdgeInterVal 0

@interface FacialView ()
{
    float FaceSizeWidth;
    float FaceSizeHeight;
    float EdgeDistance;
    float EdgeInterVal;
}
@end

@implementation FacialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadFaceDic];
        
        if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
            FaceSizeWidth = 30;
            FaceSizeHeight = 30;
            EdgeDistance= 20;
            EdgeInterVal= 20;
        }
        else
        {
            FaceSizeWidth = VHScreenWidth/7;
            FaceSizeHeight = 40;
            EdgeDistance= 0;
            EdgeInterVal= 10;
        }
    }
    return self;
}

-(void)loadFaceDic
{
    _faceDic = [NSDictionary dictionaryWithContentsOfFile:[meetingResourcesBundle pathForResource:@"faceExpression" ofType:@"plist"]];
}


//给faces设置位置
-(void)loadFacialView:(int)page size:(CGSize)size
{
    int maxRow = 5;
    int maxCol = 8;
    CGFloat itemWidth = self.frame.size.width / maxCol;
    CGFloat itemHeight = self.frame.size.height / maxRow;
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setBackgroundColor:[UIColor clearColor]];
    [deleteButton setFrame:CGRectMake((maxCol - 1) * itemWidth, (maxRow - 1) * itemHeight, itemWidth, itemHeight)];
    [deleteButton setImage:[UIImage imageNamed:@"UIModel.bundle/faceDelete"] forState:UIControlStateNormal];
    deleteButton.tag = 10000;
    [deleteButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    
    
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setFrame:CGRectMake((maxCol - 2) * itemWidth - 10, (maxRow - 1) * itemHeight + 5, itemWidth + 10, itemHeight - 10)];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundColor:[UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0]];
    [self addSubview:sendButton];
    
    for (int row = 0; row < maxRow; row++) {
        for (int col = 0; col < maxCol; col++) {
            int index = row * maxCol + col;
            if (index < [_faces count]) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundColor:[UIColor clearColor]];
                [button setFrame:CGRectMake(col * itemWidth, row * itemHeight, itemWidth, itemHeight)];
                [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
                [button setTitle: [_faces objectAtIndex:(row * maxCol + col)] forState:UIControlStateNormal];
                button.tag = row * maxCol + col;
                [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            }
            else{
                break;
            }
        }
    }
}

-(void)loadFaceWithPageIndex:(NSInteger)index
{
    // 水平间隔
    CGFloat horizontalInterval = (CGRectGetWidth(self.bounds)-NumPerLine*FaceSizeWidth -2*EdgeDistance)/(NumPerLine-1);
    // 上下垂直间隔
    CGFloat verticalInterval = (CGRectGetHeight(self.bounds)-2*EdgeInterVal -Lines*FaceSizeHeight)/(Lines-1);
    
//    verticalInterval -= 10;
    
//    NSLog(@"%f,%f",verticalInterval,CGRectGetHeight(self.bounds));
    
    for (int i = 0; i<Lines; i++)
    {
        for (int x = 0;x<NumPerLine;x++)
        {
            UIButton *expressionButton =[UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:expressionButton];
            [expressionButton setFrame:CGRectMake(x*FaceSizeWidth+EdgeDistance+x*horizontalInterval,
                                                  i*FaceSizeHeight +i*verticalInterval+EdgeInterVal,
                                                   FaceSizeWidth,
                                                  FaceSizeHeight)];
            
            if (i*7+x+1 ==21) {
                [expressionButton setImage:[UIImage imageNamed:@"UIModel.bundle/faceDelete"]
                                            forState:UIControlStateNormal];
                //   expressionButton.tag = 10000;
                
                //加一个虚按钮   便于删除按钮灵活
                UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
                CGRect rect = expressionButton.frame;
                rect.origin.x -= 10;
                rect.origin.y -= 10;
                rect.size.width += 20;
                rect.size.height += 20;
                delButton.frame = rect;
                delButton.tag = 10000;
                [delButton addTarget:self
                              action:@selector(selected:)
                    forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:delButton];
                
                
            }else{
                NSString *imageStr = [NSString stringWithFormat:@"UIModel.bundle/Expression_%d",
                                      index*20+i*7+x+1];
                [expressionButton setImage:[UIImage imageNamed:imageStr]
                                            forState:UIControlStateNormal];

                
                expressionButton.tag = 20*index+i*7+x+1;
            }
            [expressionButton addTarget:self
                                 action:@selector(faceClick:)
                       forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}

- (void)faceClick:(UIButton *)button
{
    if (button.tag == 10000 && _delegate) {
        [_delegate deleteSelected:nil];
    }else{
        
        NSString *expressstring = [NSString stringWithFormat:@"Expression_%d",button.tag];
        
        NSString *faceName;
        for (int j = 0; j<[[_faceDic allValues]count]-1; j++)
        {
            NSString *value = [[_faceDic allValues] objectAtIndex:j];
            if ([value isEqualToString:expressstring])
            {
                faceName = [[_faceDic allKeys] objectAtIndex:j];
                break;
            }
            //            if ([[_faceDic objectForKey:[[_faceDic allKeys]objectAtIndex:j]]
            //                 isEqualToString:[NSString stringWithFormat:@"%@",expressstring]])
            //            {
            //                faceName = [[_faceDic allKeys]objectAtIndex:j];
            //                break;
            //            }
        }
        
        //    NSString *str = [_faceDic objectAtIndex:button.tag];
        if (_delegate) {
            [_delegate selectedFacialView:faceName];
        }
    }
}

-(void)selected:(UIButton*)bt
{
    if (bt.tag == 10000 && _delegate) {
        [_delegate deleteSelected:nil];
    }else{
        NSString *str = [_faces objectAtIndex:bt.tag];
        if (_delegate) {
            [_delegate selectedFacialView:str];
        }
    }
}

- (void)sendAction:(id)sender
{
    if (_delegate) {
        [_delegate sendFace];
    }
}

@end
