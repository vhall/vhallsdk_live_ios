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

//流类型
typedef NS_ENUM(int,VHFilterType)
{
    VHFilterType_None = 0,  //空滤镜
    VHFilterType_Beautify,  //美颜滤镜
    VHFilterType_Custom,    //自定义滤镜
};

//直播播放器视频填充模式，回放使用MPMoviePlayerController 自带填充模式设置
typedef NS_ENUM(int,VHFilterFillMode)
{
    VHFilterFillModeNone,       // No scaling
    VHFilterFillModeAspectRatio,  // Uniform scale until one dimension fits
    VHFilterFillModeAspectRatioAndFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
};

@protocol VHallLivePublishFilterDelegate;

@interface VHallLivePublishFilter : VHallLivePublish

/**
 *  美颜预览画面填充模式
 *  默认值 VHFilterFillModeAspectRatio
 */
@property (nonatomic, assign) VHFilterFillMode fillMode;

/**
 *  是否开启滤镜，默认YES
 */
@property (nonatomic, assign) BOOL openFilter;

/**
 *  当前使用滤镜类型，默认VHFilterType_Beautify ，
 */
@property (nonatomic, assign) VHFilterType curFilterType;

/**
 *  setBeautifyFilterWithBilateral:Brightness:Saturation: 设置VHall美颜滤镜参数 curFilterType == VHFilterType_Beautify时有效
 *  @param distanceNormalizationFactor  // A normalization factor for the distance between central color and sample color.
 *  @param brightness                   // The brightness adjustment is in the range [0.0, 2.0] with 1.0 being no-change.
 *  @param saturation                   // The saturation adjustment is in the range [0.0, 2.0] with 1.0 being no-change.
 *  return BOOL YES设置成功 NO 设置失败
 *  默认Bilateral:10.0 Brightness:1.0 Saturation:1.0];
 */
- (BOOL)setBeautifyFilterWithBilateral:(CGFloat)distanceNormalizationFactor Brightness:(CGFloat)brightness Saturation:(CGFloat)saturation;

/**
 *  重新加载滤镜
 *  GPUFilterDelegate != nil时 会触发代理addGPUImageFilter：回调
 */
- (void)reLoadFilter;

/**
 *  GPUFilterDelegate 滤镜代理 在代理方法中添加您自己的滤镜
 *  注：curFilterType = VHFilterType_Custom 有效
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
