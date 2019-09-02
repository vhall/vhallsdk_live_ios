//
//  WatchLiveOnlineTableViewCell.m
//  VHallSDKDemo
//
//  Created by Ming on 16/8/25.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import "WatchLiveOnlineTableViewCell.h"

@implementation WatchLiveOnlineTableViewCell
{
    __weak IBOutlet UILabel *lblShow;
    __weak IBOutlet UILabel *lblState;
    
    NSString* userName;
    NSString* room;
    NSString* event;
    NSString* time;
    NSString* role;
    NSString* concurrent_user;
    NSString* attend_count;
}

- (id)init
{
    self = [[meetingResourcesBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    if (self) {
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    userName        = @"";
    room            = @"";
    event           = @"";
    time            = @"";
    role            = @"";
    concurrent_user = @"";
    attend_count    = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    userName = _model.user_name;
    room = _model.room;
    time = _model.time;
    concurrent_user = _model.concurrent_user;
    attend_count = _model.attend_count;
    
    if([_model.event isEqualToString:@"online"]) {
        event = @"进入";
    }else if([_model.event isEqualToString:@"offline"]){
        event = @"离开";
    }
    
    if([_model.role isEqualToString:@"host"]) {
        role = @"主持人";
    }else if([_model.role isEqualToString:@"guest"]) {
        role = @"嘉宾";
    }else if([_model.role isEqualToString:@"assistant"]) {
        role = @"助手";
    }else if([_model.role isEqualToString:@"user"]) {
        role = @"观众";
    }

    if (!userName) {
        userName = @"";
    }
    
    lblShow.text = [NSString stringWithFormat:@"%@[%@] %@房间:%@", userName, role, event, room];
    lblState.text = [NSString stringWithFormat:@"在线:%@ 参会:%@ %@", concurrent_user, attend_count, time];
}

@end
