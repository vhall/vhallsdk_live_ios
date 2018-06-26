//
//  VHLiveChatView.m
//  VhallIphone
//
//  Created by dev on 16/8/3.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import "VHLiveChatView.h"
#import "VHChatTableViewCell.h"
@interface VHLiveChatView ()<UITableViewDelegate,UITableViewDataSource>
{
    __weak UITableView * _tableView;
    
    NSInteger(^_number)();
    VHActMsg*(^_msgSource)(NSInteger index);
    
}
@property(nonatomic,copy) void(^action)(ChatViewActionType type ,NSString * userId ,NSString * nickName);
@end
@implementation VHLiveChatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        CGRect rect = {{0,frame.size.height},{frame.size.width,0}};
        UITableView * view = [[UITableView alloc] initWithFrame:self.bounds];
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.backgroundColor = [UIColor clearColor];
//        view.bounces = NO;
        view.showsVerticalScrollIndicator = NO;
        view.delegate = self;
        view.dataSource = self;
        [self addSubview:view];
        _tableView = view;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame msgTotal:(NSInteger(^)())number msgSource:(VHActMsg*(^)(NSInteger index))msg action:(void(^)(ChatViewActionType type ,NSString * userId ,NSString * nickNam))action
{
    self = [self initWithFrame:frame];
    if (self) {
        _number = number;
        _msgSource = msg;
        _action = action;
    }
    return self;
}
- (void)update
{
    _tableView.estimatedRowHeight = 0;
    [_tableView reloadData];
    [_tableView layoutIfNeeded];
    if (_tableView.contentSize.height<self.height) {
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.height = _tableView.contentSize.height;
            _tableView.bottom = self.height;
        }];
    }else
    {
        _tableView.frame = self.bounds;
        [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height - _tableView.height) animated:YES];
    }
}
#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _number();
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHActMsg * msg = _msgSource(indexPath.row);
    NSString * identifier = @"identifier";
    switch (msg.type) {
        case ActMsgTypeMsg:{
            identifier = VHChatMsgIdentifier;
        }break;
        case ActMsgTypeOnline:{
            identifier = VHChatOnlineIdentifier;
        }break;
        case ActMsgTypePay:{
            identifier = VHChatPayIdentifier;
        }break;
        case ActMsgTypeQuestion:{
            identifier = VHChatQuestionIdentifier;
        }break;
        default:
            break;
    }
    VHChatSingleSideTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[VHChatSingleSideTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    __weak __typeof(self) weakself = self;
    cell.headerViewAction = ^(NSString * userId){
        weakself.action == nil?:weakself.action(ChatViewActionTypeCheckUser,userId,nil);
    };
    cell.bgViewAction = ^(NSString * userId,NSString * userName){
        weakself.action == nil?:weakself.action(ChatViewActionTypeTalkTo,userId,userName);
    };
    cell.msg = msg;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VHChatSingleSideTableViewCell getCellHeight:_msgSource(indexPath.row)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
