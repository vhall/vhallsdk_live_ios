//
//  VHSettingTableViewCell.m
//  VHallSDKDemo
//
//  Created by yangyang on 2017/2/13.
//  Copyright © 2017年 vhall. All rights reserved.
//

#import "VHSettingTableViewCell.h"
#import "VHSettingItem.h"
#import "VHSettingArrowItem.h"
#import "VHSettingTextFieldItem.h"
#define MakeColorRGB(hex)  ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:1.0])
@interface VHSettingTableViewCell ()<UITextFieldDelegate>
@property(nonatomic,strong) UILabel  *titleLabel;
@property(nonatomic,strong) UILabel  *videoResulotionLabel;

@end

@implementation VHSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self= [ super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UITextField *field = [[UITextField alloc] init];
        field.layer.borderWidth=1;
        field.clearButtonMode =UITextFieldViewModeWhileEditing;
        field.textColor =MakeColorRGB(0x9d9da0);
        field.textAlignment=NSTextAlignmentRight;
        field.delegate = self;
        field.layer.borderColor=[UIColor clearColor].CGColor;
        [self.contentView addSubview:field];
        _textField = field;
        
        UIView  *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, 1)];
        line.backgroundColor=MakeColorRGB(0xf5f5f5);
        line.alpha=0.6;
        [self.contentView addSubview:line];
        
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:titleLabel];
        _titleLabel =titleLabel;
        
        
        UILabel *videoResulotionLabel = [[UILabel alloc] init];
        [videoResulotionLabel setFont:[UIFont systemFontOfSize:14]];
        [videoResulotionLabel setTextColor:MakeColorRGB(0x9d9da0)];
        videoResulotionLabel.textAlignment=NSTextAlignmentRight;
        _videoResulotionLabel =videoResulotionLabel;
        
    }
    return self;
}


+(instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style
{
    static   NSString *ID = @"cell";
    VHSettingTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell= [[VHSettingTableViewCell alloc] initWithStyle:style reuseIdentifier:ID];
    }
    return cell;
}

+(instancetype)cellWithTableView:(UITableView*)tableView
{
    return [VHSettingTableViewCell cellWithTableView:tableView style:UITableViewCellStyleValue1];
}

-(void)setItem:(VHSettingItem *)item
{
    _item = item;
    self.titleLabel.text = item.title;
    [self.titleLabel sizeToFit];
    [self setupRightView];
}

-(void)setupRightView
{
    if ([_item isKindOfClass:[VHSettingArrowItem class]])
    {
        self.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    }else if ([_item isKindOfClass:[VHSettingTextFieldItem class]])
    {
        VHSettingTextFieldItem *tempItem = (VHSettingTextFieldItem*)_item;
        if ((_item.indexPath.section == 1 && _item.indexPath.row ==2)  ||
            (_item.indexPath.section == 2 && _item.indexPath.row ==0)   ||
            (_item.indexPath.section == 2 && _item.indexPath.row ==1) )
        {
            [_textField removeFromSuperview];
            [self.contentView addSubview:_videoResulotionLabel];
            [_videoResulotionLabel setText:tempItem.text];
        }
        else
        {
            _textField.text = tempItem.text;
            [_videoResulotionLabel removeFromSuperview];
            [self.contentView addSubview:_textField];
        }
    }else
    {
        self.accessoryView = nil;
    }
}

-(void)layoutSubviews
{
    
    [_titleLabel setFrame:CGRectMake(15, 15, _titleLabel.width, 20)];
    [_textField setFrame:CGRectMake(_titleLabel.right+5, 6, [UIScreen mainScreen].bounds.size.width-_titleLabel.width-10-15, 40)];
    [_videoResulotionLabel setFrame:_textField.frame];
}




-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _inputText([NSString stringWithFormat:@"%@",textField.text]);
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    _changePosition(textField);
}
@end
