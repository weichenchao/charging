//
//  CPtestController.m
//  chargingPile
//
//  Created by weichenchao on 16/1/27.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPtestController.h"

@interface CPtestController ()
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) BMKUserLocation *currentUserLocation;
@end

@implementation CPtestController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.locService = [[BMKLocationService alloc]init];
BMKLocationService *locService = [[BMKLocationService alloc]init];
    self.locService =locService;
    //显示定位的蓝点儿必须先开启定位服务
    [self.locService startUserLocationService];
    self.locService.delegate = self;
    self.title = @"CPtestController.h";
    [self addmapview];
    
}
- (void)addmapview {
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-137-64)];
    self.mapView = mapView;
    self.mapView.showsUserLocation = YES;//显示定位图层
    [self.mapView updateLocationData:self.currentUserLocation];
    /*
     *为什么输出是null？？？？？？？？？？？？
     */
    // NSLog(@"CPGuideController%@",self.userLocation.location);
    [self.view addSubview:self.mapView];
    self.mapView.isSelectedAnnotationViewFront = YES;
    //地图比例尺显示
    self.mapView.showMapScaleBar = YES;
    [self.mapView setZoomLevel:15];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma BMKLocationServiceDelegate,定位的代理方法
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@" CPLocationManager--start locate");
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.currentUserLocation =userLocation;
    CLLocation *cllocation = userLocation.location;
    NSLog(@"%@",userLocation);
    NSLog(@"llll");
  
  
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
    NSLog(@"cllocantionmanager%@",error);
}
@end
