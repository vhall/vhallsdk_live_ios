//
//  DemoViewController.h
//  PublishDemo
//
//  Created by liwenlong on 15/10/9.
//  Copyright (c) 2015年 vhall. All rights reserved.
//

#import "VHBaseViewController.h"
#import "VHallApi.h"

@interface LaunchLiveViewController : VHBaseViewController
{
    
}
@property(nonatomic,assign)VideoResolution videoResolution;
@property(nonatomic,copy)NSString * roomId;
@property(nonatomic,copy)NSString * token;
@property(nonatomic,assign)NSInteger videoBitRate;
@property(nonatomic,assign)NSInteger audioBitRate;
@property(nonatomic,assign) NSInteger videoCaptureFPS;
@end
