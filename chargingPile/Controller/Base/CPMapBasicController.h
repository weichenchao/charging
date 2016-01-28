//
//  CPMapBasicController.h
//  chargingPile
//
//  Created by weichenchao on 16/1/25.
//  Copyright © 2016年 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPLocationManager.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface CPMapBasicController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate>
@property (nonatomic,strong) BMKMapView* mapView;
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,strong) BMKPoiSearch *searcher;
@property (nonatomic,strong) BMKUserLocation *currentUserLocation;
@end
