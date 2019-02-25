//
//  VHInvitationAlert.h
//  LightEnjoy
//
//  Created by vhall on 2018/7/13.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VHInvitationAlert;

@protocol VHInvitationAlertDelegate <NSObject>

- (void)alert:(VHInvitationAlert *)alert clickAtIndex:(NSInteger)index;

@end



@interface VHInvitationAlert : UIView

@property (nonatomic, weak) id <VHInvitationAlertDelegate> delegate;

@property (nonatomic, strong) UIButton *hearderBtn;
@property (nonatomic, strong) UIButton *closeButton;

- (instancetype)initWithDelegate:(id)delegate
                             tag:(NSInteger)tag
                           title:(NSString *)title
                         content:(NSString *)content;

@end
