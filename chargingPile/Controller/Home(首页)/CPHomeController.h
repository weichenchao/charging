//
//  CPHomeController.h
//  chargingPile
//
//  Created by weichenchao on 16/1/8.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPBaseViewController.h"
#import "CPHomeHeaderView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
@interface CPHomeController : CPBaseViewController<UITableViewDataSource,UITableViewDelegate,CPHomeHeaderViewDelegate,BMKLocationServiceDelegate>

@end
