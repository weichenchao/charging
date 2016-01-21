//
//  CPLocationManagei.m
//  chargingPile
//
//  Created by weichenchao on 16/1/21.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPLocationManager.h"

@implementation CPLocationManager
 static CPLocationManager *locationManager = nil;
+ (CPLocationManager *)sharedInstance {
    if (!locationManager) {
        locationManager = [[self alloc] init];
    }
    return locationManager;
}
-(id)init
{
    self = [super init];
    if (self)
    {
        [self initBMKUserLocation];
    }
    return self;
}

#pragma 初始化百度地图用户位置管理类
/**
 *  初始化百度地图用户位置管理类
 */
- (void)initBMKUserLocation
{
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [self startLocation];
    
}
#pragma 打开定位服务
/**
 *  打开定位服务
 */
-(void)startLocation
{
    [_locService startUserLocationService];
}
#pragma 关闭定位服务

/**
 *  关闭定位服务
 */
-(void)stopLocation
{
    [_locService stopUserLocationService];
}
#pragma BMKLocationServiceDelegate,定位的代理方法
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
     CLLocation *cllocation = userLocation.location;
   
    _userLatitude = cllocation.coordinate.latitude;
    _userLongitude = cllocation.coordinate.longitude;
    //[self stopLocation];//(如果需要实时定位不用停止定位服务)
    
    //把获取的地理信息记录下来
    CGFloat localLatitude=userLocation.location.coordinate.latitude;
    CGFloat localLongitude=userLocation.location.coordinate.longitude;
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
            NSString *locality=placemark.locality;     // 城市
            
//            CLLocation *location=placemark.location;//位置
//            CLRegion *region=placemark.region;//区域
//            NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
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
            
//            if (![self.cityName isEqualToString:locality]) {
//                   // 发出通知
//                [CPNotificationCenter postNotificationName:CPCityDidChangeNotification object:nil userInfo:@{CPLocationCityName : locality]}];
//            }
            if (![self.cityName isEqualToString:locality]) {
                [CPNotificationCenter postNotificationName:CPCityLocationDidChangeNotification object:nil userInfo:@{CPLocationCityName : locality}];
            }
        
                self.cityName = locality;
                self.clloction = cllocation;
           // NSLog(@"%@",locality);
           
        }
    }];

}
/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    
}
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [self stopLocation];
}
@end
