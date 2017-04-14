//
//  VHallFilterSDK.h
//  VHallFilterSDK
//
//  Created by vhall on 16/10/18.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "VHallLivePublish.h"

@protocol VHallLivePublishFilterDelegate;

@interface VHallLivePublishFilter : VHallLivePublish

/**
 *  是否开启滤镜，默认YES ，
 *  GPUFilterDelegate == nil时 是否开启SDK内部美颜滤镜
 *  GPUFilterDelegate != nil时 是否开启您代理中的滤镜
 */
@property (nonatomic, assign) BOOL openFilter;

/**
 *  setBeautifyFilterWithBilateral:Brightness:Saturation: 设置VHall美颜滤镜参数 GPUFilterDelegate == nil时有效
 *  @param distanceNormalizationFactor  // A normalization factor for the distance between central color and sample color.
 *  @param brightness                   // The brightness adjustment is in the range [0.0, 2.0] with 1.0 being no-change.
 *  @param saturation                   // The saturation adjustment is in the range [0.0, 2.0] with 1.0 being no-change.
 *  return BOOL YES设置成功 NO 设置失败
 */
- (BOOL)setBeautifyFilterWithBilateral:(CGFloat)distanceNormalizationFactor Brightness:(CGFloat)brightness Saturation:(CGFloat)saturation;

/**
 *  GPUFilterDelegate 滤镜代理 在代理方法中添加您自己的滤镜
 *  注：1、默认为nil 只有使用自己滤镜情况设置此代理
 *     2、必须在发直播前设置
 *     3、若果此属性不为nil时 SDK自带美颜功能失效 使用代理中设置的滤镜发起直播
 */
@property (nonatomic, assign) id<VHallLivePublishFilterDelegate> GPUFilterDelegate;

@end

@class GPUImageVideoCamera;
@class GPUImageView;
@class GPUImageiOSBlurFilter;
@protocol VHallLivePublishFilterDelegate <NSObject>

@optional

/**
 *  使用自定义滤镜代理
 *  注：1、使用此功能时工程中需集成GPUImage，如有冲突不要加载VHallFilterSDK/libGPUImage.a
 *     2、使用方式 按GPUImage规范添加您的滤镜 如：
 *     #pragma mark - LivePublishFilterDelegate
 *     - (void)addGPUImageFilter:(GPUImageVideoCamera *)source Output:(GPUImageView *)output
 *     {
 *         GPUImageColorBlendFilter *filter = [[GPUImageColorBlendFilter alloc] init];
 *         [source addTarget:filter];
 *         [filter addTarget:output];
 *     }
 */
- (void)addGPUImageFilter:(GPUImageVideoCamera *)source Output:(GPUImageView *)output;

@end
