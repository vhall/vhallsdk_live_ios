//
//  UIAlertView+ITTAdditions.m
//
//  Created by lwl on 3/15/12.
//  Copyright (c) 2012 vhall. All rights reserved.
//

#import "UIAlertView+ITTAdditionsUIModel.h"

@implementation UIAlertView (ITTAdditionsUIModel)

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg
                                                   delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];	
}

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg cancelButtonTitle:(NSString*)btnTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg
                                                   delegate:delegate cancelButtonTitle:btnTitle otherButtonTitles: nil];
    [alert show];
}

+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg Tag:(NSInteger)tag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg
                                                   delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles: nil];
    alert.tag = tag;
    [alert show];
}


+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel others:(NSString *)others, ... {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg
                                                    delegate:delegate cancelButtonTitle:cancel otherButtonTitles:others, nil];
    [alert show];	
}


+ (void) popupAlertByDelegate:(id)delegate title:(NSString *)title message:(NSString *)msg Tag:(NSInteger)tag cancel:(NSString *)cancel others:(NSString *)others, ... {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg
                                                   delegate:delegate cancelButtonTitle:cancel otherButtonTitles:others, nil];
    alert.tag = tag;
    [alert show];
}


@end
