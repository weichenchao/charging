//
//  CPMapBasicController.m
//  chargingPile
//
//  Created by weichenchao on 16/1/25.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPMapBasicController.h"

@interface CPMapBasicController ()

@end

@implementation CPMapBasicController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self addLocationSevice];
}
- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    
    _mapView.delegate = self;
    _locService.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _searcher.delegate = nil;
}
//添加定位服务
- (void)addLocationSevice {
    self.locService = [[BMKLocationService alloc]init];
    //显示定位的蓝点儿必须先开启定位服务
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态，地图模式
    //显示定位的蓝点儿
    self.mapView.showsUserLocation = YES;
}

#pragma mark -设置定位圆点属性
-(void)setUserImage
{
    //用户位置类
    BMKLocationViewDisplayParam* param = [[BMKLocationViewDisplayParam alloc] init];
    param.locationViewOffsetY = 0;//偏移量
    param.locationViewOffsetX = 0;
    param.isAccuracyCircleShow =NO;//设置是否显示定位的那个精度圈
    param.isRotateAngleValid = NO;
    [self.mapView updateLocationViewWithParam:param];
}
#pragma mark -定位服务代理
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"---CPMapBasicController -start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{    //动态更新我的位置数，这句话可以让定位小蓝点出来
    //[_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.mapView.showsUserLocation = YES;//显示定位图层
    self.userLocation = userLocation;
    //NSLog(@"location%@",userLocation.location);
    //动态更新我的位置数，必须有这句话，可以让定位小蓝点出来,但是也有这句话导致地图不能移动
    [_mapView updateLocationData:userLocation];
}
/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    NSLog(@"%@",error);
}


- (void)dealloc {
    if (self.mapView) {
        self.mapView = nil;
        
    }
}
@end
