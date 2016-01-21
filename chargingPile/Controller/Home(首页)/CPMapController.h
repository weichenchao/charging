//
//  CPMapController.h
//  chargingPile
//
//  Created by wheat on 16/1/18.
//  Copyright © 2016年 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface CPMapController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate>

@end
