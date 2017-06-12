//
//  WatchRTMPViewController.h
//  VHallSDKDemo
//
//  Created by developer_k on 16/4/13.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import "VHBaseViewController.h"

@interface WatchLiveViewController : VHBaseViewController
@property(nonatomic,copy)NSString * roomId;
@property(nonatomic,copy)NSString * kValue;
@property(nonatomic,assign)NSInteger bufferTimes;
@end
