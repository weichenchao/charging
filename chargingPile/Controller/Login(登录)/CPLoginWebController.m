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
    [self addObservers];
   
}
-(void)addTheWebView {
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.102:8081/Charging/login.do?method=forwardLogin"];
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
     context[@"wheatLogin"] =  ^() {
//          dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationController popViewControllerAnimated:NO];
//          });
         [self.navigationController popViewControllerAnimated:NO];
         NSArray *args = [JSContext currentArguments];
         for (id obj in args) {
             NSLog(@"%@",obj);
         }
    };

    context[@"Wheat"] =wheat ;
    context[@"test1"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"%@",obj);
        }
    };
    //此处我们没有写后台（但是前面我们已经知道iOS是可以调用js的，我们模拟一下）
    //首先准备一下js代码，来调用js的函数test1 然后执行
    //一个参数
//    NSString *jsFunctStr=@"test1('参数1')";
//    [context evaluateScript:jsFunctStr];
    
}
- (void)login:(UIViewController *)controller {
    
}
//无法传参的时候可以用block，避免使用通知；可以传参的时候，用JSExport协议
-(void)addObservers {
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    
    [notificationCenter addObserver:self selector:@selector(didLogin) name:kConfirmAlertNotificationName object:nil];
    
}
-(void)didLogin {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
   
}
@end
