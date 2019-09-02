//
//  VHinteractiveViewController.m
//  UIModel
//
//  Created by vhall on 2018/7/30.
//  Copyright © 2018年 www.vhall.com. All rights reserved.
//

#import "VHinteractiveViewController.h"
#import <VHInteractive/VHRoom.h>
#import <VHLiveSDK/VHallApi.h>

#define iconSize 34

@interface VHinteractiveViewController ()<VHRoomDelegate,UIAlertViewDelegate>
{
    UIButton *_micBtn;//麦克风按钮
    UIButton *_cameraBtn;//摄像头按钮
}
@property (nonatomic, strong) VHRoom *interactiveRoom;//互动房间
@property (nonatomic, strong) VHLocalRenderView *cameraView;//本地摄像头

@property (nonatomic, strong) NSMutableArray *views;

@end

@implementation VHinteractiveViewController

- (instancetype)init {
    if (self = [super init]) {
        
        _views = [NSMutableArray array];
    }
    return self;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initSubViews];
    
    if (!self.roomId) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"互动房间id不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        //进入互动房间
        [self.interactiveRoom enterRoomWithRoomId:self.roomId];
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    //程序进入前后台监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)appBecomeActive {
    //推流
    [_interactiveRoom publishWithCameraView:_cameraView];
}
- (void)appEnterBackground {
    //停止推流
    [_interactiveRoom unpublish];
}

- (void)dealloc {
    NSLog(@"%@ dealloc",self.description);
    
    _interactiveRoom = nil;
    _cameraView = nil;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initSubViews
{
    [self setUpCameraView];
    
    [self setUpTopButtons];
}
- (void)setUpTopButtons {
    //切换摄像头按钮
    UIButton *swapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    swapBtn.bounds = CGRectMake(0, 0, iconSize, iconSize);
    swapBtn.top = self.view.height*0.5-((iconSize+6)*4)*0.5;
    swapBtn.right = self.view.right-12;
    [swapBtn setBackgroundImage:[UIImage imageNamed:@"UIModel.bundle/icon_video_camera_switching.tiff"] forState:UIControlStateNormal];
    [swapBtn setBackgroundImage:[UIImage imageNamed:@"UIModel.bundle/icon_video_camera_switching.tiff"] forState:UIControlStateSelected];
    [swapBtn addTarget:self action:@selector(swapStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:swapBtn];

    //开关摄像头按钮
    _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cameraBtn.frame = CGRectMake(swapBtn.left, swapBtn.bottom+12, iconSize, iconSize);
    [_cameraBtn setBackgroundImage:[UIImage imageNamed:@"UIModel.bundle/icon_video_open_camera.tiff"] forState:UIControlStateNormal];
    [_cameraBtn setBackgroundImage:[UIImage imageNamed:@"UIModel.bundle/icon_video_close_camera.tiff"] forState:UIControlStateSelected];
    [_cameraBtn addTarget:self action:@selector(videoStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cameraBtn];

    //麦克风按钮
    _micBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _micBtn.frame = CGRectMake(_cameraBtn.left, _cameraBtn.bottom+12, iconSize, iconSize);
    [_micBtn setBackgroundImage:[UIImage imageNamed:@"UIModel.bundle/icon_video_open_microphone.tiff"] forState:UIControlStateNormal];
    [_micBtn setBackgroundImage:[UIImage imageNamed:@"UIModel.bundle/icon_video_close_microphone.tiff"] forState:UIControlStateSelected];
    [_micBtn addTarget:self action:@selector(micBtnStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_micBtn];

    //下麦按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(_micBtn.left, _micBtn.bottom+12, iconSize, iconSize);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"UIModel.bundle/icon_video_lowerwheat.tiff"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}
- (void)setUpCameraView {
    //创建本地摄像头视图
    _cameraView = nil;
    [_cameraView removeFromSuperview];
    self.cameraView.frame = self.view.bounds;
    [self.view insertSubview:self.cameraView atIndex:0];
}


#pragma mark - VHRoomDelegate
//进入互动房间回调
- (void)room:(VHRoom *)room enterRoomWithError:(NSError *)error {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"互动房间进入失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 1001;
        [alert show];
    }
}
// 房间连接成功
- (void)room:(VHRoom *)room didConnect:(NSDictionary *)roomMetadata
{
    //上麦推流
    [room publishWithCameraView:self.cameraView];
    VHLog(@"房间连接成功，开始推流");
}
// 房间错误回调
- (void)room:(VHRoom *)room didError:(VHRoomErrorStatus)status reason:(NSString *)reason
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"互动房间连接出错：%@",reason] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 1000;
    [alert show];
    
    VHLog(@"房间连接错误%@",reason);
}
// 房间状态变化
- (void)room:(VHRoom *)room didChangeStatus:(VHRoomStatus)status
{
    
}
//推流成功
- (void)room:(VHRoom *)room didPublish:(VHRenderView *)cameraView
{
    VHLog(@"推流成功");
}
//停止推流成功
- (void)room:(VHRoom *)room didUnpublish:(VHRenderView *)cameraView
{
    VHLog(@"停止推流");
}

// 有新的成员加入房间
- (void)room:(VHRoom *)room didAddAttendView:(VHRenderView *)attendView
{
    attendView.scalingMode = VHRenderViewScalingModeAspectFill;
    [self addView:attendView];
}
//有成员离开房间
- (void)room:(VHRoom *)room didRemovedAttendView:(VHRenderView *)attendView
{
    [self showMsg:[NSString stringWithFormat:@"%@ 已下麦",attendView.userId] afterDelay:0];
    
    [self removeView:attendView];
}

/*
 被讲师下麦 v4.0.0
 */
- (void)leaveInteractiveRoomByHost:(VHRoom *)room
{
    [self showMsg:@"您已被主播下麦" afterDelay:3];
    //离开互动房间
    [self closeButtonClick:nil];
}

/*
 主播操作自己的麦克风 v4.0.0
 */
- (void)room:(VHRoom *)room microphoneClosed:(BOOL)isClose
{
    _micBtn.selected = isClose;
}

/*
 主播操作自己的摄像头 v4.0.0
 */
- (void)room:(VHRoom *)room screenClosed:(BOOL)isClose
{
    _cameraBtn.selected = isClose;
}


//互动房间互动消息处理
- (void)room:(VHRoom *)room interactiveMsgWithEventName:(NSString *)eventName attribute:(id)attributes
{
    //麦克风/摄像头操作
    if ([attributes[@"type"] isEqualToString:@"*switchDevice"]) {
        /*
         device = 1;            // 1 麦克风 2 摄像头
         "join_uid" = 1167475;  //被操作用户参会id
         status = 0;            //0 关闭 1 打开
         type = "*switchDevice";
         */
        if ([attributes[@"device"] intValue] == 1)
        {
            if ([attributes[@"status"] intValue] == 0)
            {
                [self.cameraView muteAudio];
                _micBtn.selected = YES;
            }
            else
            {
                [self.cameraView unmuteAudio];
                _micBtn.selected = NO;
            }
        }
        else if ([attributes[@"device"] intValue] == 2)
        {
            if ([attributes[@"status"] intValue] == 0)
            {
                [self.cameraView muteVideo];
                _cameraBtn.selected = YES;
            }
            else
            {
                [self.cameraView unmuteVideo];
                _cameraBtn.selected = NO;
            }
        }
    }
    //下麦
    else if ([attributes[@"type"] isEqualToString:@"*notSpeak"]) {
        /*
         "join_uid" = 1167475;  //操作人参会id
         "nick_name" = 900530;  //被操作者昵称
         "role_name" = user;    //
         type = "*notSpeak";    //
         */
        
        //离开互动房间
        [self closeButtonClick:nil];
    }
    //...其他消息
    //Code...
}

/*
 * iskickout 被踢出房间
 */
- (void)room:(VHRoom *)room iskickout:(BOOL)iskickout
{
    [self kickOut];
}
/**
 * 收到被禁言/取消禁言
 */
- (void)room:(VHRoom *)room forbidChat:(BOOL)forbidChat
{
    
}
/**
 * 收到全体禁言/取消全体禁言
 */
- (void)room:(VHRoom *)room allForbidChat:(BOOL)allForbidChat
{
//    收到全体禁言/取消全体禁言
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000 || alertView.tag == 1001) {
        
        [self closeButtonClick:nil];
    }
}

#pragma mark - button click
//退出
- (void)closeButtonClick:(UIButton *)sender {
    //移除互动视频
    [self removeAllViews];

    [_cameraView stopStats];
    
    //离开互动房间
    [_interactiveRoom leaveRoom];
    _interactiveRoom = nil;
    //返回上级页面
    [self dismissViewControllerAnimated:YES completion:^{}];
//    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
//摄像头切换
- (void)swapStatusChanged:(UIButton *)sender {
    [_cameraView switchCamera];
}

//麦克风按钮事件
- (void)micBtnStatusChanged:(UIButton *)sender {
    //麦克风按钮图标变更
    sender.selected = !sender.selected;
    //麦克风操作
    (sender.selected) ? [_cameraView muteAudio] : [_cameraView unmuteAudio];
}
//摄像头按钮事件
- (void)videoStatusChanged:(UIButton *)sender {
    //麦克风按钮图标变更
    sender.selected = !sender.selected;
    //摄像头操作
    (sender.selected) ? [_cameraView muteVideo] : [_cameraView unmuteVideo];
}



#pragma mark - 互动观众
- (void)addView:(UIView*)view
{
    NSUInteger idx = [self.views indexOfObject:view];
    if(idx != NSNotFound) return;
    
    [self.views addObject:view];
    [self updateUI];
}
- (void)removeView:(UIView *)view
{
    [view removeFromSuperview];
    [self.views removeObject:view];
    [self updateUI];
}
- (void)removeAllViews
{
    for (UIView *v in self.views) {
        [v removeFromSuperview];
    }
    [self.views removeAllObjects];
}
- (void)updateUI
{
    int i = 0;
    for (UIView *view in self.views) {
        view.frame = CGRectMake(8, 28+i*(80+1), 140, 80);
        [self.view addSubview:view];
        i++;
    }
}

- (VHRoom *)interactiveRoom {
    if (!_interactiveRoom) {
        _interactiveRoom = [[VHRoom alloc] init];
        _interactiveRoom.delegate = self;
    }
    return _interactiveRoom;
}
- (VHLocalRenderView *)cameraView {
    if (!_cameraView) {
        
        //设置中设置的推流分辨率
        NSString *re = [[NSUserDefaults standardUserDefaults] objectForKey:@"VHInteractivePushResolution"];
        
        _cameraView = [[VHLocalRenderView alloc] initCameraViewWithFrame:CGRectZero pushType:[re intValue] options:nil];
        _cameraView.scalingMode = VHRenderViewScalingModeAspectFill;
        //设置摄像头旋转方向，注意：如需要转屏请自行监听屏转，设置摄像头orientation。
        [_cameraView setDeviceOrientation:[UIDevice currentDevice].orientation];
    }
    return _cameraView;
}

- (void)kickOut {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您已被踢出房间" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self kickOutAction];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:NO completion:nil];
}

- (void)kickOutAction {
    //移除互动视频
    [self removeAllViews];
    
    [_cameraView stopStats];
    
    //离开互动房间
    [_interactiveRoom leaveRoom];
    _interactiveRoom = nil;
    
    UIViewController *vc = self;
    Class homeVcClass = NSClassFromString(@"VHHomeViewController");
    while (![vc isKindOfClass:homeVcClass]) {
        vc = vc.presentingViewController;
        NSLog(@"===== %@",vc.class);
    }
    [vc dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//#pragma mark 权限
//- (BOOL)audioAuthorization
//{
//    BOOL authorization = NO;
//
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
//    switch (authStatus) {
//        case AVAuthorizationStatusNotDetermined:
//            //没有询问是否开启麦克风
//            break;
//        case AVAuthorizationStatusRestricted:
//            //未授权，家长限制
//            break;
//        case AVAuthorizationStatusDenied:
//            //玩家未授权
//            break;
//        case AVAuthorizationStatusAuthorized:
//            //玩家授权
//            authorization = YES;
//            break;
//        default:
//            break;
//    }
//    return authorization;
//}
//
//- (BOOL)cameraAuthorization
//{
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    if (authStatus == AVAuthorizationStatusRestricted ||
//        authStatus == AVAuthorizationStatusDenied)
//    {
//        return NO;
//    }
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
