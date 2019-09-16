//
//  DemoViewController.m
//  PublishDemo
//
//  Created by liwenlong on 15/10/9.
//  Copyright (c) 2015年 vhall. All rights reserved.
//

#import "LaunchLiveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import "WatchLiveOnlineTableViewCell.h"
#import "WatchLiveChatTableViewCell.h"
#import <VHLiveSDK/VHallApi.h>

#import "VHLiveChatView.h"
#import "VHMessageToolView.h"

@interface LaunchLiveViewController ()<VHallLivePublishDelegate, VHallChatDelegate,VHMessageToolBarDelegate>
{
    BOOL  _isVideoStart;
    BOOL  _isAudioStart;
    BOOL  _torchType;
    BOOL  _onlyVideo;
    BOOL  _isFontVideo;
    MBProgressHUD * _hud;
    UIButton * _lastFilterSelectBtn;

    VHallChat         *_chat;       //聊天
    dispatch_source_t _timer;
    long              _liveTime;
}


@property (strong, nonatomic)VHallLivePublish *engine;
@property (weak, nonatomic) IBOutlet UIView *perView;
@property (weak, nonatomic) IBOutlet UIImageView *logView;
@property (weak, nonatomic) IBOutlet UILabel *bitRateLabel;
@property (weak, nonatomic) IBOutlet UIButton *videoStartAndStopBtn;
@property (weak, nonatomic) IBOutlet UIButton *audioStartAndStopBtn;
@property (weak, nonatomic) IBOutlet UIButton *torchBtn;
@property (weak, nonatomic) IBOutlet UIView *chatContainerView;
@property (weak, nonatomic) IBOutlet UITextField *msgTextField;
@property (weak, nonatomic) IBOutlet UIButton *chatMsgSend;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIButton *defaultFilterSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *hideKeyBtn;

@property (nonatomic, strong) VHLiveChatView *chatView;
@property (nonatomic, strong) NSMutableArray *chatDataArray;
@property (nonatomic,strong) VHMessageToolView * messageToolView;  //输入框
@property (weak, nonatomic) IBOutlet UIView *noiseView;
@property (weak, nonatomic) IBOutlet UILabel *noiseLabel;
@end

@implementation LaunchLiveViewController

#pragma mark - Lifecycle
- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:meetingResourcesBundle];
    if (self) {
        [self initDatas];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViews];
    //初始化CameraEngine
    [self initCameraEngine];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (_chat) {
        _chat = nil;
    }
    
    if (_engine) {
        _engine = nil;
    }
    
    //允许iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self.view removeObserver:self forKeyPath:kViewFramePath];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    VHLog(@"%@ dealloc",[[self class]description]);
}

-(void)LaunchLiveWillResignActive
{
    [_engine disconnect];
    [_engine stopVideoCapture];
}

-(void)LaunchLiveDidBecomeActive
{
    [_engine startVideoCapture];
    [_engine reconnect];
}

- (IBAction)closeBtnClick:(id)sender
{
    if (_engine.isPublishing)
    {
         [_engine stopLive];//停止活动
    }
    [_engine destoryObject];
    self.engine = nil;
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:NO];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        return UIInterfaceOrientationMaskPortrait;
    }else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }else
    {
        return UIInterfaceOrientationMaskLandscapeLeft;
    }
}
#pragma mark - Lifecycle(Private)

- (void)registerLiveNotification
{
    [self.view addObserver:self forKeyPath:kViewFramePath options:NSKeyValueObservingOptionNew context:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LaunchLiveWillResignActive)name:UIApplicationWillResignActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LaunchLiveDidBecomeActive)name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LaunchLiveWillResignActive)name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LaunchLiveDidBecomeActive)name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)initDatas
{
    _isVideoStart = NO;
    _isAudioStart = NO;
    _torchType = NO;
    _onlyVideo = NO;
    _isFontVideo = NO;
    _videoResolution = VHHVideoResolution;
    _chatDataArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)initViews
{
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self registerLiveNotification];
    _hud = [[MBProgressHUD alloc]initWithView:self.perView];
    [self.perView addSubview:_hud];
    [_hud hide:YES];
    [self.perView addSubview:_closeBtn];
    
    _chatMsgSend.layer.masksToBounds = YES;
    _chatMsgSend.layer.cornerRadius = 15;
    _chatMsgSend.layer.borderWidth  = 1;
    _chatMsgSend.layer.borderColor  = MakeColorRGBA(0xffffff, 0.5).CGColor;
    
    _msgTextField.layer.masksToBounds = YES;
    _msgTextField.layer.cornerRadius = 15;
    [_msgTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];

    // TODO:暂时不支持此功能，但保留。
    _audioStartAndStopBtn.hidden = YES;
    
#if VHallFilterSDK_ENABLE
    _filterBtn.hidden = NO;
#else
    _filterBtn.hidden = YES;
#endif
}

- (void)viewDidLayoutSubviews
{
    __weak __typeof(self) weakself = self;
    if(!_chatView)
    {
        _chatView = [[VHLiveChatView alloc] initWithFrame:CGRectMake(10, 0,_chatContainerView.width-10,_chatContainerView.height - 50) msgTotal:^NSInteger{
            return  weakself.chatDataArray.count;
        } msgSource:^VHActMsg *(NSInteger index) {
            return  weakself.chatDataArray[index];
        }action:nil];
    }
    else
        _chatView.frame = CGRectMake(10, 0,_chatContainerView.width-10,_chatContainerView.height - 50);
    [_chatContainerView addSubview:_chatView];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:kViewFramePath])
    {
        CGRect frame = [[change objectForKey:NSKeyValueChangeNewKey]CGRectValue];
        self.engine.displayView.frame = frame;
        if(self.interfaceOrientation == UIInterfaceOrientationPortrait)
        {
            if(_messageToolView==nil && frame.size.width <frame.size.height)
            {
                _messageToolView = [[VHMessageToolView alloc] initWithFrame:CGRectMake(0, frame.size.height - [VHMessageToolView defaultHeight], frame.size.width, [VHMessageToolView defaultHeight]) type:3];
                
                _messageToolView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
                _messageToolView.delegate = self;
                _messageToolView.hidden = YES;
                [self.view addSubview:_messageToolView];
            }
        }
        else if(frame.size.width >frame.size.height)
        {
            if(_messageToolView==nil)
            {
                _messageToolView = [[VHMessageToolView alloc] initWithFrame:CGRectMake(0, frame.size.height - [VHMessageToolView defaultHeight], frame.size.width, [VHMessageToolView defaultHeight]) type:3];
                
                _messageToolView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
                _messageToolView.delegate = self;
                _messageToolView.hidden = YES;
                [self.view addSubview:_messageToolView];
            }
        }
    }
}

#pragma mark - Camera
#pragma mark -
- (void)initCameraEngine
{
    AVCaptureVideoOrientation captureVideoOrientation;
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        captureVideoOrientation = AVCaptureVideoOrientationPortrait;
    }else {
        captureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;//设备左转，摄像头在左边
    }
    
    VHPublishConfig* config = [VHPublishConfig configWithType:VHPublishConfigTypeDefault];
    config.orientation = captureVideoOrientation;
    config.publishConnectTimes = 2;
    config.videoBitRate = self.videoBitRate;
    config.videoCaptureFPS = self.videoCaptureFPS;
    config.isOpenNoiseSuppresion = self.isOpenNoiseSuppresion;
    config.videoResolution = self.videoResolution;
    config.videoBitRate = self.videoBitRate;
    config.captureDevicePosition = AVCaptureDevicePositionBack;
#if VHallFilterSDK_ENABLE
    config.beautifyFilterEnable = YES;
    config.captureDevicePosition = AVCaptureDevicePositionFront;
#endif
    _torchBtn.hidden = YES;

    self.engine = [[VHallLivePublish alloc] initWithConfig:config];

#if VHallFilterSDK_ENABLE
    _torchBtn.hidden = YES;
    _isFontVideo = YES;
    
    [self filterSettingBtnClick:_defaultFilterSelectBtn];
#endif

    
    self.engine.delegate = self;

    self.engine.displayView.frame   = _perView.bounds;
    [self.perView insertSubview:_engine.displayView atIndex:0];
    
//    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
//    param[@"id"] =  _roomId;
//    param[@"access_token"] = _token;
//    [self.engine startLive:param];
//
//    //开始视频采集、并显示预览界面
    [self.engine startVideoCapture];

    
    _noiseView.hidden = !_isOpenNoiseSuppresion;

    // chat 模块
    _chat = [[VHallChat alloc] initWithLivePublish:self.engine];
    _chat.delegate = self;
}

- (IBAction)swapBtnClick:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    btn.enabled=NO;
    _isFontVideo = !_isFontVideo;

    BOOL success=  [_engine swapCameras:_isFontVideo ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack];
    
    if(success)
    {
        _torchBtn.hidden = _isFontVideo;
        //禁止快速切换摄像头
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            btn.enabled=YES;
        });
    }
    
    if (!self.engine.isPublishing) {
        _torchBtn.hidden = YES;
    }
}

- (IBAction)torchBtnClick:(UIButton*)sender
{
    _torchType = !_torchType;
    sender.selected = _torchType;
    [_engine setDeviceTorchModel:_torchType ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
}

- (IBAction)onlyVideoBtnClick:(UIButton*)sender
{
    _onlyVideo = !_onlyVideo;
    sender.selected = _onlyVideo;
    _engine.isMute = _onlyVideo;
}

- (BOOL)emCheckMicrophoneAvailability{
    __block BOOL ret = NO;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            ret = granted;
        }];
    } else {
        ret = YES;
    }
    return ret;
}

- (IBAction)startVideoPlayer
{
#if (TARGET_IPHONE_SIMULATOR)
    [self showMsg:@"无法在模拟器上发起直播！" afterDelay:1.5];
    return;
#endif
    
    if (!_isVideoStart)
    {
    //        _isAudioStart = YES;
    //        [self startAudioPlayer];
    //    self.engine.audioBitRate = _audioBitRate;
        [_chatDataArray removeAllObjects];
        [_chatView update];
        [_hud show:YES];
        _torchBtn.hidden = NO;

        NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
        param[@"id"] =  _roomId;
        param[@"access_token"] = _token;
//        param[@"is_single_audio"] = @"0";    // 0 ：视频， 1：音频
        [_engine startLive:param];

        self.engine.displayView.frame   = _perView.bounds;
        [self.perView insertSubview:_engine.displayView atIndex:0];
    }
    else
    {
        _isVideoStart=NO;
        _bitRateLabel.text = @"";
        [_hud hide:YES];
        _videoStartAndStopBtn.selected = NO;
        [self chatShow:NO];
        _torchBtn.hidden = YES;
        [_engine stopLive];//停止活动
    }
    _logView.hidden = YES;
    //_isVideoStart = !_isVideoStart;
}

- (IBAction)startAudioPlayer
{
//    TODO:暂时不支持此功能，但保留。
//    if (!_isAudioStart)
//    {
//        _isVideoStart = YES;
//        [self startVideoPlayer];
//
//        _logView.hidden = NO;
//        _chatBtn.hidden = NO;
//        [_hud show:YES];

//        NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
//        param[@"id"] =  _roomId;
//        param[@"access_token"] = _token;
//        param[@"is_single_audio"] = @"1";   // 0 ：视频， 1：音频
//        [_engine startLive:param];
//    }else{
//        _logView.hidden = YES;
//        _bitRateLabel.text = @"";
//        _chatBtn.hidden = YES;
//        [_hud hide:YES];
//        [_audioStartAndStopBtn setTitle:@"音频直播" forState:UIControlStateNormal];
//        [_engine disconnect];//停止向服务器推流
//    }
//    _isAudioStart = !_isAudioStart;
}

#pragma mark Delegate

-(void)firstCaptureImage:(UIImage *)image
{
    VHLog(@"第一张图片");
}

-(void)publishStatus:(VHLiveStatus)liveStatus withInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    void (^resetStartPlay)(NSString * msg) = ^(NSString * msg){
        dispatch_async(dispatch_get_main_queue(), ^{
            _isVideoStart = NO;
            _bitRateLabel.text = @"";
            _videoStartAndStopBtn.selected = NO;
            [weakSelf chatShow:NO];
            [UIAlertView popupAlertByDelegate:nil title:msg message:nil];
        });
    };

    BOOL errorLiveStatus = NO;
    NSString * content = info[@"content"];
    switch (liveStatus)
    {
        case VHLiveStatusUploadSpeed:
        {
            _bitRateLabel.text = [NSString stringWithFormat:@"%@ kb/s",content];
        }
            break;
        case VHLiveStatusPushConnectSucceed:
        {
            [_hud hide:YES];
            [weakSelf chatShow:YES];
            _isVideoStart=YES;
            if (_isVideoStart || _isAudioStart) {
                _videoStartAndStopBtn.selected = YES;
            }
        }
            break;
        case VHLiveStatusSendError:
        {
            resetStartPlay(@"流发送失败");
            errorLiveStatus = YES;
        }
            break;
        case VHLiveStatusPushConnectError:
        {
            [_hud hide:YES];
            NSString *str =[NSString stringWithFormat:@"连接失败:%@",content];
            resetStartPlay(str);
            errorLiveStatus = YES;
        }
            break;
        case VHLiveStatusParamError:
        {
            [_hud hide:YES];
            resetStartPlay(@"参数错误");
            errorLiveStatus = YES;
        }
            break;
        case VHLiveStatusGetUrlError:
        {
            [_hud hide:YES];
            _isVideoStart=NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showMsg:content afterDelay:1.5];
            });
            errorLiveStatus = YES;
        }
            break;
        case VHLiveStatusUploadNetworkOK:
        {
            _bitRateLabel.textColor = [UIColor greenColor];
            VHLog(@"kLiveStatusNetworkStatus:%@",content);
        }
            break;
        case VHLiveStatusUploadNetworkException:
        {
            _bitRateLabel.textColor = [UIColor redColor];
            VHLog(@"kLiveStatusNetworkStatus:%@",content);
            errorLiveStatus = YES;
        }
            break;
        case  VHLiveStatusAudioRecoderError :
        {
            [_hud hide:YES];
            _isVideoStart=NO;
            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf showMsg:@"音频采集失败,可能是麦克风未授权使用" afterDelay:1.5];
                [_engine disconnect];
                resetStartPlay(@"音频采集失败,可能是麦克风未授权使用");
            });
            errorLiveStatus = YES;
        }
            break;
        default:
            break;
    }
}


#if VHallFilterSDK_ENABLE
#pragma mark - Filter
#pragma mark -
- (IBAction)filterBtnClick:(UIButton *)sender
{
//    [_chatMsgInput resignFirstResponder];
    _filterBtn.selected = !_filterBtn.selected;
    if(_filterBtn.selected)
    {
        _hideKeyBtn.hidden = NO;
        _filterView.alpha = 0.0f;
        [UIView animateWithDuration:0.3f animations:^{
            _filterView.alpha = 1.0f;
        }];
    }
    else
    {
        _hideKeyBtn.hidden = YES;
        _filterView.alpha = 1.0f;
        [UIView animateWithDuration:0.3f animations:^{
            _filterView.alpha = 0.0f;
        }];
    }
}

- (IBAction)filterSettingBtnClick:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    
    if (_lastFilterSelectBtn) {
        [_lastFilterSelectBtn setBackgroundColor:MakeColorRGBA(0x000000,0.5)];
        _lastFilterSelectBtn.selected = NO;
    }
    
    sender.selected = YES;
    [sender setBackgroundColor:MakeColorRGBA(0xfd3232,0.5)];
    _lastFilterSelectBtn = sender;

//    switch (sender.tag) {
//        case 1:[_engine setBeautifyFilterWithBilateral:10.0f Brightness:1.0f  Saturation:1.0f];break;
//        case 2:[_engine setBeautifyFilterWithBilateral:8.0f  Brightness:1.05f Saturation:1.0f];break;
//        case 3:[_engine setBeautifyFilterWithBilateral:6.0f  Brightness:1.10f Saturation:1.0f];break;
//        case 4:[_engine setBeautifyFilterWithBilateral:4.0f  Brightness:1.15f Saturation:1.0f];break;
//        case 5:[_engine setBeautifyFilterWithBilateral:2.0f  Brightness:1.20f Saturation:1.0f];break;
//        default:break;
//    }
    
//    *  @param beautify   磨皮   默认 2.0f  取值范围[1.0, 10.0]  10.0 正常图片没有磨皮
//    *  @param brightness 亮度   默认 1.20f 取值范围[0.0, 2.0]  1.0 正常亮度
//    *  @param saturation 饱和度 默认 1.0f  取值范围[0.0, 2.0]  1.0 正常饱和度
//    *  @param sharpness  锐化   默认 0.5f  取值范围[-4.0，4.0] 0.0 正常锐化

    switch (sender.tag) {
        case 1:[self.engine setBeautify:10.0f Brightness:1.0f Saturation:1.0f Sharpness:1.0f];break;
        case 2:[self.engine setBeautify:8.0f Brightness:1.25f Saturation:1.25f Sharpness:1.0f];break;
        case 3:[self.engine setBeautify:6.0f Brightness:1.5f Saturation:1.5f Sharpness:1.0f];break;
        case 4:[self.engine setBeautify:4.0f Brightness:1.75f Saturation:1.75f Sharpness:1.0f];break;
        case 5:[self.engine setBeautify:2.0f Brightness:2.0f Saturation:1.0f Sharpness:1.0f];break;
        default:break;
    }
}
#else
- (IBAction)filterBtnClick:(UIButton *)sender{}
- (IBAction)filterSettingBtnClick:(UIButton *)sender{}
#endif

#pragma mark - Chat && QA
#pragma mark -

- (void)chatShow:(BOOL)isShow
{
    if(isShow)
    {
        _chatContainerView.alpha = 0.0f;
        [UIView animateWithDuration:0.3f animations:^{
            _chatContainerView.alpha = 1.0f;
        }];
        _closeBtn.hidden = YES;
        _infoView.hidden = NO;
        [self showTimeInfo];
    }
    else
    {
        _chatContainerView.alpha = 1.0f;
        [UIView animateWithDuration:0.3f animations:^{
            _chatContainerView.alpha = 0.0f;
        }];
        _closeBtn.hidden = NO;
        _infoView.hidden = YES;
        if(_timer)
        {
            dispatch_source_cancel(_timer);
            _timer = nil;
        }
        _bitRateLabel.text = @"0 kb/s";
        _bitRateLabel.textColor = [UIColor greenColor];
        _timeLabel.text    = @"00:00:00";
    }
}

- (IBAction)sendMsgButtonClick:(UIButton *)sender {
    _messageToolView.hidden = NO;
    _messageToolView.msgTextView.hidden = NO;
    [_messageToolView.msgTextView becomeFirstResponder];
    [self.view addSubview:_messageToolView];
    _hideKeyBtn.hidden = NO;
}

#pragma mark Chat && QA(VHallChatDelegate)
- (void)reciveOnlineMsg:(NSArray *)msgs
{
    if (msgs.count > 0) {
        for (VHallOnlineStateModel *m in msgs) {
            VHActMsg * msg = [[VHActMsg alloc]initWithMsgType:ActMsgTypeMsg];
            msg.actId= m.room;
            msg.joinId= m.join_id;
            msg.formUserIcon= m.avatar;
            msg.formUserName= m.user_name;
            msg.formUserId= m.account_id;
            msg.time= m.time;

            NSString *event;
            NSString *role;
            if([m.event isEqualToString:@"online"]) {
                event = @"进入";
            }else if([m.event isEqualToString:@"offline"]){
                event = @"离开";
            }
            
            if([m.role isEqualToString:@"host"]) {
                role = @"主持人";
            }else if([m.role isEqualToString:@"guest"]) {
                role = @"嘉宾";
            }else if([m.role isEqualToString:@"assistant"]) {
                role = @"助手";
            }else if([m.role isEqualToString:@"user"]) {
                role = @"观众";
            }
            
            msg.text = [NSString stringWithFormat:@"%@\n[%@] %@房间:%@ 在线:%@ 参会:%@",m.time,role,event,m.room, m.concurrent_user, m.attend_count];
            [_chatDataArray addObject:msg];
        }
        [_chatView update];
    }
}

- (void)reciveChatMsg:(NSArray *)msgs
{
    if (msgs.count > 0) {
        for (VHallChatModel *m in msgs) {
            VHActMsg * msg = [[VHActMsg alloc]initWithMsgType:ActMsgTypeMsg];
            msg.actId= m.room;
            msg.joinId= m.join_id;
            msg.formUserIcon= m.avatar;
            msg.formUserName= m.user_name;
            msg.formUserId= m.account_id;
            msg.time= m.time;
            msg.text = [NSString stringWithFormat:@"%@\n%@",m.time, m.text];
            [_chatDataArray addObject:msg];
        }
        [_chatView update];
    }
}

-(void)showTimeInfo{
    if(_timer)
    {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    _liveTime = 0;
    dispatch_queue_t queue = dispatch_queue_create("my queue", 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1 * NSEC_PER_SEC, 0);//间隔1秒
    dispatch_source_set_event_handler(_timer, ^(){
        _liveTime++;
        NSString *strInfo = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",_liveTime/3600,(_liveTime/60)%60,_liveTime%60];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_timeLabel)
            {
                _timeLabel.text = strInfo;
            }
        });
    });
    dispatch_resume(_timer);
}

- (IBAction)hideKey:(id)sender {
    [_messageToolView endEditing:YES];
 
    _hideKeyBtn.hidden = YES;
    _filterBtn.selected = NO;
    [UIView animateWithDuration:0.3f animations:^{
        _filterView.alpha = 0.0f;
    }];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.2);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        _messageToolView.hidden = YES;
        _messageToolView.msgTextView.hidden = YES;
        [_messageToolView removeFromSuperview];
    });
}
- (IBAction)noiseSliderValueVhange:(UISlider *)sender {
    _noiseLabel.text = [NSString stringWithFormat:@"音频增益：%f",sender.value];
    [_engine setVolumeAmplificateSize:sender.value];
}

#pragma mark - messageToolViewDelegate
- (void)didSendText:(NSString *)text
{
    if(text == nil || text.length <= 0)
    {
        [super showMsg:@"发送内容不能为空" afterDelay:1.5];
        return;
    }
    
    [self hideKey:nil];
    [_chat sendMsg:text success:^{
    } failed:^(NSDictionary *failedData) {
        NSString* error = [NSString stringWithFormat:@"(%@)%@", failedData[@"code"],failedData[@"content"]];
        [super showMsg:error afterDelay:2];
    }];
}
- (void)cancelTextView
{
    [self hideKey:nil];
}

@end
