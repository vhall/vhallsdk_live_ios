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

#import "DXFaceView.h"

#define FaceSectionBarHeight  36   // 表情下面控件
#define FacePageControlHeight 30  // 表情pagecontrol

#define Pages 5

@interface DXFaceView ()
{
    FacialView *_facialView;
}

@end

@implementation DXFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        _facialView = [[FacialView alloc] initWithFrame: CGRectMake(5, 5, frame.size.width - 10, self.bounds.size.height - 10)];
        //        [_facialView loadFacialView:1 size:CGSizeMake(30, 30)];
        //        _facialView.delegate = self;
        //        [self addSubview:_facialView];
        
        
        
        _faceScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, self.bounds.size.height)];
        _faceScrollView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f
                                                          green:247.0f/255.0f
                                                           blue:247.0f/255.0f
                                                          alpha:1.0f];
        _faceScrollView.delegate = self;
        [self addSubview:_faceScrollView];
        [_faceScrollView setPagingEnabled:YES];
        [_faceScrollView setShowsHorizontalScrollIndicator:NO];
        [_faceScrollView setContentSize:CGSizeMake(CGRectGetWidth(_faceScrollView.frame)*Pages,CGRectGetHeight(_faceScrollView.frame))];
        
        for (int i= 0;i<Pages;i++) {
            FacialView *faceView = [[FacialView alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(self.bounds),0.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(_faceScrollView.bounds)-FacePageControlHeight)];
            [faceView loadFaceWithPageIndex:i];
            [_faceScrollView addSubview:faceView];
            faceView.delegate = self;
        }
        
        _facePageControl = [[UIPageControl alloc]init];
        [_facePageControl setFrame:CGRectMake(0,CGRectGetMaxY(_faceScrollView.frame) - 30,CGRectGetWidth(self.bounds),FacePageControlHeight)];
        [self addSubview:_facePageControl];
        [_facePageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_facePageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
        _facePageControl.numberOfPages = Pages;
        _facePageControl.currentPage   = 0;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:216.0f/255.0f
                                                   green:216.0f/255.0f
                                                    blue:216.0f/255.0f
                                                   alpha:1.0f];
        [self addSubview:lineView];
    }
    return self;
}

#pragma mark  scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/320;
    _facePageControl.currentPage = page;
    
}


#pragma mark - FacialViewDelegate

-(void)selectedFacialView:(NSString*)str{
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:NO];
    }
}

-(void)deleteSelected:(NSString *)str{
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:YES];
    }
}

- (void)sendFace
{
    if (_delegate) {
        [_delegate sendFace];
    }
}

#pragma mark - public

- (BOOL)stringIsFace:(NSString *)string
{
    if ([_facialView.faces containsObject:string]) {
        return YES;
    }
    
    return NO;
}

@end
