//
//  VHMessageTextView.m
//  vhall1
//
//  Created by vhallrd01 on 14-6-20.
//  Copyright (c) 2014年 vhallrd01. All rights reserved.
//

#import "VHMessageTextView.h"

@implementation VHMessageTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

+ (NSUInteger)maxCharactersPerLine {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 32 : 109;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    if ([placeHolder isEqualToString:_placeHolder])
    {
        return;
    }
    
    NSUInteger maxChars = [VHMessageTextView maxCharactersPerLine];
    if ([placeHolder length] > maxChars)
    {
        placeHolder = [placeHolder substringToIndex:maxChars-8];
        placeHolder = [[placeHolder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAppendingFormat:@"..."];
    }
    
    _placeHolder = placeHolder;
    [self setNeedsDisplay];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    if ([placeHolderColor isEqual:_placeHolderColor])
    {
        return;
    }
    
    _placeHolderColor = placeHolderColor;
    [self setNeedsDisplay];
}

- (NSUInteger)numberLinesOfText
{
    return (self.text.length / [VHMessageTextView maxCharactersPerLine]) + 1;
    
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

- (void)setUp
{
    //观察textview输入变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChangeNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    _placeHolderColor = [UIColor colorWithRed:80.0f/255.0f
                                        green:80.0f/255.0f
                                         blue:80.0f/255.0f
                                        alpha:1.0f];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 10, 8);
    self.contentInset = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.userInteractionEnabled = YES;
    self.font = [UIFont systemFontOfSize:16.0f];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeySend;
    self.textAlignment = NSTextAlignmentLeft;
    
}

- (void)textDidChangeNotification:(NSNotification *)notification
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:CGRectMake(0, 0, 468, 36)];
    
    if (self.text.length == 0 && self.placeHolder)
    {
        CGRect placeHolderRect = CGRectMake(10, 7, rect.size.width, rect.size.height);
        
        [self.placeHolderColor set];
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_0)
        {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            paragraphStyle.alignment = self.textAlignment;
            
            [self.placeHolder drawInRect:CGRectMake(0, 0, 468, 36)
                          withAttributes:@{ NSFontAttributeName : self.font,
                                            NSForegroundColorAttributeName : self.placeHolderColor,
                                            NSParagraphStyleAttributeName : paragraphStyle }];
        }
        else
        {
            [self.placeHolder drawInRect:CGRectMake(0, 0, 468, 36)
                                withFont:self.font
                           lineBreakMode:NSLineBreakByTruncatingTail
                               alignment:self.textAlignment];
            
        }
        
    }
}

- (void)dealloc
{
    self.placeHolder = nil;
    self.placeHolderColor = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:self];
}

@end
