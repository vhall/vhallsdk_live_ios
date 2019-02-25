//
//  VHallFilterSDK.h
//  VHallFilterSDK
//
//  Created by vhall on 16/10/18.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHallLivePublish.h"
@interface VHallLivePublishFilter : VHallLivePublish

/**
 *  是否开启滤镜，默认YES
 */
@property (nonatomic, assign) BOOL openFilter;

/**
 *  setBeautifyFilterWithBilateral:Brightness:Saturation: 设置VHall美颜滤镜参数 curFilterType == VHFilterType_Beautify时有效
 *  @param distanceNormalizationFactor  // A normalization factor for the distance between central color and sample color.
 *  @param brightness                   // The brightness adjustment is in the range [0.0, 2.0] with 1.0 being no-change.
 *  @param saturation                   // The saturation adjustment is in the range [0.0, 2.0] with 1.0 being no-change.
 *  return BOOL YES设置成功 NO 设置失败
 *  默认Bilateral:10.0 Brightness:1.0 Saturation:1.0];
 */
- (BOOL)setBeautifyFilterWithBilateral:(CGFloat)distanceNormalizationFactor Brightness:(CGFloat)brightness Saturation:(CGFloat)saturation;
@end
