
//
//  YiRefreshFooter.m
//  YiRefresh
//
//  Created by apple on 15/3/6.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//
//YiRefresh is a simple way to use pull-to-refresh.下拉刷新，大道至简，最简单的网络刷新控件
//项目地址在：https://github.com/coderyi/YiRefresh
//

#import "YiRefreshFooter.h"
#import "RefreshAnimationView.h"
#define kRefreshHeaderTitleLoading @"正在加载..."
#define kRefreshHeaderTitleEnd     @"已加载全部"

#define kTextColor MakeColor(127, 127, 127, 1)

@interface YiRefreshFooter (){
    
    float contentHeight;
    float scrollFrameHeight;
    float footerHeight;
    float scrollWidth;
    BOOL isAdd;//是否添加了footer,默认是NO
    BOOL isRefresh;//是否正在刷新,默认是NO
    
    UIView *footerView;
//    UIActivityIndicatorView *activityView;
    UILabel *footerLabel;
    RefreshAnimationView *footerIV;
}
@end

@implementation YiRefreshFooter

- (void)footer
{
    scrollWidth=_scrollView.frame.size.width;
    footerHeight=40;
    scrollFrameHeight=_scrollView.frame.size.height;
    isAdd=NO;
    isRefresh=NO;
    footerView=[[UIView alloc] init];

    float labelWidth=100;
    float imageWidth=25;
   
    
    footerIV=[[RefreshAnimationView alloc] initWithFrame:CGRectMake(scrollWidth/2-imageWidth/2, (footerHeight-imageWidth)/2, imageWidth, imageWidth)];
    
    footerLabel=[[UILabel alloc] initWithFrame:CGRectMake((scrollWidth-labelWidth)/2, footerIV.bottom+5, labelWidth, footerHeight)];
    [footerView addSubview:footerLabel];
    footerLabel.textAlignment=NSTextAlignmentCenter;
    footerLabel.text=kRefreshHeaderTitleLoading;
    footerLabel.font=[UIFont systemFontOfSize:12];
    footerLabel.textColor=kTextColor;
    
//    footerIV.image=[UIImage imageNamed:@"loading1.png"];
//    
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    for (int i=1; i<=7; i++)
//    {
//        NSString *str = [NSString stringWithFormat:@"loading%d.png",i];
//        [arr addObject:[UIImage imageNamed:str]];
//    }
//    footerIV.animationImages = arr;
//    footerIV.animationDuration = 0.12;
//    footerIV.animationRepeatCount = 0;
    [footerView addSubview:footerIV];

    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![@"contentOffset" isEqualToString:keyPath]) return;
    contentHeight=_scrollView.contentSize.height;
    if(contentHeight < _scrollView.height)
        contentHeight = _scrollView.height;
    if (!isAdd) {
        isAdd=YES;
        footerView.frame=CGRectMake(0, contentHeight, scrollWidth, footerHeight);
        [_scrollView addSubview:footerView];
    }
    
    footerView.frame=CGRectMake(0, contentHeight, scrollWidth, footerHeight);
    int currentPostion = _scrollView.contentOffset.y;
    // 进入刷新状态
    if ((currentPostion>(contentHeight-scrollFrameHeight))&&(contentHeight>scrollFrameHeight)) {
        [self beginRefreshing];
    }
}

/**
 *  开始刷新操作  如果正在刷新则不做操作
 */
- (void)beginRefreshing
{
    if (!isRefresh && !_reachedTheEnd) {
        isRefresh=YES;
        [footerIV startAnimating];
        //        设置刷新状态_scrollView的位置
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentInset=UIEdgeInsetsMake(0, 0, footerHeight, 0);
        }];
        //        block回调
        _beginRefreshingBlock();
    }
}

/**
 *  关闭刷新操作  请加在UIScrollView数据刷新后，如[tableView reloadData];
 */
- (void)endRefreshing
{
    if(!isRefresh)return;
    
    isRefresh=NO;
    [footerIV stopAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
            footerView.frame=CGRectMake(0, contentHeight, [[UIScreen mainScreen] bounds].size.width, footerHeight);
        }];
    });
}

- (void)endRefreshingWithResponsed:(void(^)())responsed
{
    
    if(!isRefresh)return;
    
    isRefresh=NO;
    [footerIV stopAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
            footerView.frame=CGRectMake(0, contentHeight, [[UIScreen mainScreen] bounds].size.width, footerHeight);
        } completion:^(BOOL finished) {
            if (responsed) {
                responsed();
            }
        }];
    });

}
- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}


- (void)setReachedTheEnd:(BOOL)reachedTheEnd
{
    _reachedTheEnd = reachedTheEnd;
    footerIV.hidden = _reachedTheEnd;
    footerLabel.text =_reachedTheEnd?kRefreshHeaderTitleEnd:kRefreshHeaderTitleLoading;
}

@end
