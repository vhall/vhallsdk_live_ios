//
//  VHRoom.h
//  VHInteractive
//
//  Created by vhall on 2018/4/18.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VHLocalRenderView.h"
/*
 * 互动房间状态
 */
typedef NS_ENUM(NSInteger, VHRoomStatus) {
    VHRoomStatusReady,
    VHRoomStatusConnected,
    VHRoomStatusDisconnected,
    VHRoomStatusError
};
/*
 * 房间错误状态
 */
typedef NS_ENUM(NSInteger, VHRoomErrorStatus) {
    VHRoomErrorUnknown,
    VHRoomErrorClient,// A generic error that comes from an VHClient
    VHRoomErrorClientFailedSDP,
    VHRoomErrorSignaling// A generic error that comes from VHSignalingChannel
};
/*
 * 互动房间设备（1麦克风，2摄像头）
 */
typedef NS_ENUM(NSInteger, VHRoomDevice) {
    VHRoomDeviceMic = 1,
    VHRoomDeviceCamera
};


@protocol   VHRoomDelegate;
@class      VHRenderView;


@interface VHRoom : NSObject

@property (nonatomic, weak) id <VHRoomDelegate> delegate;

/*
 * 当前房间状态
 */
@property (nonatomic, assign, readonly) VHRoomStatus    status;

/*
 * 当前推流 cameraView 只在推流过程中存在
 */
@property (nonatomic, weak, readonly) VHRenderView    *cameraView;

/*
 * 所有其他进入本房间的视频view
 */
@property (nonatomic, strong, readonly) NSDictionary    *renderViewsById;

/*
 * 房间中所有可以观看的流id列表
 */
@property (nonatomic, strong, readonly) NSArray         *streams;

/*
 * 房间id
 */
@property (nonatomic, copy,   readonly) NSString        *roomId;

/*
 * 支持的推流视频分辨率
 */
+ (NSArray<NSString *> *)availableVideoResolutions;

/*
 * 加入房间
 * @param roomId 加入房间id
 */
- (void)enterRoomWithRoomId:(NSString *)roomId;

/*
 * 上麦推流
 * @param camera 本地摄像头view
 */
- (BOOL)publishWithCameraView:(VHLocalRenderView * ) cameraView;

/*
 * 停止推流
 */
- (void)unpublish;

/*
 * 离开房间
 */
- (void)leaveRoom;

@end


/*
 * 互动房间代理
 */
@protocol VHRoomDelegate <NSObject>
/*
 * 进入房间回调
 */
- (void)room:(VHRoom *)room enterRoomWithError:(NSError *)error;
/*
 * 房间连接成功
 */
- (void)room:(VHRoom *)room didConnect:(NSDictionary *)roomMetadata;
/*
 * 房间错误回调
 */
- (void)room:(VHRoom *)room didError:(VHRoomErrorStatus)status reason:(NSString *)reason;
/*
 * 房间状态变化
 */
- (void)room:(VHRoom *)room didChangeStatus:(VHRoomStatus)status;
/*
 * 推流成功
 */
- (void)room:(VHRoom *)room didPublish:(VHRenderView *)cameraView;
/*
 * 停止推流成功
 */
- (void)room:(VHRoom *)room didUnpublish:(VHRenderView *)cameraView;
/*
 * 有新的成员加入房间
 */
- (void)room:(VHRoom *)room didAddAttendView:(VHRenderView *)attendView;
/*
 * 有成员离开房间
 */
- (void)room:(VHRoom *)room didRemovedAttendView:(VHRenderView *)attendView;
/*
 * 互动房间互动消息回调
 * eventName    互动消息name，可为空
 * attributes   互动消息体
 */
- (void)room:(VHRoom *)room interactiveMsgWithEventName:(NSString *)eventName attribute:(id)attributes;

/*
 被主播下麦 v4.0.0
 */
- (void)leaveInteractiveRoomByHost:(VHRoom *)room;

/*
 主播操作自己的麦克风 v4.0.0
 */
- (void)room:(VHRoom *)room microphoneClosed:(BOOL)isClose;

/*
 主播操作自己的摄像头 v4.0.0
 */
- (void)room:(VHRoom *)room screenClosed:(BOOL)isClose;

/*
 * iskickout 被踢出房间
 */
- (void)room:(VHRoom *)room iskickout:(BOOL)iskickout;

/**
 * 收到被禁言/取消禁言
 */
- (void)room:(VHRoom *)room forbidChat:(BOOL)forbidChat;

/**
 * 收到全体禁言/取消全体禁言
 */
- (void)room:(VHRoom *)room allForbidChat:(BOOL)allForbidChat;

@end
