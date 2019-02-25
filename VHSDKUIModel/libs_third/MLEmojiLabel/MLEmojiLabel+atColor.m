//
//  MLEmojiLabel+atColor.m
//  VhallIphone
//
//  Created by vhall on 16/8/19.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import "MLEmojiLabel+atColor.h"

@implementation MLEmojiLabel (atColor)
-(void)setAtColor:(UIColor *)atColor
{
    NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
    [mutableLinkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    NSMutableDictionary *mutableInactiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableInactiveLinkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    UIColor *commonLinkColor = atColor;
    
    //点击时候的背景色
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithWhite:0.631 alpha:1.000] CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
    
    if ([NSMutableParagraphStyle class]) {
        [mutableLinkAttributes setObject:commonLinkColor forKey:(NSString *)kCTForegroundColorAttributeName];
        [mutableActiveLinkAttributes setObject:commonLinkColor forKey:(NSString *)kCTForegroundColorAttributeName];
        [mutableInactiveLinkAttributes setObject:[UIColor grayColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        
        
        //把原有TTT的NSMutableParagraphStyle设置给去掉了。会影响到整个段落的设置
    } else {
        [mutableLinkAttributes setObject:(__bridge id)[commonLinkColor CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        [mutableActiveLinkAttributes setObject:(__bridge id)[commonLinkColor CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        [mutableInactiveLinkAttributes setObject:(__bridge id)[[UIColor grayColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        
        
        //把原有TTT的NSMutableParagraphStyle设置给去掉了。会影响到整个段落的设置
    }
    
    self.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes];
    self.activeLinkAttributes = [NSDictionary dictionaryWithDictionary:mutableActiveLinkAttributes];
    self.inactiveLinkAttributes = [NSDictionary dictionaryWithDictionary:mutableInactiveLinkAttributes];
}
@end
