//
//  MainViewController.m
//  PublishDemo
//
//  Created by liwenlong on 15/10/9.
//  Copyright (c) 2015年 vhall. All rights reserved.
//

#import "LoginViewController.h"
#import "VHHomeViewController.h"
#import "WHDebugToolManager.h"

@interface LoginViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation LoginViewController

#pragma mark - Private Method

-(void)initDatas
{
//   EnableVHallDebugModel(NO);
}

- (void)initViews
{
    _versionLabel.text      = [NSString stringWithFormat:@"v%@",[VHallApi sdkVersion]];
    _loginBtn.selected      = [VHallApi isLoggedIn];
    _accountTextField.text  = DEMO_Setting.account;
    _passwordTextField.text = DEMO_Setting.password;
}

- (IBAction)loginBtnClick:(id)sender
{
    [self closeKeyBtnClick:nil];

    if([DEMO_AppKey isEqualToString:@"替换成您自己的AppKey"])//此处只用于提示信息判断，只替换CONSTS.h中的AppKey即可
    {
        [self showMsg:@"请填写CONSTS.h中的AppKey" afterDelay:1.5];
        return;
    }

    if(_accountTextField.text.length <= 0 || _passwordTextField.text.length <= 0)
    {
        [self showMsg:@"账号或密码为空" afterDelay:1.5];
        return;
    }
    
    DEMO_Setting.account  = _accountTextField.text;
    DEMO_Setting.password = _passwordTextField.text;
    __weak typeof(self) weekself = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [VHallApi loginWithAccount:DEMO_Setting.account password:DEMO_Setting.password success:^{
        
        weekself.loginBtn.selected = [VHallApi isLoggedIn];
        [MBProgressHUD hideAllHUDsForView:weekself.view animated:YES];
        VHLog(@"Account: %@ userID:%@",[VHallApi currentAccount],[VHallApi currentUserID]);
        [weekself showMsg:@"登录成功" afterDelay:1.5];
        VHHomeViewController *homeVC=[[VHHomeViewController alloc] init];
        homeVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [weekself presentViewController:homeVC animated:YES completion:nil];
        
    } failure:^(NSError * error) {
        weekself.loginBtn.selected = [VHallApi isLoggedIn];
        VHLog(@"登录失败%@",error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD hideAllHUDsForView:weekself.view animated:YES];
            [weekself showMsg:error.domain afterDelay:1.5];
        });
    }];

}

- (IBAction)guestCLick:(id)sender
{
    if([DEMO_AppKey isEqualToString:@"替换成您自己的AppKey"])//此处只用于提示信息判断，只替换CONSTS.h中的AppKey即可
    {
        [self showMsg:@"请填写CONSTS.h中的AppKey" afterDelay:1.5];
        return;
    }
    VHHomeViewController *homeVC=[[VHHomeViewController alloc] init];
    homeVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:homeVC animated:YES completion:nil];
}

- (IBAction)closeKeyBtnClick:(id)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - Lifecycle Method

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDatas];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViews];
    
    //测试工具
    [[WHDebugToolManager sharedInstance] toggleWith:DebugToolTypeMemory | DebugToolTypeCPU | DebugToolTypeFPS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerBtnClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册热线：400-682-6882" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
//        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4006826882"];
//        WKWebView * callWebview = [[WKWebView alloc] init];
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        [self.view addSubview:callWebview];
        
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4006826882"];
        // NSLog(@"str======%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    return YES;
}

@end
