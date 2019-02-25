//
//  VHPullingRefreshTableView.h
//  VhallIphone
//
//  Created by vhall on 15/8/3.
//  Copyright (c) 2015年 www.vhall.com. All rights reserved.
//

@protocol VHPullingRefreshTableViewDelegate;


@interface VHPullingRefreshTableView : UITableView
@property (nonatomic) BOOL isHasHead;
@property (nonatomic) BOOL isHasFoot;
@property (nonatomic) BOOL reachedTheEnd;
@property(nonatomic) BOOL  canLoadData;

@property(atomic)NSInteger tag1;//预留参数
@property(atomic)NSInteger tag2;//预留参数
@property(atomic)id        tagID;//预留对象参数

@property(atomic)int  type;//0,粉丝 1，直播 2，关注
@property(atomic)int  startPos;//数据开始位置
@property(atomic)BOOL isFirstUpdate;//数据开始位置
@property(strong,nonatomic)NSMutableArray* dataArr;//数据
@property (weak,nonatomic) id <VHPullingRefreshTableViewDelegate> pullingDelegate;

-(id)initWithFrame:(CGRect)frame pullingDelegate:(id<VHPullingRefreshTableViewDelegate>)pullingDelegate;
-(id)initWithFrame:(CGRect)frame pullingDelegate:(id<VHPullingRefreshTableViewDelegate>)pullingDelegate headView:(BOOL)isHas footView:(BOOL)isHasfoot;
- (void)tableViewDidFinishedLoading;
- (void)tableViewDidFinishedLoadingResponsed:(void(^)())responsed;
- (void)launchRefreshing;
@end


@protocol VHPullingRefreshTableViewDelegate<NSObject>

@optional
- (void)pullingTableViewDidStartRefreshing:(VHPullingRefreshTableView *)tableView;//下拉刷新
- (void)pullingTableViewDidStartLoading:(VHPullingRefreshTableView *)tableView;//上拉加载
@end
