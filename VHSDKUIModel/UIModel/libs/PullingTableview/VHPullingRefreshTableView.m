//
//  VHPullingRefreshTableView.m
//  VhallIphone
//
//  Created by vhall on 15/8/3.
//  Copyright (c) 2015年 www.vhall.com. All rights reserved.
//

#import "VHPullingRefreshTableView.h"
#import "YiRefreshHeader.h"
#import "YiRefreshFooter.h"

@interface VHPullingRefreshTableView()
{
    YiRefreshHeader *_headerView;
    YiRefreshFooter *_footerView;
}
@end
@implementation VHPullingRefreshTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame pullingDelegate:(id<VHPullingRefreshTableViewDelegate>)pullingDelegate
{
    return [self initWithFrame:frame pullingDelegate:pullingDelegate headView:YES footView:YES];
}

-(id)initWithFrame:(CGRect)frame pullingDelegate:(id<VHPullingRefreshTableViewDelegate>)pullingDelegate headView:(BOOL)isHas footView:(BOOL)isHasfoot
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _pullingDelegate = pullingDelegate;
        self.isHasHead = isHas;
        self.isHasFoot = isHasfoot;
    }
    return self;
}

- (void)headRefresh
{
    if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartRefreshing:)]) {
        [_pullingDelegate pullingTableViewDidStartRefreshing:self];
    }
}

- (void)footRefresh
{
    if(_reachedTheEnd)
        return;
    
    if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartLoading:)]) {
        [_pullingDelegate pullingTableViewDidStartLoading:self];
    }
}

- (void)setIsHasHead:(BOOL)isHasHead
{
    _isHasHead = isHasHead;
    if(_isHasHead)
    {
        if(_headerView == nil)
        {
            _headerView=[[YiRefreshHeader alloc] init];
            _headerView.scrollView=self;
            [_headerView header];
            typeof(self) __weak weakSelf = self;
            _headerView.beginRefreshingBlock=^(){
                [weakSelf performSelectorOnMainThread:@selector(headRefresh) withObject:nil waitUntilDone:YES];
            };
        }
    }
    else
    {
        _headerView = nil;
    }
}

- (void)setIsHasFoot:(BOOL)isHasFoot
{
    _isHasFoot = isHasFoot;
    if (_isHasFoot)
    {
        if(_footerView == nil)
        {
            _footerView=[[YiRefreshFooter alloc] init];
            _footerView.scrollView=self;
            
           
           
            [_footerView footer];
            if(self.contentSize.height < self.height)
            {
                self.contentSize = CGSizeMake(self.width, self.height);
            }
            
            typeof(self) __weak weakSelf = self;
            _footerView.beginRefreshingBlock=^(){
                [weakSelf performSelectorOnMainThread:@selector(footRefresh) withObject:nil waitUntilDone:YES];
            };
        }
    }
    else
    {
        _footerView = nil;
    }
}

- (void)setReachedTheEnd:(BOOL)reachedTheEnd
{
    _reachedTheEnd = reachedTheEnd;
    if(_footerView)
    {
        _footerView.reachedTheEnd = reachedTheEnd;
    }
}

- (void)tableViewDidFinishedLoading
{
    if(_headerView)
    {
        [_headerView endRefreshing];
    }
    if(_footerView)
    {
        [_footerView endRefreshing];
    }
}
- (void)tableViewDidFinishedLoadingResponsed:(void(^)())responsed
{
    if(_headerView)
    {
        [_headerView endRefreshingWithResponsed:responsed];
    }
    if(_footerView)
    {
        [_footerView endRefreshingWithResponsed:responsed];

    }
}
- (void)launchRefreshing
{
    if(_headerView)
    {
        [_headerView beginRefreshing];
    }
}

@end
