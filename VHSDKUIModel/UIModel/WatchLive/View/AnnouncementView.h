//
//  AnnouncementView.h
//  VHallSDKDemo
//
//  Created by vhall on 17/2/14.
//  Copyright © 2017年 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncementView : UIView
@property (nonatomic,strong)NSString* content;

- (id)initWithFrame:(CGRect)frame content:(NSString*)content time:(NSString*)time;
- (void)hideView;
@end
