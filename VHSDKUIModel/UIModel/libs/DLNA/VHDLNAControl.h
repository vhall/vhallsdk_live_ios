//
//  VHDLNAControl.h
//  VHDLNA
//
//  Created by yangyang on 2017/9/7.
//  Copyright © 2017年 111. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHDLNAControlDelegate.h"
@interface VHDLNAControl : NSObject
@property(nonatomic,weak) id<VHDLNAControlDelegate> delegate;
-(void)playWithDeviceIndex:(int)index;
@end
