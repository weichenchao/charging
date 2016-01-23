//
//  CPLoginWebController.m
//  chargingPile
//
//  Created by wheat on 16/1/23.
//  Copyright © 2016年 private. All rights reserved.
//  登录界面

#import "CPLoginWebController.h"

@interface CPLoginWebController ()
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation CPLoginWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.102:8081/Charging/login.spr?method=forwardAccountLogin"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
