//
//  VHChatTableViewCell.m
//  VhallIphone
//
//  Created by vhall on 15/11/27.
//  Copyright © 2015年 www.vhall.com. All rights reserved.
//

#import "VHChatTableViewCell.h"
#import "MLEmojiLabel.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import <VHLiveSDK/VHallApi.h>

//获取物理屏幕的尺寸
#define VHScreenHeight  ([UIScreen mainScreen].bounds.size.height)
#define VHScreenWidth   ([UIScreen mainScreen].bounds.size.width)
#define VH_SW           ((VHScreenWidth<VHScreenHeight)?VHScreenWidth:VHScreenHeight)
#define VH_SH           ((VHScreenWidth<VHScreenHeight)?VHScreenHeight:VHScreenWidth)
#define VH_RATE_SCALE   (VH_SW/375.0)//以ip6为标准 ip5缩小 ip6p放大 zoom

#define VH_userId       [VHallApi currentUserID]

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//rgb颜色转换（16进制->10进制）
#define _UIColorFromHexadecimal(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define  TEXT_Font [UIFont systemFontOfSize:14]//[UIFont fontWithName:@"Heiti SC" size:14]
#define  USER_Font [UIFont systemFontOfSize:13]//[UIFont fontWithName:@"Heiti SC" size:13]

#define  front 15
#define  UISTEP 7.5
#define  FULL_UISTEP  0
#define  FULL_Q_UISTEP  2.5//全屏问答

#define  FULL_ICON_W 30
#define  FULL_Q_ICON_W 25//全屏问答

#define  bgH 13
#define  ICON_W 34*VH_RATE_SCALE
#define  MIN_CHAT_BG_W  44*VH_RATE_SCALE
#define  MAX_CHAT_BG_W  216*VH_RATE_SCALE
#define  FULL_MAX_CHAT_BG_W  280

#define  MAX_Online_BG_W  280*VH_RATE_SCALE
#define  MAX_pay_BG_W  250//*VH_RATE_SCALE
#define  Online_H  40

#define VHRES_personPlaceHold_Image [UIImage imageNamed:@"UIModel.bundle/head50"]


NSString * const VHChatMsgIdentifier = @"VHChatMsgIdentifier";
NSString * const VHChatOnlineIdentifier = @"VHChatOnlineIdentifier";
NSString * const VHChatPayIdentifier = @"VHChatPayIdentifier";
NSString * const VHChatQuestionIdentifier =  @"VHChatQuestionIdentifier";\
static MLEmojiLabel  *g_textLabel;

@implementation VHChatTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
- (instancetype)initChatCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)bgAction
{
    if (_bgViewAction) {
        _bgViewAction(_msg.formUserId,_msg.formUserName);
    }
}
-(void)heardAction
{
    if (_headerViewAction) {
        _headerViewAction(_msg.formUserId);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
+ (CGFloat)getCellHeight:(VHActMsg *)pollingDate
{
    return 0.0;
}

//CGSizeMake(width, MAXFLOAT)
+ (CGSize)calStrSize:(NSString*)str width:(CGFloat)width font:(UIFont*)font
{
    if(str == nil || font == nil)
        return CGSizeZero;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [str boundingRectWithSize: CGSizeMake(width, MAXFLOAT)
                                    options: (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine)
                                 attributes: attributes
                                    context: nil].size;
    return size;
}
//CGSizeMake(MAXFLOAT, MAXFLOAT)
+(CGSize)calStrSize:(NSString*)str font:(UIFont*)font
{
    if(str == nil || font == nil)
        return CGSizeZero;
    
    return [VHChatTableViewCell calStrSize:str width:MAXFLOAT font:font];
    
    //    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:font}];
    //    return size;
}


@end

#pragma mark - DoubleDideCell
@interface VHChatDSMsgTableViewCell:VHChatDoubleSideTableViewCell<MLEmojiLabelDelegate>
{
    UIButton * _bgView;
    UIButton * _headerBtn;
    UILabel  * _nameLabel;
    MLEmojiLabel * _textLabel;
}
@end

@interface VHChatDSOnlineTableViewCell:VHChatDoubleSideTableViewCell
{
    UIButton * _bgView;
    UIButton * _headerBtn;
    UILabel *_textLabel;
}

@end

@interface VHChatDSPayTableViewCell:VHChatDoubleSideTableViewCell
{
    UIButton * _bgView;
    UIButton * _headerBtn;
    UILabel  * _nameLabel;
    UIImageView *_giftImage;
    MLEmojiLabel * _textLabel;
    UILabel  *_giftCount;
    
}
@end
@interface VHChatDSQuestionTableViewCell:VHChatDoubleSideTableViewCell
{
    UIView     *_bgView;
    UILabel         *_qLabel;
    UIImageView     *_qImageView;
}
@end


@implementation VHChatDoubleSideTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if ([reuseIdentifier isEqualToString:VHChatMsgIdentifier]) {
        return [[VHChatDSMsgTableViewCell alloc] initChatCellWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    if ([reuseIdentifier isEqualToString:VHChatOnlineIdentifier]) {
        return [[VHChatDSOnlineTableViewCell alloc] initChatCellWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    if ([reuseIdentifier isEqualToString:VHChatPayIdentifier]) {
        return [[VHChatDSPayTableViewCell alloc] initChatCellWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    if ([reuseIdentifier isEqualToString:VHChatQuestionIdentifier]) {
        return [[VHChatDSQuestionTableViewCell alloc] initChatCellWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    return [super initWithStyle:style reuseIdentifier:reuseIdentifier];
}
+ (CGFloat)getCellHeight:(VHActMsg *)pollingDate
{
    CGFloat h = 0;
    if(pollingDate == nil)
        return h;
    
    if(pollingDate.type == ActMsgTypeMsg)
    {
        if(g_textLabel == nil)
        {
            g_textLabel = [MLEmojiLabel new];
            g_textLabel.numberOfLines = 0;
            g_textLabel.font = TEXT_Font;
            g_textLabel.lineBreakMode = NSLineBreakByCharWrapping;
            g_textLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
            g_textLabel.customEmojiPlistName = @"faceExpression.plist";
            g_textLabel.customEmojiBundleName = @"UIModel.bundle";
        }
        g_textLabel.frame = CGRectMake(0, 0, MAX_CHAT_BG_W-2*UISTEP, 14);
        [g_textLabel setText:pollingDate.text];
        @try {[g_textLabel sizeToFit];} @catch (NSException* e) {}
        
        h = g_textLabel.height+15+2*UISTEP+2*bgH;
        if( [pollingDate.formUserId isEqualToString:VH_userId])
        {
            h = g_textLabel.height+2*UISTEP+2*bgH;
        }
    }
    else if(pollingDate.type == ActMsgTypeOnline)
    {
        h =  [VHChatTableViewCell calStrSize:pollingDate.text font:TEXT_Font].height+2*bgH+2*UISTEP;
    }
    else if(pollingDate.type == ActMsgTypePay)
    {
        if(g_textLabel == nil)
        {
            g_textLabel = [MLEmojiLabel new];
            g_textLabel.numberOfLines = 0;
            g_textLabel.font = TEXT_Font;
            g_textLabel.lineBreakMode = NSLineBreakByCharWrapping;
            g_textLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
            g_textLabel.customEmojiPlistName = @"faceExpression.plist";
            g_textLabel.customEmojiBundleName = @"UIModel.bundle";
        }
        g_textLabel.frame = CGRectMake(0, 0, MAX_CHAT_BG_W-2*UISTEP, 14);
        [g_textLabel setText:[NSString stringWithFormat:@"赏给主播 大红包"]];
        @try {[g_textLabel sizeToFit];} @catch (NSException* e) {}
        
        h = 60*VH_RATE_SCALE+UISTEP;
        
    }
    else if(pollingDate.type == ActMsgTypeQuestion)
    {
        h =  Online_H+2*UISTEP;
    }
    //    NSLog(@"%f",h);
    return h;
}

@end
@implementation VHChatDSMsgTableViewCell
- (instancetype)initChatCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if ((self = [super initChatCellWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _bgView = [[UIButton alloc]init];
        [_bgView addTarget:self action:@selector(bgAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_bgView];
        _headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ICON_W, ICON_W)];
        _headerBtn.layer.cornerRadius = _headerBtn.width/2;
        [_headerBtn addTarget:self action:@selector(heardAction) forControlEvents:UIControlEventTouchUpInside];
        _headerBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:_headerBtn];
        _textLabel = [MLEmojiLabel new];
        _textLabel.numberOfLines = 0;
        _textLabel.font = TEXT_Font;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _textLabel.isNeedAtAndPoundSign = YES;
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _textLabel.customEmojiPlistName = @"faceExpression.plist";
        _textLabel.customEmojiBundleName = @"UIModel.bundle";
        _textLabel.userInteractionEnabled=NO;
        _textLabel.disableThreeCommon = YES;
        [_bgView addSubview:_textLabel];
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.numberOfLines=1;
        _nameLabel.textColor = _UIColorFromHexadecimal(0x9c9ca0, 1);
        [_bgView addSubview:_nameLabel];
    }
    return  self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //头像
    if(self.msg.formUserIcon && self.msg.formUserIcon.length > 0 )
    {
        [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.msg.formUserIcon] forState:UIControlStateNormal placeholderImage:VHRES_personPlaceHold_Image];
    }
    else
    {
        [_headerBtn setBackgroundImage:VHRES_personPlaceHold_Image forState:UIControlStateNormal];
    }
    
    //用户名
    if( ![self.msg.formUserId isEqualToString:VH_userId])
    {
        [_bgView setBackgroundImage:[[UIImage imageNamed:@"UIModel.bundle/chat_other.tiff"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 5, 5)]forState:UIControlStateNormal];
        _nameLabel.text = self.msg.formUserName;
        CGSize titleSize = [VHChatTableViewCell calStrSize:_nameLabel.text font:_nameLabel.font];
        if(titleSize.width>MAX_CHAT_BG_W- front - UISTEP)
            titleSize.width = MAX_CHAT_BG_W-front - UISTEP;
        _nameLabel.frame = CGRectMake(front, UISTEP,  titleSize.width, 12);
        _nameLabel.hidden = NO;
    }
    else
    {
        [_bgView setBackgroundImage:[[UIImage imageNamed:@"UIModel.bundle/chat_self.tiff"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 5, 5, 20)]forState:UIControlStateNormal];
        _nameLabel.hidden = YES;
    }
    
    //内容
    _textLabel.numberOfLines = 0;
    _textLabel.frame = CGRectMake(0, 0, MAX_CHAT_BG_W-2*UISTEP, 14);
    [_textLabel setText:self.msg.text];
    @try {[_textLabel sizeToFit];} @catch (NSException* e) {}
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //布局
    float contentView_width = (_nameLabel.width>_textLabel.width)?_nameLabel.width:_textLabel.width;
    contentView_width += (front + UISTEP);
    if( [self.msg.formUserId isEqualToString:VH_userId])
    {
        contentView_width = _textLabel.width+front + UISTEP;
        //        if(contentView_width < MIN_CHAT_BG_W)
        //            contentView_width = MIN_CHAT_BG_W;
        _headerBtn.frame = CGRectMake(VH_SW-_headerBtn.width-UISTEP, UISTEP, _headerBtn.width, _headerBtn.height);
        _bgView.frame = CGRectMake(VH_SW-contentView_width-_headerBtn.width-front-UISTEP, _headerBtn.top,
                                   contentView_width, _textLabel.height+2*bgH);
        _textLabel.frame = CGRectMake(UISTEP, bgH, _textLabel.width, _textLabel.height);
    }
    else
    {
        //        if(contentView_width < MIN_CHAT_BG_W)
        //            contentView_width = MIN_CHAT_BG_W;
        //        if(contentView_width > MAX_CHAT_BG_W)
        //            contentView_width = MAX_CHAT_BG_W;
        
        _headerBtn.frame = CGRectMake(UISTEP, UISTEP, _headerBtn.width, _headerBtn.height);
        _nameLabel.frame = CGRectMake(front, bgH,  _nameLabel.width, 12);
        _bgView.frame = CGRectMake(_headerBtn.right+UISTEP, _headerBtn.top,
                                   contentView_width, _textLabel.height+_nameLabel.height+2*bgH);
        
        _textLabel.frame = CGRectMake(front, bgH+_nameLabel.height+3, _textLabel.width, _textLabel.height);
    }
}
@end
@implementation VHChatDSOnlineTableViewCell
- (instancetype)initChatCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if ((self = [super initChatCellWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _bgView = [[UIButton alloc]init];
        [_bgView addTarget:self action:@selector(bgAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_bgView];
        _headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ICON_W, ICON_W)];
        _headerBtn.layer.cornerRadius = _headerBtn.width/2;
        [_headerBtn addTarget:self action:@selector(heardAction) forControlEvents:UIControlEventTouchUpInside];
        _headerBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:_headerBtn];
        _textLabel = [UILabel new];
        _textLabel.numberOfLines = 0;
        _textLabel.font = TEXT_Font;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.userInteractionEnabled=NO;
        [_bgView addSubview:_textLabel];
    }
    return  self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //头像
    if(self.msg.formUserIcon && self.msg.formUserIcon.length > 0 )
    {
        [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.msg.formUserIcon] forState:UIControlStateNormal placeholderImage:VHRES_personPlaceHold_Image];
    }
    else
    {
        [_headerBtn setBackgroundImage:VHRES_personPlaceHold_Image forState:UIControlStateNormal];
    }
    _headerBtn.frame = CGRectMake(UISTEP, UISTEP, _headerBtn.width, _headerBtn.height);
    [_bgView setBackgroundImage:[[UIImage imageNamed:@"UIModel.bundle/chat_other.tiff"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 5, 5)]forState:UIControlStateNormal];
    if (iPhone5) {
        NSString *message=nil;
        if (self.msg.formUserName.length>13) {
            NSString *temp=[self.msg.formUserName  substringWithRange:NSMakeRange(0, 13)];
            message=[NSString stringWithFormat:@"%@...进来了",temp];
        }else{
            message=[NSString stringWithFormat:@"%@进来了",self.msg.formUserName];
        }
        
        CGSize size=[VHChatTableViewCell calStrSize:message font:TEXT_Font];
        if(size.width>MAX_Online_BG_W)
            size.width = MAX_Online_BG_W;
        
        _textLabel.frame = CGRectMake(front, bgH, size.width, size.height);
        _textLabel.text = message;
        _bgView.frame = CGRectMake(_headerBtn.right+UISTEP, _headerBtn.top,
                                   size.width+front+UISTEP, size.height+2*bgH);
        
    }else {
        NSString *message=nil;
        if (self.msg.formUserName.length>16) {
            NSString *temp=[self.msg.formUserName  substringWithRange:NSMakeRange(0, 16)];
            message=[NSString stringWithFormat:@"%@...进来了",temp];
        }else{
            message=[NSString stringWithFormat:@"%@进来了",self.msg.formUserName];
        }
        
        CGSize size=[VHChatTableViewCell calStrSize:message font:TEXT_Font];
        if(size.width>MAX_Online_BG_W)
            size.width = MAX_Online_BG_W;
        
        _textLabel.frame = CGRectMake(front, bgH, size.width, size.height);
        _textLabel.text = message;
        _bgView.frame = CGRectMake(_headerBtn.right+UISTEP, _headerBtn.top,
                                   size.width+front+UISTEP, size.height+2*bgH);
        
        
    }
}
@end
@implementation VHChatDSPayTableViewCell
- (instancetype)initChatCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if ((self = [super initChatCellWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _bgView = [[UIButton alloc]init];
        [_bgView addTarget:self action:@selector(bgAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_bgView];
        _headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ICON_W, ICON_W)];
        _headerBtn.layer.cornerRadius = _headerBtn.width/2;
        [_headerBtn addTarget:self action:@selector(heardAction) forControlEvents:UIControlEventTouchUpInside];
        _headerBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:_headerBtn];
        _textLabel = [MLEmojiLabel new];
        _textLabel.numberOfLines = 0;
        _textLabel.font = TEXT_Font;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _textLabel.isNeedAtAndPoundSign = YES;
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _textLabel.customEmojiPlistName = @"faceExpression.plist";
        _textLabel.customEmojiBundleName = @"UIModel.bundle";
        _textLabel.userInteractionEnabled=NO;
        _textLabel.disableThreeCommon = YES;
        [_bgView addSubview:_textLabel];
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.numberOfLines=1;
        _nameLabel.textColor = _UIColorFromHexadecimal(0x9c9ca0, 1);
        [_bgView addSubview:_nameLabel];
        
        _giftImage=[[UIImageView alloc] init];
        [_bgView addSubview:_giftImage];
        
        _giftCount=[[UILabel alloc] init];
        _giftCount.numberOfLines = 0;
        _giftCount.font = TEXT_Font;
        _giftCount.backgroundColor = [UIColor clearColor];
        _giftCount.lineBreakMode = NSLineBreakByCharWrapping;
        _giftCount.textColor = [UIColor blackColor];
        _giftCount.userInteractionEnabled=NO;
        [_bgView addSubview:_giftCount];
        
        
    }
    return  self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    //头像
    if(self.msg.formUserIcon && self.msg.formUserIcon.length > 0 )
    {
        [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.msg.formUserIcon] forState:UIControlStateNormal placeholderImage:VHRES_personPlaceHold_Image];
    }
    else
    {
        [_headerBtn setBackgroundImage:VHRES_personPlaceHold_Image forState:UIControlStateNormal];
    }
    
    //用户名
    
    [_bgView setBackgroundImage:[[UIImage imageNamed:@"UIModel.bundle/chat_other.tiff"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 5, 5)]forState:UIControlStateNormal];
    _nameLabel.text = self.msg.formUserName;
    CGSize titleSize = [VHChatTableViewCell calStrSize:_nameLabel.text font:_nameLabel.font];
    if(titleSize.width>MAX_CHAT_BG_W- front - UISTEP)
        titleSize.width = MAX_CHAT_BG_W-front - UISTEP;
    _nameLabel.frame = CGRectMake(front, UISTEP,  titleSize.width, 12);
    _nameLabel.hidden = NO;
    
    //内容
    _textLabel.numberOfLines = 0;
    _textLabel.frame = CGRectMake(0, 0, MAX_CHAT_BG_W-2*UISTEP, 14);
    
    //礼物数
    [_giftCount setText:[NSString stringWithFormat:@"x1"]];
    [_giftCount sizeToFit];
    NSString *text;
    if (self.msg.payFromType == PayFromPC)
    {
        text=@"赏给主播 大红包";
        [_giftImage setImage:[UIImage imageNamed:@"UIModel.bundle/payMessage.tiff"]];
    }else if (self.msg.payFromType == PayFromApp)
    {
        text=[NSString stringWithFormat:@"赏给主播 %@",self.msg.giftName];
        [_giftImage sd_setImageWithURL:[NSURL URLWithString:self.msg.giftUrl]];
        
    }
    
    [_textLabel setText:text];
    @try {[_textLabel sizeToFit];} @catch (NSException* e) {}
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //布局
    float contentView_width = (_nameLabel.width>_textLabel.width)?_nameLabel.width:_textLabel.width;
    contentView_width += (front + UISTEP+20+_giftCount.width+16*VH_RATE_SCALE);
    
    _headerBtn.frame = CGRectMake(UISTEP, UISTEP, _headerBtn.width, _headerBtn.height);
    _nameLabel.frame = CGRectMake(front, bgH,  _nameLabel.width, 14);
    _bgView.frame = CGRectMake(_headerBtn.right+UISTEP, _headerBtn.top,
                               contentView_width, _textLabel.height+_nameLabel.height+2*bgH);
    _textLabel.frame = CGRectMake(front, _nameLabel.bottom+7, _textLabel.width, _textLabel.height);
    [_giftImage setFrame:CGRectMake(_textLabel.right+5*VH_RATE_SCALE, _textLabel.top-1*VH_RATE_SCALE, 20*VH_RATE_SCALE, 20*VH_RATE_SCALE)];
    [_giftCount setFrame:CGRectMake(_giftImage.right+5*VH_RATE_SCALE, _textLabel.top, _giftCount.width,  20*VH_RATE_SCALE)];
    
    
}
@end
@implementation VHChatDSQuestionTableViewCell
- (instancetype)initChatCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if ((self = [super initChatCellWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = _UIColorFromHexadecimal(0xf4f4f6, 1);
        [self.contentView addSubview:_bgView];
        _qLabel = [[UILabel alloc]init];
        _qLabel.textColor = _UIColorFromHexadecimal(0x9c9ca0, 1);
        _qLabel.numberOfLines = 1;
        _qLabel.font = USER_Font;
        [_bgView addSubview:_qLabel];
        _qImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UIModel.bundle/questionMessage.tiff"]];
        _qImageView.frame =  CGRectMake(0, 0, 20, 20);
        [_qLabel addSubview:_qImageView];
    }
    return  self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    NSString * tempStr = [NSString stringWithString:self.msg.formUserName.length>0?self.msg.formUserName:@" "];
    CGSize strSize = [VHChatTableViewCell calStrSize:tempStr font:USER_Font];
    CGSize dashangSize = [VHChatTableViewCell calStrSize:@"提出了一个问题" font:USER_Font];
    CGSize diandianSize = [VHChatTableViewCell calStrSize:@"..." font:USER_Font];
    if (MAX_pay_BG_W - dashangSize.width -21- strSize.width  >  0) {
        tempStr = [NSString stringWithFormat:@"%@提出了一个问题",tempStr];
    }
    else{
        do {
            strSize = [VHChatTableViewCell calStrSize:tempStr font:USER_Font];
            
            NSInteger bit = tempStr.length -1;
            tempStr = [tempStr substringToIndex: bit ];
        } while (MAX_pay_BG_W- dashangSize.width -diandianSize.width -21 - strSize.width <  0);
        tempStr = [NSString stringWithFormat:@"%@...提出了一个问题",tempStr];
        
    }
    
    CGSize size=[VHChatTableViewCell calStrSize:tempStr font:USER_Font];
    
    
    _qLabel.text = tempStr;
    if(size.width > MAX_pay_BG_W)
        size.width = MAX_pay_BG_W;
    _qLabel.frame = CGRectMake(0, UISTEP,size.width, size.height);
    _bgView.frame = CGRectMake(0, UISTEP, _qLabel.width+_qImageView.width+35, _qImageView.height+20);
    _bgView.layer.cornerRadius = _bgView.height/2;
    _bgView.center = CGPointMake(VH_SW/2, _bgView.center.y);
    
    _qLabel.center = CGPointMake((_bgView.width-_qImageView.width)/2, Online_H/2);
    _qImageView.left = _qLabel.width+5;
    _qImageView.center = CGPointMake(_qImageView.center.x,  _qLabel.height/2);
    
}
@end
#pragma mark - SingleSideCell
@interface VHChatSSMsgTableViewCell:VHChatSingleSideTableViewCell<MLEmojiLabelDelegate>
{
    UIButton * _bgView;
    UIButton * _headerBtn;
    UILabel  * _nameLabel;
    MLEmojiLabel * _textLabel;
}
@end

@interface VHChatSSOnlineTableViewCell:VHChatSingleSideTableViewCell
{
    UIButton * _bgView;
    UIButton * _headerBtn;
}

@end

@interface VHChatSSPayTableViewCell:VHChatSingleSideTableViewCell
{
    UIButton * _bgView;
    UIButton * _headerBtn;
    UILabel  * _nameLabel;
    UIImageView *_giftImage;
    MLEmojiLabel * _textLabel;
    UILabel  *_giftCount;
}
@end
@interface VHChatSSQuestionTableViewCell:VHChatSingleSideTableViewCell
{
    UIButton * _bgView;
    UIButton * _headerBtn;
}
@end
@implementation VHChatSingleSideTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if ([reuseIdentifier isEqualToString:VHChatMsgIdentifier]) {
        return [[VHChatSSMsgTableViewCell alloc] initChatCellWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    if ([reuseIdentifier isEqualToString:VHChatOnlineIdentifier]) {
        return [[VHChatSSOnlineTableViewCell alloc] initChatCellWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    if ([reuseIdentifier isEqualToString:VHChatPayIdentifier]) {
        return [[VHChatSSPayTableViewCell alloc] initChatCellWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    if ([reuseIdentifier isEqualToString:VHChatQuestionIdentifier]) {
        return [[VHChatSSQuestionTableViewCell alloc] initChatCellWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    return [super initWithStyle:style reuseIdentifier:reuseIdentifier];
}
+ (CGFloat)getCellHeight:(VHActMsg *)pollingDate
{
    CGFloat h = 0;
    if(pollingDate == nil)
        return h;
    
    if(pollingDate.type == ActMsgTypeMsg)
    {
        if(g_textLabel == nil)
        {
            g_textLabel = [MLEmojiLabel new];
            g_textLabel.numberOfLines = 0;
            g_textLabel.font = TEXT_Font;
            g_textLabel.lineBreakMode = NSLineBreakByCharWrapping;
            g_textLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
            g_textLabel.customEmojiPlistName = @"faceExpression.plist";
            g_textLabel.customEmojiBundleName = @"UIModel.bundle";
        }
        g_textLabel.frame = CGRectMake(0, 0, FULL_MAX_CHAT_BG_W-3*UISTEP-FULL_ICON_W, 14);
        [g_textLabel setText:pollingDate.text];
        @try {[g_textLabel sizeToFit];} @catch (NSException* e) {}
        
        h = g_textLabel.height+8+2*UISTEP+2*bgH-5;
        
    }
    else if(pollingDate.type == ActMsgTypePay)
    {
        
        h =14+12+2*bgH+2*UISTEP;
    }
    else
    {
        h =  FULL_ICON_W+2*UISTEP-5;
    }
    return h;
}
@end
@implementation VHChatSSMsgTableViewCell
- (instancetype)initChatCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if ((self = [super initChatCellWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _bgView = [[UIButton alloc]init];
        [_bgView addTarget:self action:@selector(bgAction) forControlEvents:UIControlEventTouchUpInside];
        _bgView.layer.cornerRadius=5;
        _bgView.layer.masksToBounds=YES;
        [_bgView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        [self.contentView addSubview:_bgView];
        _headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FULL_ICON_W, FULL_ICON_W)];
        _headerBtn.layer.cornerRadius = _headerBtn.width/2;
        [_headerBtn addTarget:self action:@selector(heardAction) forControlEvents:UIControlEventTouchUpInside];
        _headerBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:_headerBtn];
        _textLabel = [MLEmojiLabel new];
        _textLabel.numberOfLines = 0;
        _textLabel.font = TEXT_Font;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _textLabel.isNeedAtAndPoundSign = YES;
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _textLabel.customEmojiPlistName = @"faceExpression.plist";
        _textLabel.customEmojiBundleName = @"UIModel.bundle";
        _textLabel.userInteractionEnabled=NO;
        _textLabel.disableThreeCommon = YES;
//        _textLabel.atColor = [UIColor whiteColor];
        [_bgView addSubview:_textLabel];
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = TEXT_Font;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.numberOfLines=1;
        _nameLabel.textColor = [UIColor whiteColor];
        [_bgView addSubview:_nameLabel];
    }
    return  self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //头像
    if(self.msg.formUserIcon && self.msg.formUserIcon.length > 0 )
    {
        [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.msg.formUserIcon] forState:UIControlStateNormal placeholderImage:VHRES_personPlaceHold_Image];
    }
    else
    {
        [_headerBtn setBackgroundImage:VHRES_personPlaceHold_Image forState:UIControlStateNormal];
    }
    _textLabel.textColor = self.msg.textColor;
    NSString * tempStr = [NSString stringWithString: self.msg.formUserName.length>0? self.msg.formUserName:@" "];
    
    CGSize strSize = [VHChatTableViewCell calStrSize:self.msg.formUserName font:TEXT_Font];
    
    
    if (self.width  - strSize.width - _headerBtn.right - 3*UISTEP >  0) {
        tempStr = [NSString stringWithFormat:@"%@",tempStr];
    }
    else{
        do {
            strSize = [VHChatTableViewCell calStrSize:tempStr font:USER_Font];
            
            NSInteger bit = tempStr.length -2;
            tempStr = [tempStr substringToIndex: bit ];
        } while (self.width - strSize.width -_headerBtn.right - 3*UISTEP < 0);
        tempStr = [NSString stringWithFormat:@"%@...",tempStr];
        
    }
    //用户名
    _nameLabel.text = tempStr;
    
    CGSize titleSize = [VHChatTableViewCell calStrSize:_nameLabel.text font:_nameLabel.font];
    _nameLabel.frame = CGRectMake(UISTEP, UISTEP,  titleSize.width, 12);
    _nameLabel.hidden = NO;
    _nameLabel.backgroundColor = [UIColor clearColor];
    //内容
    _textLabel.numberOfLines = 0;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.frame = CGRectMake(0, 0, self.width - _headerBtn.right - 3*UISTEP, 14);
    [_textLabel setText:self.msg.text];
    @try {[_textLabel sizeToFit];} @catch (NSException* e) {}
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //布局
    float contentView_width = (_nameLabel.width>_textLabel.width)?_nameLabel.width:_textLabel.width;
    
    
    contentView_width = (contentView_width>self.width - _headerBtn.right - 3*UISTEP)?self.width - _headerBtn.right - 3*UISTEP:contentView_width;
    _headerBtn.frame = CGRectMake(FULL_UISTEP, UISTEP, _headerBtn.width, _headerBtn.height);
    _nameLabel.frame = CGRectMake(UISTEP, UISTEP,  _nameLabel.width, 12);
    _textLabel.frame = CGRectMake(UISTEP, UISTEP+_nameLabel.bottom, contentView_width, _textLabel.height);
    _bgView.frame = CGRectMake(_headerBtn.right+UISTEP, _headerBtn.top,contentView_width+2*UISTEP, _textLabel.bottom+UISTEP);
}
@end
@implementation VHChatSSOnlineTableViewCell
- (instancetype)initChatCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if ((self = [super initChatCellWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _bgView = [[UIButton alloc]init];
        [_bgView addTarget:self action:@selector(bgAction) forControlEvents:UIControlEventTouchUpInside];
        _bgView.layer.cornerRadius=5;
        _bgView.layer.masksToBounds=YES;
        [_bgView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        _bgView.titleLabel.font = TEXT_Font;
        [_bgView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ] ;
        [self.contentView addSubview:_bgView];
        _headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FULL_ICON_W, FULL_ICON_W)];
        _headerBtn.layer.cornerRadius = _headerBtn.width/2;
        [_headerBtn addTarget:self action:@selector(heardAction) forControlEvents:UIControlEventTouchUpInside];
        _headerBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:_headerBtn];
    }
    return  self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //头像
    if(self.msg.formUserIcon && self.msg.formUserIcon.length > 0 )
    {
        [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.msg.formUserIcon] forState:UIControlStateNormal placeholderImage:VHRES_personPlaceHold_Image];
    }
    else
    {
        [_headerBtn setBackgroundImage:VHRES_personPlaceHold_Image forState:UIControlStateNormal];
    }
    _headerBtn.frame = CGRectMake(FULL_UISTEP, UISTEP, _headerBtn.width, _headerBtn.height);
    NSString * tempStr = [NSString stringWithString: self.msg.formUserName.length>0? self.msg.formUserName:@" "];
    CGSize strSize = [VHChatTableViewCell calStrSize:self.msg.formUserName font:TEXT_Font];
    CGSize dashangSize = [VHChatTableViewCell calStrSize:@"进来了" font:TEXT_Font];
    CGSize diandianSize = [VHChatTableViewCell calStrSize:@"..." font:TEXT_Font];
    if (self.width - dashangSize.width - strSize.width - _headerBtn.right - 3*UISTEP >  0) {
        tempStr = [NSString stringWithFormat:@"%@进来了",tempStr];
    }
    else{
        do {
            NSInteger bit = tempStr.length -1;
            tempStr = [tempStr substringToIndex: bit ];
            strSize = [VHChatTableViewCell calStrSize:tempStr font:TEXT_Font];
        } while (self.width - dashangSize.width - strSize.width - diandianSize.width -_headerBtn.right - 3*UISTEP < 0);
        tempStr = [NSString stringWithFormat:@"%@...进来了",tempStr];
    }
    [_bgView setTitle:tempStr forState:UIControlStateNormal ];
    CGSize size = [VHChatTableViewCell calStrSize:tempStr font:TEXT_Font];
    _bgView.frame = CGRectMake(_headerBtn.right+UISTEP, _headerBtn.top,size.width+2*UISTEP, _headerBtn.height);
}
@end
@implementation VHChatSSPayTableViewCell
- (instancetype)initChatCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if ((self = [super initChatCellWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        _bgView = [[UIButton alloc]init];
        [_bgView addTarget:self action:@selector(bgAction) forControlEvents:UIControlEventTouchUpInside];
        _bgView.layer.cornerRadius=5;
        _bgView.layer.masksToBounds=YES;
        [_bgView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        _bgView.titleLabel.font = TEXT_Font;
        [_bgView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ] ;
        [self.contentView addSubview:_bgView];
        _headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FULL_ICON_W, FULL_ICON_W)];
        [_headerBtn addTarget:self action:@selector(heardAction) forControlEvents:UIControlEventTouchUpInside];
        _headerBtn.layer.cornerRadius = _headerBtn.width/2;
        _headerBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:_headerBtn];
        
        
        _textLabel = [MLEmojiLabel new];
        _textLabel.numberOfLines = 0;
        _textLabel.font = TEXT_Font;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _textLabel.isNeedAtAndPoundSign = YES;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _textLabel.customEmojiPlistName = @"faceExpression.plist";
        _textLabel.customEmojiBundleName = @"UIModel.bundle";
        _textLabel.userInteractionEnabled=NO;
        _textLabel.disableThreeCommon = YES;
        [_bgView addSubview:_textLabel];
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.numberOfLines=1;
        _nameLabel.textColor = _UIColorFromHexadecimal(0x9c9ca0, 1);
        [_bgView addSubview:_nameLabel];
        
        _giftImage=[[UIImageView alloc] init];
        [_bgView addSubview:_giftImage];
        
        _giftCount=[[UILabel alloc] init];
        _giftCount.numberOfLines = 0;
        _giftCount.font = TEXT_Font;
        _giftCount.backgroundColor = [UIColor clearColor];
        _giftCount.lineBreakMode = NSLineBreakByCharWrapping;
        _giftCount.textColor =[UIColor whiteColor];
        _giftCount.userInteractionEnabled=NO;
        [_bgView addSubview:_giftCount];
        
        
        
    }
    return  self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //    _headerBtn.frame = CGRectMake(FULL_UISTEP, UISTEP, _headerBtn.width, _headerBtn.height);
    //    NSString * tempStr = [NSString stringWithString:self.msg.formUserName.length>0?self.msg.formUserName:@" "];
    //    CGSize strSize = [VHChatTableViewCell calStrSize:tempStr font:USER_Font];
    //    CGSize dashangSize = [VHChatTableViewCell calStrSize:@"打赏了一个红包" font:USER_Font];
    //    CGSize diandianSize = [VHChatTableViewCell calStrSize:@"..." font:USER_Font];
    //    if (self.width - dashangSize.width - strSize.width - _headerBtn.right - 3*UISTEP >  0) {
    //        tempStr = [NSString stringWithFormat:@"%@打赏了一个红包",tempStr];
    //    }
    //    else{
    //        do {
    //            strSize = [VHChatTableViewCell calStrSize:tempStr font:USER_Font];
    //
    //            NSInteger bit = tempStr.length -1;
    //            tempStr = [tempStr substringToIndex: bit ];
    //        } while (self.width - dashangSize.width - strSize.width - diandianSize.width -_headerBtn.right - 3*UISTEP < 0);
    //        tempStr = [NSString stringWithFormat:@"%@...打赏了一个红包",tempStr];
    //
    //    }
    //    [_bgView setTitle:tempStr forState:UIControlStateNormal ];
    //    CGSize size = [VHChatTableViewCell calStrSize:tempStr font:TEXT_Font];
    //    _bgView.frame = CGRectMake(_headerBtn.right+UISTEP, _headerBtn.top,size.width+2*UISTEP, _headerBtn.height);
    
    
    if (self.msg.formUserIcon && self.msg.formUserIcon.length > 0)
    {
        [_headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.msg.formUserIcon] forState:UIControlStateNormal placeholderImage:VHRES_personPlaceHold_Image];
    }else
    {
        [_headerBtn setBackgroundImage:VHRES_personPlaceHold_Image forState:UIControlStateNormal];
    }
    _nameLabel.text = self.msg.formUserName;
    CGSize titleSize = [VHChatTableViewCell calStrSize:_nameLabel.text font:_nameLabel.font];
    if(titleSize.width>MAX_CHAT_BG_W- front - UISTEP)
        titleSize.width = MAX_CHAT_BG_W-front - UISTEP;
    _nameLabel.frame = CGRectMake(front, UISTEP,  titleSize.width, 12);
    _nameLabel.hidden = NO;
    
    //内容
    _textLabel.numberOfLines = 0;
    _textLabel.frame = CGRectMake(0, 0, MAX_CHAT_BG_W-2*UISTEP, 14);
    
    //礼物数
    [_giftCount setText:[NSString stringWithFormat:@"x1"]];
    [_giftCount sizeToFit];
    NSString *text;
    if (self.msg.payFromType == PayFromPC)
    {
        text=@"赏给主播 大红包";
        [_giftImage setImage:[UIImage imageNamed:@"UIModel.bundle/payMessage.tiff"]];
    }else if (self.msg.payFromType == PayFromApp)
    {
        text=[NSString stringWithFormat:@"赏给主播 %@",self.msg.giftName];
        [_giftImage sd_setImageWithURL:[NSURL URLWithString:self.msg.giftUrl]];
        
    }
    
    [_textLabel setText:text];
    @try {[_textLabel sizeToFit];} @catch (NSException* e) {}
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //布局
    float contentView_width = (_nameLabel.width>_textLabel.width)?_nameLabel.width:_textLabel.width;
    contentView_width += (front + UISTEP+20 +_giftCount.width+16*VH_RATE_SCALE);
    
    _headerBtn.frame = CGRectMake(FULL_UISTEP, UISTEP, _headerBtn.width, _headerBtn.height);
    _nameLabel.frame = CGRectMake(front, bgH,  _nameLabel.width, 12);
    _bgView.frame = CGRectMake(_headerBtn.right+UISTEP, _headerBtn.top,
                               contentView_width, _textLabel.height+_nameLabel.height+2*bgH);
    _textLabel.frame = CGRectMake(front, bgH+_nameLabel.height+3, _textLabel.width, _textLabel.height);
    [_giftImage setFrame:CGRectMake(_textLabel.right+8*VH_RATE_SCALE, _textLabel.top, 20*VH_RATE_SCALE, 20*VH_RATE_SCALE)];
    [_giftCount setFrame:CGRectMake(_giftImage.right+8*VH_RATE_SCALE, _textLabel.top, _giftCount.width,  20*VH_RATE_SCALE)];
    
    
}
@end
@implementation VHChatSSQuestionTableViewCell
- (instancetype)initChatCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if ((self = [super initChatCellWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _bgView = [[UIButton alloc]init];
        [_bgView addTarget:self action:@selector(bgAction) forControlEvents:UIControlEventTouchUpInside];
        _bgView.layer.cornerRadius=5;
        _bgView.layer.masksToBounds=YES;
        [_bgView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        _bgView.titleLabel.font = TEXT_Font;
        [_bgView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ] ;
        [self.contentView addSubview:_bgView];
        _headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FULL_Q_ICON_W, FULL_Q_ICON_W)];
        //        _headerBtn.layer.cornerRadius = _headerBtn.width/2;
        //        [_headerBtn addTarget:self action:@selector(heardAction) forControlEvents:UIControlEventTouchUpInside];
        //        _headerBtn.layer.masksToBounds = YES;
        [_headerBtn setBackgroundImage:[UIImage  imageNamed:@"questionMessage"] forState:UIControlStateNormal];
        [self.contentView addSubview:_headerBtn];
    }
    return  self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _headerBtn.frame = CGRectMake(FULL_Q_UISTEP, UISTEP, _headerBtn.width, _headerBtn.height);
    NSString * tempStr = [NSString stringWithString:self.msg.formUserName.length>0?self.msg.formUserName:@" "];
    CGSize strSize = [VHChatTableViewCell calStrSize:tempStr font:USER_Font];
    CGSize dashangSize = [VHChatTableViewCell calStrSize:@"提出了一个问题" font:USER_Font];
    CGSize diandianSize = [VHChatTableViewCell calStrSize:@"..." font:USER_Font];
    if (self.width - dashangSize.width - strSize.width - _headerBtn.right - 3*UISTEP >  0) {
        tempStr = [NSString stringWithFormat:@"%@提出了一个问题",tempStr];
    }
    else{
        do {
            strSize = [VHChatTableViewCell calStrSize:tempStr font:USER_Font];
            
            NSInteger bit = tempStr.length -1;
            tempStr = [tempStr substringToIndex: bit ];
        } while (self.width - dashangSize.width - strSize.width - diandianSize.width -_headerBtn.right - 3*UISTEP < 0);
        tempStr = [NSString stringWithFormat:@"%@...提出了一个问题",tempStr];
        
    }
    [_bgView setTitle:tempStr forState:UIControlStateNormal ];
    CGSize size = [VHChatTableViewCell calStrSize:tempStr font:TEXT_Font];
    _bgView.frame = CGRectMake(_headerBtn.right+UISTEP, _headerBtn.top,size.width+2*UISTEP, _headerBtn.height);
    
}

@end
