//
//  MBHUDHelper.h
//  iplaza
//
//  Created by Rush.D.Xzj on 4/27/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface MBHUDHelper : NSObject

+ (void)showWarningWithText:(NSString *)text;
+ (void)showWarningWithText:(NSString *)text delegate:(id<MBProgressHUDDelegate>)delegate;

@end
