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
    
    NSArray *controllers=[NSArray arrayWithObjects:homeNaviVC,nil];
    self.viewControllers=controllers;
    
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
