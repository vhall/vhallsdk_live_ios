//
//  WatchPlayBackViewController.m
//  VHallSDKDemo
//
//  Created by developer_k on 16/4/12.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import "WatchPlayBackViewController.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import <AVFoundation/AVFoundation.h>
#import "WatchLiveChatTableViewCell.h"
#import "VHallApi.h"
#import "VHMessageToolView.h"
#import "VHPullingRefreshTableView.h"
#import "UIView+ITTAdditions.h"
#import "AnnouncementView.h"
//#import "VHDrawView.h"
#import "VHDocumentView.h"


static AnnouncementView* announcementView = nil;
@interface WatchPlayBackViewController ()<VHallMoviePlayerDelegate,UITableViewDelegate,UITableViewDataSource,VHPullingRefreshTableViewDelegate>
{
    VHallMoviePlayer  *_moviePlayer;//播放器
    VHallComment*_comment;
    int  _bufferCount;
    NSMutableArray *_commentsArray;//评论
    VHPullingRefreshTableView* _tableView;
    UIButton              *_toolViewBackView;//遮罩
//    VHDrawView *_pptHandView;//PPT
//    VHDrawView *_whiteBoardView;//白板
//    UIView     *_whiteBoardContainer;//白板容器
    
    VHDocumentView* _documentView;
}

@property (weak, nonatomic) IBOutlet UILabel *bufferCountLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property(nonatomic,strong) MPMoviePlayerController * hlsMoviePlayer;
@property (weak, nonatomic) IBOutlet UIImageView *textImageView;
@property (nonatomic,assign) VHallMovieVideoPlayMode playModelTemp;
@property (nonatomic,strong) UILabel*textLabel;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@property (weak, nonatomic) IBOutlet UIButton *getHistoryCommentBtn;
@property (weak, nonatomic) IBOutlet UILabel *liveTypeLabel;

@property (nonatomic,strong) VHMessageToolView * messageToolView;  //输入框
@property (weak, nonatomic) IBOutlet UIView *historyCommentTableView;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *docBtn;
@property (weak, nonatomic) IBOutlet UIButton *detalBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *showView;

@end

@implementation WatchPlayBackViewController

-(UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.frame = CGRectMake(0, 10, self.textImageView.width, 21);
        _textLabel.text = @"无文档";
        _textLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _textLabel;
}
#pragma mark - Private Method

-(void)addPanGestureRecognizer
{
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    [self.view addGestureRecognizer:panGesture];
}

- (void)initViews
{
    _comment = [[VHallComment alloc] init];
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self addPanGestureRecognizer];
    [self registerLiveNotification];
    _moviePlayer = [[VHallMoviePlayer alloc]initWithDelegate:self];
    self.hlsMoviePlayer =[[MPMoviePlayerController alloc] init];
    self.hlsMoviePlayer.controlStyle=MPMovieControlStyleDefault;
    [self.hlsMoviePlayer prepareToPlay];
    [self.hlsMoviePlayer.view setFrame:self.view.bounds];  // player的尺寸
    self.hlsMoviePlayer.shouldAutoplay=YES;
    self.hlsMoviePlayer.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.hlsMoviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:self.hlsMoviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayeExitFullScreen:) name:MPMoviePlayerDidExitFullscreenNotification object:self.hlsMoviePlayer];
    
    _tableView = [[VHPullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, VH_SW, _historyCommentTableView.height) pullingDelegate:self headView:YES  footView:YES];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.startPos = 0;
    _tableView.tag = -1;
    _tableView.dataArr = [NSMutableArray array];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = self.view.backgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableView tableViewDidFinishedLoading];
    [_historyCommentTableView addSubview:_tableView];

}

- (void)destoryMoivePlayer
{
    [_moviePlayer destroyMoivePlayer];
    
}

//注册通知
- (void)registerLiveNotification
{
    [self.view addObserver:self forKeyPath:kViewFramePath options:NSKeyValueObservingOptionNew context:nil];
    //已经进入活跃状态的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive)name:UIApplicationDidBecomeActiveNotification object:nil];
    //监听耳机的插拔
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(outputDeviceChanged:)name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
}

#pragma mark - 返回上层界面
- (IBAction)closeBtnClick:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
            [weakSelf destoryMoivePlayer];
            [weakSelf.hlsMoviePlayer stop];
            weakSelf.hlsMoviePlayer = nil;
    }];
}

#pragma mark - 屏幕自适应
- (IBAction)allScreenBtnClick:(UIButton*)sender
{
    NSInteger mode = self.hlsMoviePlayer.scalingMode+1;
    if(mode>3)
        mode = 0;
    self.hlsMoviePlayer.scalingMode = mode;

}

#pragma mark - Lifecycle Method
- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:meetingResourcesBundle];
    if (self) {
    }
    return self;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration
{
    //如果是iosVersion  8.0之前，UI出现问题请在此调整
    if (IOSVersion<8.0)
    {
        CGRect frame = self.view.frame;
        CGRect bounds = [[UIScreen mainScreen]bounds];
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait// UIInterfaceOrientationPortrait
            || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) { //UIInterfaceOrientationPortraitUpsideDown
            //竖屏
            frame = _backView.bounds;
        } else {
            //横屏
            frame = CGRectMake(0, 0, bounds.size.height, bounds.size.width);
        }
        if (self.watchVideoType == kWatchVideoRTMP)
        {
            _moviePlayer.moviePlayerView.frame = frame;

        }else if(self.watchVideoType == kWatchVideoHLS||self.watchVideoType == kWatchVideoPlayback)
        {
            _hlsMoviePlayer.view.frame = frame;
            [self.backView addSubview:self.hlsMoviePlayer.view];
            [self.backView sendSubviewToBack:_hlsMoviePlayer.view];
        }
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
}

-(void)viewWillLayoutSubviews
{
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait)
        
    {
        _topConstraint.constant = 20;
    }
    else
    {
        _topConstraint.constant = 0;
    }
}

- (void)viewDidLayoutSubviews
{
    _hlsMoviePlayer.view.frame = _backView.bounds;
    [self.backView addSubview:self.hlsMoviePlayer.view];
    [self.backView sendSubviewToBack:self.hlsMoviePlayer.view];
    if (_documentView)
    {
        _documentView.frame = self.textImageView.bounds;
        [_documentView layoutSubviews];
        
    }
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initViews];
    _commentsArray=[NSMutableArray array];//初始化评论数组
    
    if (self.hlsMoviePlayer.view) {
        [MBProgressHUD showHUDAddedTo:self.hlsMoviePlayer.view animated:YES];
    }
    //todo
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    param[@"id"] =  _roomId;
    param[@"name"] = [UIDevice currentDevice].name;
    param[@"email"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    param[@"record_id"] = DEMO_Setting.recordID;
    if (_password&&_password.length) {
        param[@"pass"] = _password;
    }
    [_moviePlayer startPlayback:param moviePlayer:self.hlsMoviePlayer];

    //播放器
    _hlsMoviePlayer.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.backView.height);//self.view.bounds;
    [self.backView addSubview:self.hlsMoviePlayer.view];
    [self.backView sendSubviewToBack:self.hlsMoviePlayer.view];

    if (self.playModelTemp == VHallMovieVideoPlayModeTextAndVoice ) {
        self.liveTypeLabel.text = @"语音回放中";
    }else{
        self.liveTypeLabel.text = @"";
    }

    if (self.textImageView.image == nil) {
        [self.textImageView addSubview:self.textLabel];
    }else{
        [self.textLabel removeFromSuperview];
        self.textLabel = nil;
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[_tableView launchRefreshing];
    
}
- (void)dealloc
{
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self.view removeObserver:self forKeyPath:kViewFramePath];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    VHLog(@"%@ dealloc",[[self class]description]);
}

#pragma mark - VHMoviePlayerDelegate

-(void)connectSucceed:(VHMoviePlayer *)moviePlayer info:(NSDictionary *)info
{

}

-(void)bufferStart:(VHMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
    _bufferCount++;
    _bufferCountLabel.text = [NSString stringWithFormat:@"卡顿次数： %d",_bufferCount];
}

-(void)bufferStop:(VHMoviePlayer *)moviePlayer info:(NSDictionary *)info
{

}

-(void)downloadSpeed:(VHMoviePlayer *)moviePlayer info:(NSDictionary *)info
{
//    NSString * content = info[@"content"];
    VHLog(@"downloadSpeed:%@",[info description]);
}

- (void)playError:(LivePlayErrorType)livePlayErrorType info:(NSDictionary *)info;
{
    if (self.hlsMoviePlayer.view) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.hlsMoviePlayer.view animated:YES];
        });
    }
    
    void (^resetStartPlay)(NSString * msg) = ^(NSString * msg){
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (APPDELEGATE.isNetworkReachable) {
                [UIAlertView popupAlertByDelegate:nil title:msg message:nil];
//            }else{
//                [UIAlertView popupAlertByDelegate:nil title:@"没有可以使用的网络" message:nil];
//            }
        });
    };
    
    NSString * msg = @"";
    switch (livePlayErrorType) {
        case kLivePlayParamError:
        {
            msg = @"参数错误";
            resetStartPlay(msg);
        }
            break;
        case kLivePlayRecvError:
        {
            msg = @"对方已经停止直播";
            resetStartPlay(msg);
        }
            break;
        case kLivePlayCDNConnectError:
        {
            msg = @"服务器任性...连接失败";
            resetStartPlay(msg);
        }
            break;
        case kLivePlayGetUrlError:
        {
            msg = @"获取服务器地址报错";
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBHUDHelper showWarningWithText:info[@"content"]];
            });
        }
            break;
        default:
            break;
    }
}

- (void)netWorkStatus:(VHMoviePlayer*)moviePlayer info:(NSDictionary*)info
{
    VHLog(@"netWorkStatus:%f",[info[@"content"]floatValue]);
}


-(void)PPTScrollNextPagechangeImagePath:(NSString *)changeImagePath
{
    if (changeImagePath.length<=0) {
        [self.textImageView addSubview:self.textLabel];
    }else{
        [self.textLabel removeFromSuperview];
        self.textLabel = nil;
        
    }
    
    if(!_documentView)
    {
        _documentView = [[VHDocumentView alloc]initWithFrame:self.textImageView.bounds];
        _documentView.contentMode = UIViewContentModeScaleAspectFit;
        _documentView.backgroundColor=MakeColorRGB(0xe2e8eb);
    }
    _documentView.frame = self.textImageView.bounds;
    [self.textImageView addSubview:_documentView];
    _documentView.imagePath = changeImagePath;
}

- (void)docHandList:(NSArray*)docList whiteBoardHandList:(NSArray*)boardList
{
    if(!_documentView)
    {
        _documentView = [[VHDocumentView alloc]initWithFrame:self.textImageView.bounds];
        _documentView.contentMode = UIViewContentModeScaleAspectFit;
        _documentView.backgroundColor=MakeColorRGB(0xe2e8eb);
    }
    _documentView.frame = self.textImageView.bounds;
    [self.textImageView addSubview:_documentView];
    [_documentView drawDocHandList:docList whiteBoardHandList:boardList];
}

-(void)VideoPlayMode:(VHallMovieVideoPlayMode)playMode isVrVideo:(BOOL)isVrVideo
{
    VHLog(@"---%ld",(long)playMode);
    self.playModelTemp = playMode;
    self.liveTypeLabel.text = @"";
    _hlsMoviePlayer.controlStyle = MPMovieControlStyleEmbedded;

    switch (playMode) {
        case VHallMovieVideoPlayModeNone:
        case VHallMovieVideoPlayModeMedia:

            break;
        case VHallMovieVideoPlayModeTextAndVoice:
        {
            self.liveTypeLabel.text = @"语音直播中";
        }

            break;

        case VHallMovieVideoPlayModeTextAndMedia:
            
            break;
        default:
            break;
    }

    
    [self alertWithMessage:playMode];
}

-(void)ActiveState:(VHallMovieActiveState)activeState
{
    VHLog(@"activeState-%ld",(long)activeState);
}



- (void)Announcement:(NSString*)content publishTime:(NSString*)time
{
    NSLog(@"公告:%@",content);
    
    if(!announcementView)
    { //横屏时frame错误
        if (_showView.width < [UIScreen mainScreen].bounds.size.height)
        {
            announcementView = [[AnnouncementView alloc]initWithFrame:CGRectMake(0, 0, _showView.width, 35) content:content time:nil];
        }else
        {
            announcementView = [[AnnouncementView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, 35) content:content time:nil];
        }
        
    }
    announcementView.content = [content stringByAppendingString:time];
    [_showView addSubview:announcementView];
}

#pragma mark - ALMoviePlayerControllerDelegate
- (void)movieTimedOut
{

}

- (void)moviePlayerWillMoveFromWindow
{
    if (![self.backView.subviews containsObject:self.hlsMoviePlayer.view])
        [self.backView sendSubviewToBack:self.hlsMoviePlayer.view];
    //you MUST use [ALMoviePlayerController setFrame:] to adjust frame, NOT [ALMoviePlayerController.view setFrame:]
    //[self.hlsMoviePlayer setFrame:self.view.frame];
}

#pragma mark - UIPanGestureRecognizer
-(void)handlePan:(UIPanGestureRecognizer*)pan
{
    float baseY = 200.0f;
    CGPoint translation = CGPointZero;
    static float volumeSize = 0.0f;
    CGPoint currentLocation = [pan translationInView:self.view];
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        translation = [pan translationInView:self.view];
        volumeSize = [VHMoviePlayer getSysVolumeSize];
    }else if(pan.state == UIGestureRecognizerStateChanged)
    {
        float y = currentLocation.y-translation.y;
        float changeSize = ABS(y)/baseY;
        if (y>0){
            [VHMoviePlayer setSysVolumeSize:volumeSize-changeSize];
        }else{
            [VHMoviePlayer setSysVolumeSize:volumeSize+changeSize];
        }
    }
}

#pragma mark - ObserveValueForKeyPath
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:kViewFramePath])
    {
//        CGRect frame = [[change objectForKey:NSKeyValueChangeNewKey]CGRectValue];
        _hlsMoviePlayer.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.backView.height);
        //[self.backView addSubview:self.hlsMoviePlayer.view];
        [self.backView sendSubviewToBack:self.hlsMoviePlayer.view];

    }
}

- (void)moviePlaybackStateDidChange:(NSNotification *)note
{
    switch (self.hlsMoviePlayer.playbackState)
    {
        case MPMoviePlaybackStatePlaying:
        {
            VHLog(@"播放");
            if (self.playModelTemp == VHallMovieVideoPlayModeTextAndVoice )
            self.liveTypeLabel.text = @"语音回放中";
        }
            break;
        case MPMoviePlaybackStateSeekingBackward:
        case MPMoviePlaybackStateSeekingForward:
        {
            VHLog(@"快进－－快退");
        }
            break;
        case MPMoviePlaybackStateInterrupted:
        {
            VHLog(@"中断了");
        }
            break;
        case MPMoviePlaybackStatePaused:
        {
            VHLog(@"暂停");
            if (self.hlsMoviePlayer.view) {
                [MBProgressHUD hideAllHUDsForView:self.hlsMoviePlayer.view animated:YES];
            }
            if (self.playModelTemp == VHallMovieVideoPlayModeTextAndVoice )
            self.liveTypeLabel.text = @"已暂停语音回放";
        }
            break;
        case MPMoviePlaybackStateStopped:
        {
            VHLog(@"停止播放");
            if (self.hlsMoviePlayer.view) {
                [MBProgressHUD hideAllHUDsForView:self.hlsMoviePlayer.view animated:YES];
            }
            if (self.playModelTemp == VHallMovieVideoPlayModeTextAndVoice )
            self.liveTypeLabel.text = @"已暂停语音回放";
        }
            break;
        default:
            break;
    }
}

- (void)movieLoadStateDidChange:(NSNotification *)note
{
    if (self.hlsMoviePlayer.loadState == MPMovieLoadStatePlayable)
    {
        if (self.hlsMoviePlayer.view) {
            [MBProgressHUD showHUDAddedTo:self.hlsMoviePlayer.view animated:YES];
        }
        VHLog(@"开始加载加载");
    }else if(self.hlsMoviePlayer.loadState == (MPMovieLoadStatePlaythroughOK|MPMovieLoadStatePlayable))
    {
        if (self.hlsMoviePlayer.view) {
            [MBProgressHUD hideAllHUDsForView:self.hlsMoviePlayer.view animated:YES];
        }
        VHLog(@"加载完成");
    }
}

-(void)moviePlayeExitFullScreen:(NSNotification*)note
{
    if(announcementView !=nil)
    {
        [announcementView endAnimation];
        [announcementView startAnimation];
        
    }
}

- (void)didBecomeActive
{
    //观看直播
    [self.hlsMoviePlayer prepareToPlay];
    [self.hlsMoviePlayer play];
    
    if(announcementView !=nil)
    {   [announcementView endAnimation];
        [announcementView startAnimation];
        
    }
}

- (void)outputDeviceChanged:(NSNotification*)notification
{
    NSInteger routeChangeReason = [[[notification userInfo]objectForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason)
    {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
        {
            VHLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            VHLog(@"Headphone/Line plugged in");
        }
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            VHLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            VHLog(@"Headphone/Line was pulled. Stopping player....");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hlsMoviePlayer play];
            });
        }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
        {
            // called at start - also when other audio wants to play
            VHLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
        }
            break;
        default:
            break;
    }
}

#pragma mark - 详情
- (IBAction)detailsButtonClick:(UIButton *)sender {
    self.textImageView.hidden = YES;
    [_commentBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_docBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_detalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self getHistoryComment];
 
}

#pragma mark - 文档
- (IBAction)textButtonClick:(UIButton *)sender {
    [_docBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [_detalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.textImageView.hidden = NO;

}
- (IBAction)detailBtnClick:(id)sender {
    [_docBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [_detalBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

#pragma mark - 历史记录
- (IBAction)historyCommentButtonClick:(id)sender
{
    
    _tableView.startPos=0;
    [self pullingTableViewDidStartRefreshing:_tableView];
    
  }



#pragma mark -拉取前20条评论

-(void)getHistoryComment
{
    [_commentsArray removeAllObjects];
    [self historyCommentButtonClick:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_commentTextField resignFirstResponder];
    return YES;
}
- (IBAction)sendCommentBtnClick:(id)sender
{
    
        _toolViewBackView=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, VH_SW, VH_SH)];
        [_toolViewBackView addTarget:self action:@selector(toolViewBackViewClick) forControlEvents:UIControlEventTouchUpInside];
        _messageToolView=[[VHMessageToolView alloc] initWithFrame:CGRectMake(0, _toolViewBackView.height-[VHMessageToolView  defaultHeight], VHScreenWidth, [VHMessageToolView defaultHeight]) type:3];
        _messageToolView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _messageToolView.delegate=self;
        _messageToolView.hidden=NO;
        _messageToolView.maxLength=140;
        [_toolViewBackView addSubview:_messageToolView];
        [self.view addSubview:_toolViewBackView];
       [_messageToolView beginTextViewInView];
}

#pragma mark 点击聊天输入框蒙版
-(void)toolViewBackViewClick
{
    [_messageToolView endEditing:YES];
    [_toolViewBackView removeFromSuperview];
}
#pragma mark messageToolViewDelegate
- (void)didSendText:(NSString *)text
{
    __weak typeof(self) weakSelf=self;
    if(text.length>0)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_comment sendComment:text success:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            _commentTextField.text = @"";
            [UIAlertView popupAlertByDelegate:nil title:@"发表成功" message:nil];
            [weakSelf getHistoryComment];
            
        } failed:^(NSDictionary *failedData) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSString* code = [NSString stringWithFormat:@"%@", failedData[@"code"]];
            [UIAlertView popupAlertByDelegate:nil title:failedData[@"content"] message:code];
        }];
    }
}

#pragma mark - alertView
-(void)alertWithMessage : (VHallMovieVideoPlayMode)state
{
    NSString*message = nil;
    switch (state) {
        case 0:
            message = @"无内容";
            break;
        case 1:
            message = @"纯视频";
            break;
        case 2:
            message = @"文档＋声音";
            break;
        case 3:
            message = @"文档＋视频";
            break;

        default:
            break;
    }

    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark  tableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =nil;
    if (_commentsArray.count !=0)
    {
        id model = [_commentsArray objectAtIndex:indexPath.row];
        static NSString * indetify = @"WatchLiveChatCell";
        cell = [tableView dequeueReusableCellWithIdentifier:indetify];
        if (!cell) {
            cell = [[WatchLiveChatTableViewCell alloc]init];
        }
        ((WatchLiveChatTableViewCell *)cell).model = model;
    }else
    {
        static  NSString *indetify = @"identifyCell";
        cell = [tableView dequeueReusableCellWithIdentifier:indetify];
        if (!cell) {
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetify];
        }
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    
        return _commentsArray.count ;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    return 60;
   
    
}

#pragma mark delegate
#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(VHPullingRefreshTableView *)tableView
{
    
    [_commentsArray removeAllObjects];
    [self performSelector:@selector(loadData:) withObject:tableView];

    
}


- (void)pullingTableViewDidStartLoading:(VHPullingRefreshTableView *)tableView
{
    [self performSelector:@selector(loadData:) withObject:tableView];
}


- (void)loadData:(VHPullingRefreshTableView *)tableView
{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_comment getHistoryCommentPageCountLimit:20 offSet:_commentsArray.count success:^(NSArray *msgs) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (msgs.count > 0)
        {
            [_commentsArray addObjectsFromArray:msgs];
            [tableView tableViewDidFinishedLoading];
            tableView.reachedTheEnd = (msgs == nil || _commentsArray.count <= 5);
            [tableView reloadData];
            
            
        }
        
    } failed:^(NSDictionary *failedData) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSString* code = [NSString stringWithFormat:@"%@", failedData[@"code"]];
        [UIAlertView popupAlertByDelegate:nil title:failedData[@"content"] message:code];
    }];

    
}

@end
