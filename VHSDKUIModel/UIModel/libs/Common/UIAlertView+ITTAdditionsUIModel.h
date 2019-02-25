//
//  UIAlertView+ITTAdditions.h
//
//  Created by lwl on 3/15/12.
//  Copyright (c) 2012 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (ITTAdditionsUIModel)

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg;

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg cancelButtonTitle:(NSString*)btnTitle;

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg Tag:(NSInteger)tag;

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel others:(NSString *)others, ...;

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg Tag:(NSInteger)tag cancel:(NSString *)cancel others:(NSString *)others, ... ;

@end
