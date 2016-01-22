//
//  CPSearchController.h
//  chargingPile
//
//  Created by weichenchao on 16/1/21.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPBaseViewController.h"
#import <UIKit/UIKit.h>
#import "CPLocationManager.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface CPSearchController : CPBaseViewController<BMKMapViewDelegate, BMKPoiSearchDelegate,UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate>

@end
