//
//  DemoViewController.h
//  PublishDemo
//
//  Created by liwenlong on 15/10/9.
//  Copyright (c) 2015年 vhall. All rights reserved.
//

#import "VHBaseViewController.h"

@interface LaunchLiveViewController : VHBaseViewController
@property(nonatomic,copy)   NSString        *roomId;
@property(nonatomic,copy)   NSString        *token;
@property(nonatomic,assign) NSInteger       videoBitRate;
@property(nonatomic,assign) NSInteger       audioBitRate;
@property(nonatomic,assign) NSInteger       videoCaptureFPS;
@property(nonatomic,assign) BOOL            isOpenNoiseSuppresion;
@property(nonatomic,assign) long            videoResolution;//0 352*288; 1 640*480; 2 960*540; 3 1280*720
@end
