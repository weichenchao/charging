//
//  CPBaseNavigationController.m
//  chargingPile
//
//  Created by weichenchao on 16/1/8.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPBaseNavigationController.h"
#import "CPMacro.h"

@interface CPBaseNavigationController ()

@end

@implementation CPBaseNavigationController
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
      
        self.navigationBar.translucent = NO;
        
        self.navigationBar.tintColor = [UIColor whiteColor];
        
        self.navigationBar.barTintColor = RGB(0, 171, 243);
        
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        
    }
    return self;
}
//当push的时候拦截controller，隐藏TabBar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {    
    if (self.viewControllers.count>0) {// 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        [viewController setHidesBottomBarWhenPushed:YES];
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
