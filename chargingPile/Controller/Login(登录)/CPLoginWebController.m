//
//  CPLoginWebController.m
//  chargingPile
//
//  Created by wheat on 16/1/23.
//  Copyright © 2016年 private. All rights reserved.
//  登录界面

#import "CPLoginWebController.h"
static NSString *kConfirmAlertNotificationName = @"kConfirmAlertNotificationName";
@interface CPLoginWebController ()
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation CPLoginWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTheWebView];
   
}
-(void)addTheWebView {
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.102:8081/Charging/login.spr?method=forwardAccountLogin"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    // 首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）  和JSContext *context =[[JSContext alloc]init]有什么区别
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    CPWheat *wheat = [CPWheat sharedInstance];
    wheat.login = ^() {
        [self.navigationController popViewControllerAnimated:NO];
    };
    context[@"Wheat.login"] = wheat.login;
    
}
- (void)login:(UIViewController *)controller {
    
}
//无法传参的时候可以用block，避免使用通知；可以传参的时候，用JSExport协议
//-(void)addObservers {
//    
//    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    
//    
//    [notificationCenter addObserver:self selector:@selector(didLogin) name:kConfirmAlertNotificationName object:nil];
//    
//}
//-(void)didLogin {
//    [self.navigationController popViewControllerAnimated:YES];
//}
@end
