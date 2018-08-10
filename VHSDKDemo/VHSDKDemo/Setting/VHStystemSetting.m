//
//  VHStystemSetting.m
//  
//
//  Created by vhall on 16/5/11.
//  Copyright (c) 2016年 www.vhall.com. All rights reserved.
//

#import "VHStystemSetting.h"
#import <objc/message.h>

@implementation VHStystemSetting

static VHStystemSetting *pub_sharedSetting = nil;

+ (VHStystemSetting *)sharedSetting
{
    @synchronized(self)
    {
        if (pub_sharedSetting == nil)
        {
            pub_sharedSetting = [[VHStystemSetting alloc] init];
        }
    }
    
    return pub_sharedSetting;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (pub_sharedSetting == nil) {
            
            pub_sharedSetting = [super allocWithZone:zone];
            return pub_sharedSetting;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        //活动设置
        _activityID = [standardUserDefaults objectForKey:@"VHactivityID"];   //活动ID     必填
        _watchActivityID= [standardUserDefaults objectForKey:@"VHwatchActivityID"];   //观看活动ID
        _nickName   = [standardUserDefaults objectForKey:@"VHnickName"];     //参会昵称    为空默认随机字符串做昵称
        _email     = [standardUserDefaults objectForKey:@"VHuserID"];        //标示该游客用户唯一id 可填写用户邮箱  为空默认使用设备UUID做为唯一ID
        _kValue     = [standardUserDefaults objectForKey:@"VHkValue"];       //K值        可以为空

        //直播设置
        _videoResolution= [standardUserDefaults objectForKey:@"VHvideoResolution"];//发起直播分辨率
        _liveToken      = [standardUserDefaults objectForKey:@"VHliveToken"];            //直播令牌
        _videoBitRate   = [standardUserDefaults integerForKey:@"VHbitRate"];              //发直播视频码率
        _audioBitRate   = [standardUserDefaults integerForKey:@"VHaudiobitRate"];              //发直播音频码率
        _videoCaptureFPS= [standardUserDefaults integerForKey:@"VHvideoCaptureFPS"];//发直播视频帧率 ［1～30］ 默认10
        
        //观看设置
        _bufferTimes    = [standardUserDefaults integerForKey:@"VHbufferTimes"];          //RTMP观看缓冲时间
        _timeOut        = [standardUserDefaults integerForKey:@"VHtimeOut"];          //观看超时时间
        if(_timeOut<=0)
            _timeOut = 10;
        
        _account        = [standardUserDefaults objectForKey:@"VHaccount"];      //账号
        _password       = [standardUserDefaults objectForKey:@"VHpassword"];     //密码
        
        _appKey         = [standardUserDefaults objectForKey:@"VHappKey"];
        _appSecretKey   = [standardUserDefaults objectForKey:@"VHappSecretKey"];

        if(_activityID == nil)
        {
            _activityID = DEMO_ActivityId;
        }
        if(_watchActivityID == nil)
        {
            _watchActivityID = DEMO_ActivityId;
        }
        if(_liveToken  == nil)
        {
            _liveToken = DEMO_AccessToken;
        }
        
        if(_account == nil)
        {
            _account = DEMO_account;
        }
        if(_password  == nil)
        {
            _password = DEMO_password;
        }
        
        
        if(_nickName == nil || _nickName.length == 0)
        {
            _nickName = [UIDevice currentDevice].name;
        }
        if(_email == nil || _email.length == 0)
        {
            _email = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            if(_email == nil || _email.length == 0)
            {
                _email = @"unknown";
            }
        }
        if(_videoResolution == nil || _videoResolution.length == 0)
        {
            _videoResolution = @"2";
        }

        if(_videoBitRate<=0)
        {
            _videoBitRate = 600;
        }
        if(_audioBitRate<=0)
        {
            _audioBitRate = 16;
        }
        if(_videoCaptureFPS <1)
            _videoCaptureFPS = 10;
        if(_videoCaptureFPS >30)
            _videoCaptureFPS = 30;
        if(_bufferTimes <=0)
            _bufferTimes = 6;
        
        if([standardUserDefaults valueForKey:@"VHisOpenNoiseSuppresion"])
            self.isOpenNoiseSuppresion = [standardUserDefaults boolForKey:@"VHisOpenNoiseSuppresion"];
        else
            self.isOpenNoiseSuppresion = YES;
        
        if(_appKey.length>0 && _appSecretKey.length>0)
        {
            [VHallApi registerApp:_appKey SecretKey:_appSecretKey];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHappKey"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHappSecretKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _appKey = nil;
            _appSecretKey = nil;
            [VHallApi registerApp:DEMO_AppKey SecretKey:DEMO_AppSecretKey];
         
            
            NSString *pushRe = [standardUserDefaults objectForKey:@"VHInteractivePushResolution"];
            _pushResolution = (pushRe)?pushRe:@"3";
        }
    }
    return self;
}

- (void)setActivityID:(NSString*)activityID
{
    _activityID = activityID;
    if(activityID == nil || activityID.length == 0)
    {
        _activityID = DEMO_ActivityId;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHactivityID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_activityID forKey:@"VHactivityID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTimeOut:(NSInteger)timeOut
{
    if(timeOut<=0)
        timeOut = 10;
    
    _timeOut = timeOut;
    [[NSUserDefaults standardUserDefaults] setInteger:timeOut forKey:@"VHtimeOut"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setWatchActivityID:(NSString*)watchActivityID
{
    _watchActivityID = watchActivityID;
    if(watchActivityID == nil || watchActivityID.length == 0)
    {
        _watchActivityID = DEMO_ActivityId;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHwatchActivityID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_watchActivityID forKey:@"VHwatchActivityID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setNickName:(NSString*)nickName
{
    if(nickName == nil || nickName.length == 0)
        return;
    
    _nickName = nickName;
    [[NSUserDefaults standardUserDefaults] setObject:_nickName forKey:@"VHnickName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setEmail:(NSString*)email
{
    if(email == nil || email.length == 0)
        return;
    
    _email = email;
    [[NSUserDefaults standardUserDefaults] setObject:_email forKey:@"VHuserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setKValue:(NSString*)kValue
{
    _kValue = kValue;
    [[NSUserDefaults standardUserDefaults] setObject:_kValue forKey:@"VHkValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setAccount:(NSString *)account
{
    _account  = account ;
    [[NSUserDefaults standardUserDefaults] setObject:_account forKey:@"VHaccount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setPassword:(NSString *)password
{
    _password  = password ;
    [[NSUserDefaults standardUserDefaults] setObject:_password forKey:@"VHpassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setVideoResolution:(NSString*)videoResolution
{
    if(videoResolution == nil || videoResolution.length == 0)
        return;
    if([videoResolution integerValue]<0 || [videoResolution integerValue]>3)
        return;
    
    _videoResolution = videoResolution;
    [[NSUserDefaults standardUserDefaults] setObject:_videoResolution forKey:@"VHvideoResolution"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIsOpenNoiseSuppresion:(BOOL)isOpenNoiseSuppresion
{
    _isOpenNoiseSuppresion = isOpenNoiseSuppresion;
    [[NSUserDefaults standardUserDefaults] setBool:_isOpenNoiseSuppresion forKey:@"VHisOpenNoiseSuppresion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLiveToken:(NSString*)liveToken
{
    _liveToken = liveToken;
    if(liveToken == nil || liveToken.length == 0)
    {
        _liveToken = DEMO_AccessToken;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VHliveToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_liveToken forKey:@"VHliveToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setVideoBitRate:(NSInteger)videoBitRate
{
    if(videoBitRate<=0)
        return;
    
    _videoBitRate = videoBitRate;
    [[NSUserDefaults standardUserDefaults] setInteger:videoBitRate forKey:@"VHbitRate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAudioBitRate:(NSInteger)audioBitRate
{
    if(audioBitRate<=0)
        return;
    
    _audioBitRate = audioBitRate;
    [[NSUserDefaults standardUserDefaults] setInteger:audioBitRate forKey:@"VHaudiobitRate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setVideoCaptureFPS:(NSInteger)videoCaptureFPS
{
    if(videoCaptureFPS <1)
        videoCaptureFPS = 10;
    if(videoCaptureFPS >30)
        videoCaptureFPS = 30;

    _videoCaptureFPS = videoCaptureFPS;
    [[NSUserDefaults standardUserDefaults] setInteger:videoCaptureFPS forKey:@"VHvideoCaptureFPS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setBufferTimes:(NSInteger)bufferTimes
{
    if(bufferTimes <=0)
        bufferTimes = 2;
    
    _bufferTimes = bufferTimes;
    [[NSUserDefaults standardUserDefaults] setInteger:bufferTimes forKey:@"VHbufferTimes"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAppKey:(NSString *)appKey
{
    _appKey = appKey;
    [[NSUserDefaults standardUserDefaults] setObject:_appKey forKey:@"VHappKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(_appKey.length>0 && _appSecretKey.length>0)
    {
        [VHallApi registerApp:_appKey SecretKey:_appSecretKey];
    }
    else
    {
        [VHallApi registerApp:DEMO_AppKey SecretKey:DEMO_AppSecretKey];
    }
}

- (void)setAppSecretKey:(NSString *)appSecretKey
{
    _appSecretKey = appSecretKey;
    [[NSUserDefaults standardUserDefaults] setObject:_appSecretKey forKey:@"VHappSecretKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(_appKey.length>0 && _appSecretKey.length>0)
    {
        [VHallApi registerApp:_appKey SecretKey:_appSecretKey];
    }
    else
    {
        [VHallApi registerApp:DEMO_AppKey SecretKey:DEMO_AppSecretKey];
    }
}


- (void)setPushResolution:(NSString *)pushResolution {
    _pushResolution = pushResolution;
    
    [[NSUserDefaults standardUserDefaults] setObject:_pushResolution forKey:@"VHInteractivePushResolution"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
