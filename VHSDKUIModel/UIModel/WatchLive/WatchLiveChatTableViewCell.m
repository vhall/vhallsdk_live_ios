//
//  WatchLiveChatTableViewCell.m
//  VHallSDKDemo
//
//  Created by Ming on 16/8/25.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import "WatchLiveChatTableViewCell.h"
#import "MLEmojiLabel.h"
#import "UIImageView+WebCache.h"

@implementation WatchLiveChatTableViewCell
{
    __weak IBOutlet UIImageView *pic;
    __weak IBOutlet UILabel *lblNickName;
    __weak IBOutlet UILabel *lblTime;
    __weak IBOutlet UILabel *lblContext;
    MLEmojiLabel *_textLabel;
    UIImage *image;
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
    image = nil;
      [self layoutIfNeeded];
    if(!_textLabel)
    {
        _textLabel = [MLEmojiLabel new];
        _textLabel.numberOfLines = 1;
        
//        _textLabel.font = lblContext.font;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _textLabel.isNeedAtAndPoundSign = NO;
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _textLabel.customEmojiPlistName = @"faceExpression.plist";
        _textLabel.customEmojiBundleName = @"UIModel.bundle";
        _textLabel.userInteractionEnabled=NO;
        _textLabel.disableThreeCommon = YES;
        _textLabel.frame = lblContext.frame;
        [self.contentView addSubview:_textLabel];
        lblContext.hidden = YES;
    }
//    _textLabel.text = @"[惊讶]";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    if([_model isKindOfClass:[VHallCustomMsgModel class]])
    {
        VHallCustomMsgModel *model = (VHallCustomMsgModel *)_model;
        pic.image = nil;
        lblNickName.text = @"【用户自定义消息】";
        lblNickName.textColor = [UIColor redColor];
        lblTime.text = model.time;
        //内容
        _textLabel.text = [model.jsonstr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        [_textLabel sizeToFit];
    }
    else{
        [pic sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:[UIImage imageNamed:@"UIModel.bundle/head50"]];
        lblNickName.text = _model.user_name;
        lblTime.text = _model.time;
        lblNickName.textColor = [UIColor blackColor];
        //内容
        [_textLabel setText:_model.text];
        
        NSLog(@"************ %@",_model.text);
        
        [_textLabel sizeToFit];
    }
}

@end
