//
//  CONSTS.h
//  VhallRtmpDemo
//
//  Created by liwenlong on 15/10/10.
//  Copyright © 2015年 vhall. All rights reserved.
//

#ifndef CONSTS_h
#define CONSTS_h

//接口文档说明： http://e.vhall.com/home/vhallapi
#define DEMO_AppKey         @"替换成您自己的AppKey"        //AppKey   详见： ▪ API&SDK权限申请
#define DEMO_AppSecretKey   @"替换成您自己的AppSecretKey"  //AppSecretKey
#define DEMO_ActivityId     @"" //活动id    详见：▪ 自助式网络直播API -> 活动管理
#define DEMO_AccessToken    @"" //直播Token 详见：▪ 自助式网络直播API -> 观众管理 ->verify/access-token

#define DEMO_account        @"" //账号 详见：▪ 自助式网络直播API -> 活动管理 ->user/register 创建用户
#define DEMO_password       @"" //密码 详见：▪ 自助式网络直播API -> 活动管理 ->user/register 创建用户

//////////////////////////////////////////////////////////发布要删除



//#if DEBUG  // 调试状态, 打开LOG功能
#define VHLog(...) NSLog(__VA_ARGS__)
//#else // 发布状态, 关闭LOG功能
//#define VHLog(...)
//#endif

typedef NS_ENUM(int,WatchVideoType)
{
    kWatchVideoNone,
    kWatchVideoRTMP,
    kWatchVideoHLS,
    kWatchVideoPlayback
};

#define kViewFramePath  @"frame"

#pragma mark - iphone detection functions

#define APPDELEGATE [AppDelegate getAppDelegate]

#define IOSVersion  [[UIDevice currentDevice].systemVersion floatValue]

#define KIScreenHeight [[UIScreen mainScreen] bounds].size.height

#define KIScreenWidth [[UIScreen mainScreen] bounds].size.width

//颜色
#define MakeColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define MakeColorRGB(hex)  ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:1.0])
#define MakeColorRGBA(hex,a) ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:a])
#define MakeColorARGB(hex) ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:((hex>>24)&0xff)/255.0])

#endif /* CONSTS_h */
