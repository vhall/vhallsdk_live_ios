//
//  WatchLiveLotteryViewController.m
//  VHallSDKDemo
//
//  Created by Ming on 16/10/14.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import "WatchLiveLotteryViewController.h"
#import "WatchLiveLotteryTableViewCell.h"
#import <VHLiveSDK/VHallLottery.h>

@interface WatchLiveLotteryViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@end

@implementation WatchLiveLotteryViewController
{
    NSTimer * timer;
    __weak IBOutlet UILabel *lotteryTip;
    __weak IBOutlet UILabel *winTip;
    __weak IBOutlet UIButton *closeBtn;
    __weak IBOutlet UITableView *resultTable;
    __weak IBOutlet UILabel *lblName;
    __weak IBOutlet UITextField *tfName;
    __weak IBOutlet UILabel *lblPhone;
    __weak IBOutlet UITextField *tfPhone;
    __weak IBOutlet UIButton *btnSubmit;
}
- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:meetingResourcesBundle];
    if (self) {
        _lotteryOver = NO;
        resultTable.hidden = YES;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeText) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    lotteryTip.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    if (_lotteryOver) {
        [lotteryTip removeFromSuperview];
        lotteryTip = nil;
        resultTable.hidden  = NO;
        
        if (_endLotteryModel.isWin) {
            lblName.hidden      = NO;
            tfName.hidden       = lblName.hidden;
            lblPhone.hidden     = lblName.hidden;
            tfPhone.hidden      = lblName.hidden;
            btnSubmit.hidden    = lblName.hidden;
            winTip.text         = @"恭喜中奖";
        }
        else
        {
            winTip.text         = @"抽奖结果";
        }
    }
}

-(void)dealloc
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

-(void)setLotteryOver:(BOOL)lotteryOver
{
    _lotteryOver = lotteryOver;
    if (_lotteryOver)
    {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        [self loadView];
    }
}

- (IBAction)closeBtnClick:(id)sender
{
    [self destory];
}

- (IBAction)submitBtnClick:(id)sender
{
    NSString * name  = tfName.text;
    NSString * phone = tfPhone.text;
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", phone, @"phone", nil];
    [_lottery submitLotteryInfo:dict success:^{
        [self closeBtnClick:nil];
        [UIAlertView popupAlertByDelegate:nil title:@"提交成功" message:nil];
    } failed:^(NSDictionary *failedData) {
        
        NSString* code = [NSString stringWithFormat:@"%@", failedData[@"code"]];
        [UIAlertView popupAlertByDelegate:nil title:failedData[@"content"] message:code];
    }];
}

-(void)changeText
{
    if ([lotteryTip.text isEqualToString:@"抽奖中..."]) {
        lotteryTip.text = @"抽奖中";
    }
    else{
        lotteryTip.text = [lotteryTip.text stringByAppendingString:@"."];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _endLotteryModel.resultModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * qaIndetify = @"WatchLiveLotteryCell";
    WatchLiveLotteryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:qaIndetify];
    if (!cell) {
        cell = [[WatchLiveLotteryTableViewCell alloc]init];
    }
    cell.model = [_endLotteryModel.resultModels objectAtIndex:indexPath.row];
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tfName resignFirstResponder];
    [tfPhone resignFirstResponder];
    return YES;
}

- (void)destory
{
    self.lotteryOver = YES;
    self.view.hidden = YES;
}

@end
