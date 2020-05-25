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
*  美颜参数设置
*  VHPublishConfig beautifyFilterEnable为YES时设置生效 根据具体使用情况微调
*  @param beautify   磨皮   默认 2.0f  取值范围[1.0, 10.0]  10.0 正常图片没有磨皮
*  @param brightness 亮度   默认 1.20f 取值范围[0.0, 2.0]  1.0 正常亮度
*  @param saturation 饱和度 默认 1.0f  取值范围[0.0, 2.0]  1.0 正常饱和度
*  @param sharpness  锐化   默认 0.1f  取值范围[-4.0，4.0] 0.0 无锐化  作废
*/
- (BOOL)setBeautifyFilterWithBilateral:(CGFloat)beautify Brightness:(CGFloat)brightness Saturation:(CGFloat)saturation Sharpness:(CGFloat)sharpness;
//锐化参数默认0.0f
- (BOOL)setBeautifyFilterWithBilateral:(CGFloat)beautify Brightness:(CGFloat)brightness Saturation:(CGFloat)saturation;
@end
