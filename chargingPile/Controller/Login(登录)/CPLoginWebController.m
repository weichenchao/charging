//
//  CPLoginWebController.m
//  chargingPile
//
//  Created by wheat on 16/1/23.
//  Copyright © 2016年 private. All rights reserved.
//  登录界面

#import "CPLoginWebController.h"
#import "CPGlobaLInfo.h"
#import "CPUserModel.h"
static NSString *kConfirmAlertNotificationName = @"kConfirmAlertNotificationName";
@interface CPLoginWebController ()
@property (nonatomic,strong) UIWebView *webView;

@end

@implementation CPLoginWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTheWebView];
    //[self addObservers];
   
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
     context[@"wheatLogin"] =  ^() {
          dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
        
          });
         //获取网页返回的参数,数组只有一个元素，即整个json是一个整体
         NSArray *args = [JSContext currentArguments];
         for (JSValue * obj in args) {
             NSLog(@"%@",obj);
            // NSString *dict = [obj toString];
             NSString *string =[obj toString];
             NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
              NSLog(@"111%@",dict);
             CPGlobaLInfo *global = [CPGlobaLInfo sharedGlobal];
             CPUserModel *model = [[CPUserModel alloc]init];
             model.nickName = dict[@"NICK_NAME"];
             model.phoneNumber = dict[@"PHONE_NO"];
             model.userScore = dict[@"USER_SCORE"];
             model.usetLevel = dict[@"USER_LEVEL"];
             model.chargingScore = dict[@"CHARGING"];
             global.userModel = model;
             JSValue *this = [JSContext currentThis];
             NSLog(@"this: %@",this);
             NSLog(@"-------End Log-------");
         }
    };
//    {
//        CHARGING = 32;
//        "NICK_NAME" = wheat;
//        "PHONE_NO" = 18959291480;
//        "USER_LEVEL" = 11;
//        "USER_SCORE" = 765;
//    }

//
//    context[@"Wheat"] =wheat ;
//    context[@"test1"] = ^() {
//        NSArray *args = [JSContext currentArguments];
//        for (id obj in args) {
//            NSLog(@"%@",obj);
//        }
//    };
}
//- (void)login:(UIViewController *)controller {
//    
//}
////无法传参的时候可以用block，避免使用通知；可以传参的时候，用JSExport协议
//-(void)addObservers {
//    
//    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    
//    
//    [notificationCenter addObserver:self selector:@selector(didLogin) name:kConfirmAlertNotificationName object:nil];
//    
//}
//-(void)didLogin {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationController popViewControllerAnimated:YES];
//    });
//   
//}
@end
