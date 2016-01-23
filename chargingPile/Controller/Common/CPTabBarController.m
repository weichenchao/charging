//
//  CPTabBarController.m
//  chargingPile
//
//  Created by weichenchao on 16/1/11.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPTabBarController.h"
#import "CPBaseNavigationController.h"
#import "CPHomeController.h"
#import "CPTopicController.h"
#import "CPMacro.h"

@interface CPTabBarController ()

@end

@implementation CPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CPHomeController *homeVC =[[CPHomeController alloc]init];
    //设置tabbarItem的图片
    homeVC.tabBarItem.image=[UIImage imageNamed:@"home_normal"];
    //取消图片渲染
   // homeVC.tabBarItem.selectedImage=[[UIImage  imageNamed:@"home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置文字颜色
    homeVC.tabBarItem.title=@"首页";
    NSMutableDictionary *textNormal=[NSMutableDictionary dictionary];
    textNormal[NSForegroundColorAttributeName]=UIColorFromRGB(0x888888);
    [homeVC.tabBarItem setTitleTextAttributes:textNormal forState:UIControlStateNormal];
    
    //设置选中状态文字颜色
    NSMutableDictionary *textSelected=[NSMutableDictionary dictionary];
    textSelected[NSForegroundColorAttributeName]=UIColorFromRGB(0x00abf3);
    [homeVC.tabBarItem setTitleTextAttributes:textSelected forState:UIControlStateSelected];
    CPBaseNavigationController *homeNaviVC = [[CPBaseNavigationController alloc]initWithRootViewController:homeVC];
    
    
    CPTopicController *topicVC =[[CPTopicController alloc]init];
    //设置tabbarItem的图片
    topicVC.tabBarItem.image=[UIImage imageNamed:@"tab_topic"];
    //取消图片渲染
     topicVC.tabBarItem.selectedImage=[[UIImage  imageNamed:@"tab_topic_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置文字颜色
    topicVC.tabBarItem.title=@"话题";
    NSMutableDictionary *textNormal1=[NSMutableDictionary dictionary];
    textNormal1[NSForegroundColorAttributeName]=UIColorFromRGB(0x888888);
    [homeVC.tabBarItem setTitleTextAttributes:textNormal1 forState:UIControlStateNormal];
    
    //设置选中状态文字颜色
    NSMutableDictionary *textSelected1=[NSMutableDictionary dictionary];
    textSelected1[NSForegroundColorAttributeName]=UIColorFromRGB(0x00abf3);
    [homeVC.tabBarItem setTitleTextAttributes:textSelected1 forState:UIControlStateSelected];
    CPBaseNavigationController *topivNaviVC = [[CPBaseNavigationController alloc]initWithRootViewController:topicVC];
    
    NSArray *controllers = [NSArray arrayWithObjects:homeNaviVC,topivNaviVC,nil];
    self.viewControllers = controllers;
    
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
