//
//  CPMapController.m
//  chargingPile
//
//  Created by wheat on 16/1/18.
//  Copyright © 2016年 private. All rights reserved.
//
#import <CoreGraphics/CoreGraphics.h>
#import<CoreLocation/CoreLocation.h>
#import "CPMapController.h"
#import <UIKit/UIKit.h>
@interface CPMapController ()
@property (nonatomic,strong) BMKMapView* mapView;
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,strong) BMKPoiSearch *searcher;
@property (nonatomic,strong) BMKUserLocation *userLocation;
@end

@implementation CPMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addmapview];
    [self addCitySeacrh];
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
//添加地图视图
- (void)addmapview {
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 480)];
    self.mapView = mapView;
    [self.view addSubview:self.mapView];
    _mapView.isSelectedAnnotationViewFront = YES;
    //地图比例尺显示
    _mapView.showMapScaleBar = YES;
}
//添加定位服务
- (void)addLocationSevice {
    _locService = [[BMKLocationService alloc]init];
    //显示定位的蓝点儿必须先开启定位服务
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态，地图模式
    //显示定位的蓝点儿
    _mapView.showsUserLocation = YES;
}
//添加城市搜索
- (void)addCitySeacrh {
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    //发起检索
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    //20个的时候不显示软件园的两个充电桩
    citySearchOption.pageCapacity = 50;
    citySearchOption.city= @"厦门";
    citySearchOption.keyword = @"充电";
    BOOL flag = [_searcher poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
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
    [_mapView updateLocationViewWithParam:param];
}
#pragma mark implement BMKMapViewDelegate
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark-实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    //[_mapView setZoomLevel:10];
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < poiResultList.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [poiResultList.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [annotations addObject:item];
        }
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
        
       
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(24.495484, 118.184263);
    _mapView.zoomLevel = 15;
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView updateLocationData:self.userLocation];

}
#pragma mark -定位服务代理
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
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
    _mapView.showsUserLocation = YES;//显示定位图层
    self.userLocation = userLocation;
    //动态更新我的位置数，必须有这句话，可以让定位小蓝点出来,但是也有这句话导致地图不能移动
    //[_mapView updateLocationData:userLocation];
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
    if (_mapView) {
        _mapView = nil;
        
    }
}


@end
