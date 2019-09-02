//
//  VHSurveyViewController.m
//  UIModel
//
//  Created by vhall on 2019/7/10.
//  Copyright © 2019年 www.vhall.com. All rights reserved.
//

#import "VHSurveyViewController.h"
#import <WebKit/WebKit.h>
#import <VHLiveSDK/VHallSurvey.h>
#import "SueveyBackGroundView.h"

#define kScriptMessageHandlerWithname @"onWebEvent"

@interface VHSurveyViewController ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) SueveyBackGroundView *contentView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation VHSurveyViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    [self registerWebViewKVO];
    //load
    [self reload];
    //添加webView”关闭“事件代理
    [self webViewAddScriptMessageHandlerWithname:kScriptMessageHandlerWithname];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self unRegisterWebViewKVO];
    //移除webView“关闭”事件代理
    [self webViewRemoveScriptMessageHandlerForName:kScriptMessageHandlerWithname];
    //清除浏览器缓存
    [self deleteWebCache];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initViews];
}

- (void)initViews {
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];

    
    self.contentView = [[SueveyBackGroundView alloc] initWithFrame:CGRectMake(30, 90, CGRectGetWidth(self.view.frame)-60, CGRectGetHeight(self.view.frame)-90-40)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 4;
    [self.view insertSubview:self.contentView atIndex:0];
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(8, 16, CGRectGetWidth(self.contentView.frame)-16, CGRectGetHeight(self.contentView.frame)-16) configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.layer.masksToBounds = YES;
    [self.contentView insertSubview:self.webView atIndex:0];
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"x" forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(CGRectGetWidth(self.contentView.frame)*0.5-20, CGRectGetHeight(self.contentView.frame)-40-16, 40, 40);
    closeButton.layer.cornerRadius = 20;
    closeButton.backgroundColor = [UIColor lightGrayColor];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView insertSubview:closeButton aboveSubview:self.webView];
}



- (void)registerWebViewKVO {
    if(_webView){
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
}
- (void)unRegisterWebViewKVO {
    if(_webView) {
        @try {
            [self.webView removeObserver:self forKeyPath:@"title"];
            [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        }
        @catch (NSException *exception) {

        } @finally {

        }
    }
}

- (void)deleteWebCache {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
    {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            // Done
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

- (void)reload {
    NSLog(@"%@",self.url);
    if ([_url.absoluteString containsString:@"http://"] || [_url.absoluteString containsString:@"https://"]) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
        [self.webView loadRequest:request];
    }
}

- (void)webViewAddScriptMessageHandlerWithname:(NSString *)name {
    if(self.webView.configuration.userContentController == nil )
    {
        self.webView.configuration.userContentController = [[WKUserContentController alloc] init];
    }
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:name];
}
- (void)webViewRemoveScriptMessageHandlerForName:(NSString *)name
{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:name];
}

#pragma mark - observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([object isEqual:self.webView] )
    {
        if([keyPath isEqualToString:@"title"])
        {
            NSLog(@"title : %@",self.webView.title);
        }
        else if([keyPath isEqualToString:@"estimatedProgress"])
        {
            NSLog(@"progress : %f",self.webView.estimatedProgress);
            
            self.contentView.progress = self.webView.estimatedProgress;
        }
    }
}
#pragma mark - WKUIDelegate



#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if (message.body && [message.name isEqualToString:kScriptMessageHandlerWithname])
    {
        NSLog(@"message.body: %@",message.body);
        NSDictionary *msg = [self jsonStringToDictionary:message.body];
        NSString *event = msg[@"event"];
        NSLog(@"ScriptMessage %@",msg);
        //网页关闭按钮事件
        if ([event isEqualToString:@"close"]) {
            if ([self.delegate respondsToSelector:@selector(surveyViewControllerWebViewDidClosed:)]) {
                [self.delegate surveyViewControllerWebViewDidClosed:self];
            }
        }
        //提交按钮事件
        else if ([event isEqualToString:@"submit"]) {
            if ([msg[@"code"] integerValue] == 200)
            {
                if ([self.delegate respondsToSelector:@selector(surveyViewControllerWebViewDidSubmit:msg:)]) {
                    [self.delegate surveyViewControllerWebViewDidSubmit:self msg:msg];
                }
            }
            else
            {
                [self showMsg:[NSString stringWithFormat:@"%@",msg[@"msg"]] afterDelay:2];
            }
        }
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"load finished");
    //向js注入，隐藏web透视图图片，调整视图高度。此处用户可注入js自定义修改问卷样式。
    NSString *script = @"document.querySelector('.header').style.backgroundImage='url()';document.querySelector('.header').style.minHeight='30px';";
    [webView evaluateJavaScript:script completionHandler:^(id object, NSError * _Nullable error) {

        NSLog(@"evaluateJavaScript error : %@",error);
    }];
}


#pragma mark - 关闭
- (void)closeButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(surveyviewControllerDidCloseed:)]) {
        [self.delegate surveyviewControllerDidCloseed:sender];
    }
}




- (id)jsonStringToDictionary:(NSString *)jsonString {
    if (!jsonString) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return obj;
}



@end
