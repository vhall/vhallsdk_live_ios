//
//  BaseViewController.h
//  PublishDemo
//
//  Created by liwenlong on 15/10/9.
//  Copyright (c) 2015年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VHBaseViewController : UIViewController
@property(nonatomic,assign)UIInterfaceOrientation interfaceOrientation;

- (void)showMsg:(NSString*)msg afterDelay:(NSTimeInterval)delay;
-(void) showRendererMsg:(NSString*)msg afterDelay:(NSTimeInterval)delay;
@end
