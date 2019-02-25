//
//  VHMessageTextView.h
//  vhall1
//
//  Created by vhallrd01 on 14-6-20.
//  Copyright (c) 2014年 vhallrd01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VHMessageTextView : UITextView

@property (strong, nonatomic) NSString *placeHolder;

@property (strong, nonatomic) UIColor *placeHolderColor;

//自身文本占据的行数
- (NSUInteger)numberLinesOfText;

//每行文本的高度
+ (NSUInteger)maxCharactersPerLine;

@end
