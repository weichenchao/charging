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
#import <BaiduMapAPI_Base/BMKTypes.h>
@interface CPMapController ()
@property (nonatomic,strong) BMKMapView* mapView;
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,strong) BMKPoiSearch *searcher;
@end

@implementation CPMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 480)];
    _locService = [[BMKLocationService alloc]init];
    self.mapView = mapView;
    [self.view addSubview:self.mapView];
    //显示定位的蓝点儿必须先开启定位服务
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态，地图模式
    //显示定位的蓝点儿
    _mapView.showsUserLocation = YES;
    
    //地图显示比例
    [_mapView setZoomLevel:13];
    _mapView.isSelectedAnnotationViewFront = YES;
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    //发起检索
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= @"泉州";
    citySearchOption.keyword = @"餐厅";
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
- (void)viewWillAppear:(BOOL)animated
{
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _searcher.delegate = nil;
}
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}
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
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView updateLocationData:userLocation];
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(24.905206, 118.390356);
   // BMKCoordinateRegion viewRegion = ;
//    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
//    [_mapView setRegion:adjustedRegion animated:YES];
    //大头针
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 24.905206;
    coor.longitude = 118.390356;
    annotation.coordinate = coor;
    annotation.title = @"这里是北京";
    [_mapView addAnnotation:annotation];
    //把获取的地理信息记录下来
    CGFloat localLatitude=self.locService.userLocation.location.coordinate.latitude;
    CGFloat localLongitude=self.locService.userLocation.location.coordinate.longitude;
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:localLatitude longitude:localLongitude];
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    //根据经纬度转换成当前城市，CLGeocoder反编码
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error||placemarks.count==0) {
           // NSLog(@"你输入的地址没找到，可能在月球上");
        }else//编码成功
        {
            //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
            CLPlacemark *placemark=[placemarks firstObject];
            NSString *locality=placemark.locality; // 城市
            CLLocation *location=placemark.location;//位置
            CLRegion *region=placemark.region;//区域
            NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
            //            NSString *name=placemark.name;//地名
            //            NSString *thoroughfare=placemark.thoroughfare;//街道
            //            NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
            //            NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
            //            NSString *administrativeArea=placemark.administrativeArea; // 州
            //            NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
            //            NSString *postalCode=placemark.postalCode; //邮编
            //            NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
            //            NSString *country=placemark.country; //国家
            //            NSString *inlandWater=placemark.inlandWater; //水源、湖泊
            //            NSString *ocean=placemark.ocean; // 海洋
            //            NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
            //位置不更新，此函数频繁被调用的问题
           // NSLog(@"----位置:%@,区域:%@,详细信息:%@，城市%@",location,region,addressDic,locality);
        
        }
    }];
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
