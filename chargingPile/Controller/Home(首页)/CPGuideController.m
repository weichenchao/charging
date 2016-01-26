//
//  CPGuideController.m
//  chargingPile
//
//  Created by weichenchao on 16/1/25.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPGuideController.h"
#import "CPGuideFooterView.h"
#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"
@interface CPGuideController ()<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>

@end

@implementation CPGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addmapview];
    [self addFooter];
    [self addRoutePlan];
}


//添加地图视图
- (void)addmapview {
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-137-64)];
    self.mapView = mapView;
    self.mapView.showsUserLocation = YES;//显示定位图层
    [self.mapView updateLocationData:self.userLocation];
    /*
     *为什么输出是null？？？？？？？？？？？？
     */
    NSLog(@"CPGuideController%@",self.userLocation.location);
    [self.view addSubview:self.mapView];
    self.mapView.isSelectedAnnotationViewFront = YES;
    //地图比例尺显示
    self.mapView.showMapScaleBar = YES;
    [self.mapView setZoomLevel:15];
    //显示选中的大头针,大头针会在地图中间
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    item.coordinate = self.model.locationCoordinate2D;
    item.title = self.model.name;
    [self.mapView addAnnotations:@[item]];
    [self.mapView showAnnotations:@[item] animated:YES];
   
}
- (void)addFooter {
    CGFloat viewHeight = self.view.bounds.size.height;
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat footerHeight = 137;
    CPGuideFooterView *footer = [[CPGuideFooterView alloc]init];
   footer = [[NSBundle mainBundle] loadNibNamed:@"CPGuideFooterView" owner:self options:nil][0];
    footer.frame = CGRectMake(0,viewHeight-footerHeight-64,viewWidth,footerHeight);
    
    footer.nameLabel.text= self.model.name;
    footer.distanceLabel.text= [NSString stringWithFormat:@"%@",self.model.distance];
    footer.addresslabel.text= self.model.address;
    [self.view addSubview:footer];

}
//添加路径规划
- (void)addRoutePlan {
    NSMutableArray *nodesArray = [[NSMutableArray alloc] initWithCapacity: 2];
    
    //起点
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = self.userLocation.location.coordinate.longitude;
    startNode.pos.y = self.userLocation.location.coordinate.latitude;
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:startNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x =  self.model.locationCoordinate2D.longitude;
    endNode.pos.y =  self.model.locationCoordinate2D.latitude;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    // 发起算路
    [BNCoreServices_RoutePlan  startNaviRoutePlan: BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self    userInfo:nil];
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
#pragma mark -算路回调
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI: BN_NaviTypeReal delegete:self isNeedLandscape:YES];
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"算路失败");
    if ([error code] == BNRoutePlanError_LocationFailed) {
        NSLog(@"获取地理位置失败");
    }
    else if ([error code] == BNRoutePlanError_RoutePlanFailed)
    {
        NSLog(@"定位服务未开启");
    }
}

//算路取消
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}
@end
