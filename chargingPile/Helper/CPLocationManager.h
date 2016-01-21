//
//  CPLocationManagei.h
//  chargingPile
//
//  Created by weichenchao on 16/1/21.
//  Copyright © 2016年 private. All rights reserved.
//  将定位封装了一个独立的manager类来管理定位和地图上滑动到的位置，是将定位功能和地图mapVIew独立开来，管理地理移动位置的变化

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface CPLocationManager : NSObject<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (strong,nonatomic) CPLocationManager *locationManager;
@property (strong,nonatomic) BMKLocationService *locService;


//城市名
@property (strong,nonatomic) NSString *cityName;

//用户纬度
@property (nonatomic,assign) double userLatitude;

//用户经度
@property (nonatomic,assign) double userLongitude;

//用户位置
@property (strong,nonatomic) CLLocation *clloction;


//初始化单例
+ (CPLocationManager *)sharedInstance;

//初始化百度地图用户位置管理类
- (void)initBMKUserLocation;

//开始定位
-(void)startLocation;

//停止定位
-(void)stopLocation;

@end


