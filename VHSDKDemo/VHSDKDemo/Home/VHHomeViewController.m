//
//  HomeViewController.m
//  VHallSDKDemo
//
//  Created by yangyang on 2017/2/13.
//  Copyright © 2017年 vhall. All rights reserved.
//

#import "VHHomeViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import <VHLiveSDK/VHallApi.h>

#import "LaunchLiveViewController.h"
#import "WatchLiveViewController.h"
#import "WatchPlayBackViewController.h"

#import "VHStystemSetting.h"
#import "VHSettingViewController.h"


@interface VHHomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel        *deviceCategory;
@property (weak, nonatomic) IBOutlet UIButton       *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView    *headImage;//头像
@property (weak, nonatomic) IBOutlet UILabel        *nickName;//昵称

@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@end

@implementation VHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateUI];
    
    NSArray *arr =@[_btn0,_btn1,_btn2,_btn3];
    for (UIButton*btn in arr) {
        CGSize image = btn.imageView.frame.size;
        CGSize title = btn.titleLabel.frame.size;
        
        btn.titleEdgeInsets =UIEdgeInsetsMake(50, -0.5*image.width, 0, 0.5*image.width);
        btn.imageEdgeInsets =UIEdgeInsetsMake(-38, 0.5*title.width, 0, -0.5*title.width);
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateUI
{
    _nickName.text      = [VHallApi isLoggedIn]?[VHallApi currentUserNickName]:@"游客";
    _loginBtn.selected  = [VHallApi isLoggedIn];
    _deviceCategory.text= [UIDevice currentDevice].name;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:[VHallApi currentUserHeadUrl]] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
}

#pragma mark - 发直播
- (void)startLive:(UIInterfaceOrientation)orientation
{
    if (DEMO_Setting.activityID.length<=0) {
        [UIAlertView popupAlertByDelegate:nil title:@"请在设置中输入发直播活动ID" message:nil];
        return;
    }
    if (DEMO_Setting.liveToken == nil||DEMO_Setting.liveToken<=0) {
        [UIAlertView popupAlertByDelegate:nil title:@"请在设置中输入token" message:nil];
        return;
    }
    if (DEMO_Setting.videoBitRate<=0 || DEMO_Setting.audioBitRate<=0) {
        [UIAlertView popupAlertByDelegate:nil title:@"码率不能为负数" message:nil];
        return;
    }
    if (DEMO_Setting.videoCaptureFPS< 1 || DEMO_Setting.videoCaptureFPS>30) {
        [UIAlertView popupAlertByDelegate:nil title:@"帧率设置错误[1-30]" message:nil];
        return;
    }
    
    LaunchLiveViewController * rtmpLivedemoVC = [[LaunchLiveViewController alloc] init];
    rtmpLivedemoVC.videoResolution  = [DEMO_Setting.videoResolution intValue];
    rtmpLivedemoVC.roomId           = DEMO_Setting.activityID;
    rtmpLivedemoVC.token            = DEMO_Setting.liveToken;
    rtmpLivedemoVC.videoBitRate     = DEMO_Setting.videoBitRate;
    rtmpLivedemoVC.audioBitRate     = DEMO_Setting.audioBitRate;
    rtmpLivedemoVC.videoCaptureFPS  = DEMO_Setting.videoCaptureFPS;
    rtmpLivedemoVC.interfaceOrientation = orientation;
    rtmpLivedemoVC.isOpenNoiseSuppresion = DEMO_Setting.isOpenNoiseSuppresion;
    [self presentViewController:rtmpLivedemoVC animated:YES completion:nil];
}

#pragma mark -
- (IBAction)btnClick:(UIButton*)sender
{
    _btn0.selected = _btn1.selected = _btn2.selected = _btn3.selected =NO;
    sender.selected = YES;
   
    switch (sender.tag) {
        case 0://横屏发直播
        {
            [self startLive:UIInterfaceOrientationLandscapeRight];//设备左转，摄像头在左边
        }
            break;
        case 1://竖屏发直播
        {
            [self startLive:UIInterfaceOrientationPortrait];
        }
            break;
        case 2://观看直播
        {
            if (DEMO_Setting.watchActivityID.length<=0) {
                [UIAlertView popupAlertByDelegate:nil title:@"请在设置中输入活动ID" message:nil];
                return;
            }
            WatchLiveViewController * watchVC  =[[WatchLiveViewController alloc]init];
            watchVC.roomId      = DEMO_Setting.watchActivityID;
            watchVC.kValue      = DEMO_Setting.kValue;
            watchVC.bufferTimes = DEMO_Setting.bufferTimes;
            [self presentViewController:watchVC animated:YES completion:nil];
        }
            break;
        case 3://观看回放
        {
            if (DEMO_Setting.watchActivityID.length<=0) {
                [UIAlertView popupAlertByDelegate:nil title:@"请在设置中输入活动ID" message:nil];
                return;
            }
            WatchPlayBackViewController * watchVC  =[[WatchPlayBackViewController alloc]init];
            watchVC.roomId = DEMO_Setting.watchActivityID;
            watchVC.kValue = DEMO_Setting.kValue;
            watchVC.timeOut = DEMO_Setting.timeOut*1000;
            [self presentViewController:watchVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (IBAction)systemSettingClick:(id)sender
{
    VHSettingViewController *settingVc=[[VHSettingViewController alloc] init];
    [self presentViewController:settingVc animated:YES completion:nil];
}
- (IBAction)loginOrloginOutClick:(id)sender
{
    if ([VHallApi isLoggedIn])
    {
        __weak typeof(self) weekself= self;
        [VHallApi logout:^{
            [weekself showMsg:@"已退出" afterDelay:1.5];
            [weekself updateUI];
            _loginBtn.selected = NO;
        } failure:^(NSError *error) {
            [weekself updateUI];
        }];
    }else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }
}

#pragma mark -
-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
