//
//  WatchLiveSurveyTableViewCell.m
//  UIModel
//
//  Created by chickenrungo on 2017/3/6.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "WatchLiveSurveyTableViewCell.h"
#import <VHLiveSDK/VHallApi.h>
@implementation WatchLiveSurveyTableViewCell



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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)surveyItemClickBtn:(id)sender
{
    _clickSurveyItem(_model);
}

@end
