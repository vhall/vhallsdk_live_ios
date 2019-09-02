//
//  VHInvitationAlert.m
//  LightEnjoy
//
//  Created by vhall on 2018/7/13.
//  Copyright © 2018年 vhall. All rights reserved.
//

#import "VHInvitationAlert.h"

@interface VHInvitationAlert ()
{
    int curCnt;
}
@property (nonatomic, strong) UIView *alert;
@property(nonatomic,strong) dispatch_source_t timer;//每1s计时器
@end




@implementation VHInvitationAlert


- (instancetype)initWithDelegate:(id)delegate
                             tag:(NSInteger)tag
                           title:(NSString *)title
                         content:(NSString *)content
{
    VHInvitationAlert *alertView = [[VHInvitationAlert alloc] initWithFrame:[UIScreen mainScreen].bounds title:title content:content];
    alertView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    alertView.tag = tag;
    alertView.delegate = delegate;
    
    return alertView;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    self.frame = [UIScreen mainScreen].bounds;
}

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                      content:(NSString *)content
{
    if (self = [super initWithFrame:frame]) {
        curCnt = 30;
        //320 170
        self.alert = [[UIView alloc] init];
        self.alert.frame = CGRectMake(self.width*0.5-155, [UIScreen mainScreen].bounds.size.height*0.5-304*0.5, 310, 304);
        self.alert.backgroundColor = [UIColor whiteColor];
        self.alert.layer.cornerRadius = 4;
        [self addSubview:_alert];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.alert.width, 24)];
        label.text = title;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:22];
        label.textAlignment = NSTextAlignmentCenter;
        [self.alert addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.alert.width, 21)];
        label1.text = content;
        label1.textColor = [UIColor blackColor];
        label1.font = [UIFont systemFontOfSize:17];
        label1.textAlignment = NSTextAlignmentCenter;
        [self.alert addSubview:label1];
        
        self.hearderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.hearderBtn.backgroundColor = MakeColorRGB(0xFC5659);
        self.hearderBtn.frame = CGRectMake(23, 170,  self.alert.width-46, 47);
        self.hearderBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        self.hearderBtn.layer.cornerRadius = 4;
        [self.hearderBtn setTitle:[NSString stringWithFormat:@"同意(%ds)",curCnt] forState:UIControlStateNormal];
        [self.hearderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.alert addSubview:self.hearderBtn];
        self.hearderBtn.tag = 1;
        [self.hearderBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.frame = CGRectMake(23, self.hearderBtn.bottom+15,  self.alert.width-46, 47);
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        cancelBtn.layer.cornerRadius = 4;
        cancelBtn.layer.borderColor = MakeColorRGB(0xFC5659).CGColor;
        cancelBtn.layer.borderWidth = 1;
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.alert addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];


        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(_alert.width-32, 16, 16, 16);
        [self.closeButton setImage:[UIImage imageNamed:@"UIModel.bundle/关闭.tiff"] forState:UIControlStateNormal];
        self.closeButton.imageView.contentMode = UIViewContentModeRight;
        [self.closeButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.alert addSubview:self.closeButton];

        [self startTimer];
    }
    return self;
}

- (void)btnClicked:(UIButton*)btn
{
    [self stopTimer];
    if([self.delegate respondsToSelector:@selector(alert: clickAtIndex:)])
    {
        [self.delegate alert:self clickAtIndex:btn.tag];
    }
    [self removeFromSuperview];
}

- (void)timeEvent
{
    dispatch_async(dispatch_get_main_queue(), ^{
        curCnt--;
        [self.hearderBtn setTitle:[NSString stringWithFormat:@"同意(%ds)",curCnt] forState:UIControlStateNormal];
        if(curCnt <= 0)
        {
            [self stopTimer];
            [self btnClicked:_closeButton];
        }
    });
}
- (void)startTimer//1s
{
    if (!_timer) {
        __weak typeof(self) weakSelf = self;
        dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        //开始时间
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
        //间隔时间
        uint64_t interval = NSEC_PER_SEC;
        dispatch_source_set_timer(_timer,start, interval, 0);
        dispatch_source_set_event_handler(_timer, ^{
            [weakSelf timeEvent];
        });
        
        dispatch_source_set_cancel_handler(_timer, ^{
            //            NSLog(@"timersource cancel handle block");
        });
        dispatch_resume(_timer);
    }
}
- (void)stopTimer
{
    if(_timer)
    {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
@end
