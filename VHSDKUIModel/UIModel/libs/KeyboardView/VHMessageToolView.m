//
//  VHMessageToolView.m
//  vhall1
//
//  Created by vhallrd01 on 14-6-20.
//  Copyright (c) 2014年 vhallrd01. All rights reserved.
//

#import "VHMessageToolView.h"
#define CellColor       MakeColor(25, 24, 29, 1)

@implementation VHMessageToolView

- (id)initWithFrame:(CGRect)frame type:(NSInteger)type
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _type = type;
        [self setupConfigure];
    }
    _maxLength = 70;
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    [super setFrame:frame];
    self.toolBackGroundView.width = self.width;
    _cancelButton.left = CGRectGetWidth(self.bounds) - 55;
}

- (void)setupConfigure
{
    
    self.activityButtomView = nil;
    self.isShowButtomView = NO;
    
    
    self.toolBackGroundView = [[UIView alloc] init];
    self.toolBackGroundView.frame = CGRectMake(0, 0,
                                               self.frame.size.width,
                                               kVerticalPadding*2+kInputTextViewMinHeight);
    if (_type == 1)
    {
        self.toolBackGroundView.backgroundColor = CellColor;
    }
    else if(_type == 2)
    {
        self.toolBackGroundView.backgroundColor = [UIColor whiteColor];
    }else if (_type==3)
    {
        self.toolBackGroundView.backgroundColor=MakeColorRGB(0xf3f4f6);
    }
    
    [self addSubview:self.toolBackGroundView];
    
    //初始化输入框
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(/*[VH_Device_OS_ver floatValue] < 8.0 && */orientation != UIInterfaceOrientationPortrait)
    {  _msgTextView = nil;
        CGFloat textViewWidth= VH_SH - 100;
        _msgTextView = [[VHMessageTextView alloc] initWithFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, textViewWidth, kInputTextViewMinHeight)];
        //        NSLog(@"sfsdfsd +++%f",VHScreenHeight- 100);
        self.maxTextInputViewHeight = 5*4+16*3;
    }
    else {
        _msgTextView = [[VHMessageTextView alloc] initWithFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, self.width - 100, kInputTextViewMinHeight)];
        self.maxTextInputViewHeight = 5*4+16*3;
        
    }
    //    _msgTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //    self.inputTextView.contentMode = UIViewContentModeCenter;
    _msgTextView.scrollEnabled = YES;
    _msgTextView.returnKeyType = UIReturnKeySend;
    _msgTextView.enablesReturnKeyAutomatically = YES;
    _msgTextView.backgroundColor = [UIColor whiteColor];
    _msgTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _msgTextView.layer.borderWidth = 0.65f;
    _msgTextView.layer.cornerRadius = 6.0f;
    _msgTextView.delegate = self;
    [self.toolBackGroundView addSubview:_msgTextView];
    
    _previousTextViewContentHeight = [self getTextViewContentH:_msgTextView];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitle:@"发送" forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
     [_cancelButton setUserInteractionEnabled:NO];
    
    if (_type ==3) {
        [_cancelButton setTitleColor:MessageTool_SendBtnColor forState:UIControlStateNormal];
          [_cancelButton setUserInteractionEnabled:YES];
    }else
    {
        [_cancelButton setTitleColor:MessageTool_SendBtnColor forState:UIControlStateNormal];
    }
    
    _cancelButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 55 ,
                                     kVerticalPadding,
                                     50,
                                     kInputTextViewMinHeight);
    [_cancelButton addTarget:self
                      action:@selector(sendButtonTouchUpInside:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.toolBackGroundView addSubview:_cancelButton];

    _smallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (_type ==3) {
        [_smallButton setBackgroundImage: [UIImage imageNamed:@"UIModel.bundle/message_emoji.tiff"] forState:UIControlStateNormal];
    }else
    {
        [_smallButton setBackgroundImage: [UIImage imageNamed:@"UIModel.bundle/message_emoji.tiff"] forState:UIControlStateNormal];
    }
    
    
    [_smallButton setBackgroundImage: [UIImage imageNamed:@"UIModel.bundle/live_keyboard.tiff"] forState:UIControlStateSelected];
    [_smallButton addTarget:self
                     action:@selector(buttonAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [_smallButton setFrame:CGRectMake(13, 10, 30, 30)];
    [self.toolBackGroundView addSubview:_smallButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}
-(UIView *)faceView
{
    DXFaceView *faceView = [[DXFaceView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.frame.size.width, 170)];
    [faceView setDelegate:self];
    faceView.backgroundColor = [UIColor lightGrayColor];
    faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    return faceView;
}
- (void)buttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    if (button.selected)
    {
        
        [_msgTextView resignFirstResponder];
        
        
        [self willShowBottomView:self.faceView];
        _msgTextView.hidden = !button.selected;

//        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            _msgTextView.hidden = !button.selected;
//        } completion:^(BOOL finished) {
//            
//        }];
    }
    else
    {
        
        [_msgTextView becomeFirstResponder];
        
        //   [self willShowBottomView:nil];
        
    }
}

-(void)beginTextViewInView
{
   
    
    if (_smallButton.selected)
    {
        [_msgTextView resignFirstResponder];
        
        [self willShowBottomView:self.faceView];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _msgTextView.hidden = !_smallButton.selected;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [_msgTextView becomeFirstResponder];
    }
}


-(void)beginFaceViewInView
{
    _smallButton.selected = !_smallButton.selected;
    
    if (_smallButton.selected)
    {
        [_msgTextView resignFirstResponder];
        
        [self willShowBottomView:self.faceView];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _msgTextView.hidden = !_smallButton.selected;
        } completion:^(BOOL finished) {
          
        }];
    }
    else
    {
        [_msgTextView becomeFirstResponder];
    }
}

#pragma mark - DXFaceDelegate

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    if (![self textView:_msgTextView shouldChangeTextInRange:NSMakeRange(_msgTextView.text.length, str.length) replacementText:str]) {
        return;
    }
    NSString *chatText = _msgTextView.text;
    
    if (!isDelete && str.length > 0) {
        _msgTextView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
    }
    else {
        
        
        if (chatText.length >= 2)
        {
            NSInteger toIndex = 0;
            BOOL findSatrFace = NO;
            BOOL findEndFace = NO;
            
            NSString *temp = [chatText substringWithRange:NSMakeRange([chatText length] - 1, 1)];
            if ([temp isEqualToString:@"]"])
            {
                findSatrFace = YES;
            }
            
            
            for (NSInteger i=[chatText length]-1; i>=0; i--)
            {
                NSString *temp = [chatText substringWithRange:NSMakeRange(i, 1)];
                if([temp isEqualToString:@"["])
                {
                    toIndex = i;
                    findEndFace = YES;
                    break;
                }
            }
            
            
            if (findSatrFace && findEndFace)
            {
                _msgTextView.text = [chatText substringToIndex:toIndex];
                return;
            }
            
            //            NSString *subStr = [chatText substringFromIndex:chatText.length-2];
            //            if ([(DXFaceView *)self.faceView stringIsFace:subStr]) {
            //                _msgTextView.text = [chatText substringToIndex:chatText.length-2];
            //
            //                return;
            //            }
        }
        
        if (chatText.length > 0) {
            _msgTextView.text = [chatText substringToIndex:chatText.length-1];
        }
    }
    
    [self textViewDidChange:_msgTextView];
}

- (void)sendFace
{
    NSString *chatText = _msgTextView.text;
    if (chatText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:chatText];
            _msgTextView.text = @"";
            [_msgTextView resignFirstResponder];
            [self willShowInputTextViewToHeight:[self getTextViewContentH:_msgTextView]];;
        }
    }
}


- (void)willShowBottomView:(UIView *)bottomView
{
    if (![self.activityButtomView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self willShowBottomHeight:bottomHeight];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.toolBackGroundView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
            
            _faceRect = rect;
        }
        
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
    }
}

- (void)sendButtonTouchUpInside:(id)sender
{
    //    if (_delegate && [_delegate respondsToSelector:@selector(cancelTextView)])
    //    {
    //        [_delegate cancelTextView];
    //    }
    
    if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
        [self.delegate didSendText:_msgTextView.text];
        self.msgTextView.text = @"";
        [self endEditing:NO];
        [_cancelButton setTitleColor:MessageTool_SendBtnColor forState:UIControlStateNormal];
        [_cancelButton setUserInteractionEnabled:NO];
        if (_type == 3) {
             [_cancelButton setUserInteractionEnabled:YES];
        }
        
        [self willShowInputTextViewToHeight:[self getTextViewContentH:self.msgTextView]];;
    }
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if([VH_Device_OS_ver floatValue] < 8.0 && orientation != UIInterfaceOrientationPortrait)
    {
        endFrame = CGRectMake(endFrame.origin.y, endFrame.origin.x, endFrame.size.height, endFrame.size.width);
        beginFrame = CGRectMake(beginFrame.origin.y, beginFrame.origin.x, beginFrame.size.height, beginFrame.size.width);
    }
    
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:toFrame.size.height];
        
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:beginFrame.size.height];
    }
    else
    {
        [self willShowBottomHeight:toFrame.size.height];
    }
}

#pragma mark - change frame

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolBackGroundView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    if(bottomHeight == 0 && self.frame.size.height == self.toolBackGroundView.frame.size.height)
    {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    }
    else{
        self.isShowButtomView = YES;
    }
    
    
    self.frame = toFrame;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
        [_delegate didChangeFrameToHeight:toHeight];
    }
}

- (void)setMaxTextInputViewHeight:(CGFloat)maxTextInputViewHeight
{
    if (maxTextInputViewHeight > kInputTextViewMaxHeight) {
        maxTextInputViewHeight = kInputTextViewMaxHeight;
    }
    _maxTextInputViewHeight = maxTextInputViewHeight;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_smallButton setSelected:NO];
    [textView becomeFirstResponder];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    if (!_smallButton.selected && _delegate && [_delegate respondsToSelector:@selector(cancelTextView)])
    {
        [_delegate cancelTextView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView isFirstResponder]) {
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] ||
            ![[textView textInputMode] primaryLanguage]) {
            return NO;
        }
    }
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:textView.text];
            self.msgTextView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.msgTextView]];
        }
        
        return NO;
    }
    if (textView.text.length >=_maxLength&&text.length>0)
    {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    

    if (textView.text.length > 0)
    {
        if ([VHMessageToolView isHaveEmoji:textView.text]) {
            textView.text = [VHMessageToolView disableEmoji:textView.text];
            return;
        }
        if (textView.text.length >_maxLength)
        {
            textView.text=[textView.text substringToIndex:_maxLength];
            [textView.undoManager removeAllActions];
        }
        
        
        
        if (_type == 1)
        {
            [_cancelButton setTitleColor:MessageTool_SendBtnColor
                                forState:UIControlStateNormal];
        }
        else if(_type == 2)
        {
            [_cancelButton setTitleColor:MessageTool_SendBtnColor forState:UIControlStateNormal];
        }else if (_type ==3)
        {
            [_cancelButton setTitleColor:MessageTool_SendBtnColor forState:UIControlStateNormal];
        }
        
        
        
        
        
        [_cancelButton setUserInteractionEnabled:YES];
    }
    else
    {
        [_cancelButton setTitleColor: MessageTool_SendBtnColor forState:UIControlStateNormal];
         [_cancelButton setUserInteractionEnabled:NO];
        
        if (_type ==3) {//私信输入框 无内容时可以点击
            
            [_cancelButton setTitleColor:MessageTool_SendBtnColor forState:UIControlStateNormal];
            [_cancelButton setUserInteractionEnabled:YES];
        }
        
       
    }
    
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

- (void)resetMessageTextHeight
{
    [self willShowInputTextViewToHeight:[self getTextViewContentH:_msgTextView]];;
}
- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
    }
    if (toHeight > self.maxTextInputViewHeight) {
        toHeight = self.maxTextInputViewHeight;
    }
    
    
    if (toHeight == _previousTextViewContentHeight)
    {
        if (toHeight <=36) {
            
            self.msgTextView.frame = CGRectMake(kHorizontalPadding, kVerticalPadding, self.msgTextView.frame.size.width, kInputTextViewMinHeight);
            self.msgTextView.contentSize = CGSizeMake(self.msgTextView.contentSize.width, kInputTextViewMinHeight);
            [self.msgTextView setContentOffset:CGPointMake(0.0f, 0.0f ) animated:YES];


        }
        else
        {
            [self.msgTextView setContentOffset:CGPointMake(0.0f, (self.msgTextView.contentSize.height - self.msgTextView.frame.size.height)-5 ) animated:YES];

        }

        return;
    }
    else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.toolBackGroundView.frame;
        rect.size.height += changeHeight;
        self.toolBackGroundView.frame = rect;
        
        
        _previousTextViewContentHeight = toHeight;
        
        if (rect.size.height-18<=kInputTextViewMinHeight) {
            self.msgTextView.frame = CGRectMake(kHorizontalPadding, kVerticalPadding, self.msgTextView.frame.size.width, kInputTextViewMinHeight);
            
            
        }
        else
        {
            self.msgTextView.frame = CGRectMake(kHorizontalPadding, kVerticalPadding, self.msgTextView.frame.size.width, rect.size.height-20);
            
        }
        [self.msgTextView setContentOffset:CGPointMake(0.0f, (self.msgTextView.contentSize.height - self.msgTextView.frame.size.height) / 2) animated:YES];

        
        if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
            [_delegate didChangeFrameToHeight:self.frame.size.height];
        }
    }
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    return ceilf([textView sizeThatFits:textView.frame.size].height);
}

+ (CGFloat)defaultHeight
{
    return kVerticalPadding * 2 + kInputTextViewMinHeight;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    _delegate = nil;
    _msgTextView.delegate = nil;
    _msgTextView = nil;
}


- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    
    _smallButton.selected = NO;
    [self willShowBottomView:nil];
    
    return result;
}

- (void)addKeyBoardNoti
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)removeKeyBoardNoti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [self endEditing:NO];
}



+ (BOOL)isHaveEmoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return ![modifiedString isEqualToString:text];
}

+ (NSString *)disableEmoji:(NSString *)text
{
    if(text == nil) return nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    //    @"小明 ‍韓國米思納美品牌創始人"@"黄经纬 ‍太陽熊搬家™️"
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"‍"];
    modifiedString = [[modifiedString componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    return modifiedString;
}
@end
