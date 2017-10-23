//
//  VHDLNAControlDelegate.h
//  VHDLNA
//
//  Created by yangyang on 2017/9/8.
//  Copyright © 2017年 111. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VHDLNAControlDelegate <NSObject>
-(void)deviceList:(NSArray*)deviceList;
@end
