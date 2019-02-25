//
//  YiRefreshHeader.m
//  YiRefresh
//
//  Created by apple on 15/3/6.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//
//YiRefresh is a simple way to use pull-to-refresh.下拉刷新，大道至简，最简单的网络刷新控件
//项目地址在：https://github.com/coderyi/YiRefresh
//

#import "YiRefreshHeader.h"
#import "RefreshAnimationView.h"
#define kRefreshHeaderTitleLoading @"正在刷新"
#define kRefreshHeaderTitlePullDown @"下拉刷新"
#define kRefreshHeaderTitleRelease @"松开后刷新"

#define kTextColor MakeColor(127, 127, 127, 1)

@interface YiRefreshHeader (){
    
    float lastPosition;
    
    float contentHeight;
    float headerHeight;
    BOOL isRefresh;//是否正在刷新,默认是NO
    
    UILabel *headerLabel;
    UIView *headerView;
    RefreshAnimationView *headerIV;

}

@end

@implementation YiRefreshHeader

- (id)init
{
    self = [super init];
    if (self) {
        _titleLoading=kRefreshHeaderTitleLoading;
        _titlePullDown=kRefreshHeaderTitlePullDown;
        _titleRelease=kRefreshHeaderTitleRelease;
    }
    return self;
}

- (void)header
{
    isRefresh=NO;
    lastPosition=0;
    headerHeight=40;
    float scrollWidth=_scrollView.frame.size.width;
    float imageWidth=25;
    float labelWidth=100;

    headerView=[[UIView alloc] initWithFrame:CGRectMake(0, -headerHeight-10, _scrollView.frame.size.width, headerHeight)];
    [_scrollView addSubview:headerView];

    headerLabel=[[UILabel alloc] initWithFrame:CGRectMake(scrollWidth/2-labelWidth/2, 15, labelWidth, headerHeight)];
    [headerView addSubview:headerLabel];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.text=_titlePullDown;
    headerLabel.font=[UIFont systemFontOfSize:12];
    headerLabel.textColor=kTextColor;

    headerIV=[[RefreshAnimationView alloc] initWithFrame:CGRectMake(scrollWidth/2-imageWidth/2, 0, imageWidth, imageWidth)];
//
//    headerIV.image=[UIImage imageNamed:@"loading1.png"];
//    
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    for (int i=1; i<=7; i++)
//    {
//        NSString *str = [NSString stringWithFormat:@"loading%d.png",i];
//        [arr addObject:[UIImage imageNamed:str]];
//    }
//    headerIV.animationImages = arr;
//    headerIV.animationDuration = 0.15;
//    headerIV.animationRepeatCount = 0;
    [headerView addSubview:headerIV];

    // 为_scrollView设置KVO的观察者对象，keyPath为contentOffset属性
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];

}

/**
 *  当属性的值发生变化时，自动调用此方法
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![@"contentOffset" isEqualToString:keyPath]) return;
    // 获取_scrollView的contentSize
    contentHeight=_scrollView.contentSize.height;

    // 判断是否在拖动_scrollView
    if (_scrollView.dragging) {
        int currentPostion = _scrollView.contentOffset.y;
        // 判断是否正在刷新  否则不做任何操作
        if (!isRefresh) {
            [UIView animateWithDuration:0.3 animations:^{
                // 当currentPostion 小于某个值时 变换状态
                if (currentPostion<-headerHeight*1.5) {
                    headerLabel.text=_titleRelease;
                }else {
                    int currentPostion = _scrollView.contentOffset.y;
                    // 判断滑动方向 以让“松开以刷新”变回“下拉可刷新”状态
                    if (currentPostion - lastPosition > 5) {
                        lastPosition = currentPostion;
                        headerLabel.text=_titlePullDown;
                    }else if (lastPosition - currentPostion > 5) {
                        lastPosition = currentPostion;
                    }
                }
            }];
        }
    }else {
        // 进入刷新状态
        if ([headerLabel.text isEqualToString:_titleRelease]) {
            [self beginRefreshing];
        }
    }
}

/**
 *  开始刷新操作  如果正在刷新则不做操作
 */
- (void)beginRefreshing
{
    if (!isRefresh) {
        isRefresh=YES;
        headerLabel.text=_titleLoading;
        [headerIV startAnimating];
        // 设置刷新状态_scrollView的位置
        [UIView animateWithDuration:0.3 animations:^{
            //修改有时候refresh contentOffset 还在0，0的情况 20150723
            CGPoint point= _scrollView.contentOffset;
            if (point.y>-headerHeight*1.5) {
                _scrollView.contentOffset=CGPointMake(0, point.y-headerHeight*1.5);
            }
            _scrollView.contentInset=UIEdgeInsetsMake(headerHeight*1.5, 0, 0, 0);
        }];
        
        // block回调
        if (self.beginRefreshingBlock) {
            self.beginRefreshingBlock();
        }
//        _beginRefreshingBlock();
    }

}

/**
 *  关闭刷新操作  请加在UIScrollView数据刷新后，如[tableView reloadData];
 */
- (void)endRefreshing{
    if(!isRefresh)return;
    
    isRefresh=NO;
    [headerIV stopAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint point= _scrollView.contentOffset;
            if (point.y!=0) {
                _scrollView.contentOffset=CGPointMake(0, point.y+headerHeight*1.5);
            }
            headerLabel.text=_titlePullDown;
            _scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
        }];
    });
}

- (void)endRefreshingWithResponsed:(void(^)())responsed
{
    if(!isRefresh)return;
    
    isRefresh=NO;
    [headerIV stopAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint point= _scrollView.contentOffset;
            if (point.y!=0) {
                _scrollView.contentOffset=CGPointMake(0, point.y+headerHeight*1.5);
            }
            headerLabel.text=_titlePullDown;
            _scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);

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

@end
