//
//  CPSearchController.m
//  chargingPile
//
//  Created by weichenchao on 16/1/21.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPSearchController.h"
#import "CPChargingStopModel.h"
#import "CPLocationManager.h"
@interface CPSearchController ()
@property (nonatomic,strong) BMKMapView* mapView;
@property (nonatomic,strong) BMKPoiSearch *poisearch;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *chargingStopModelArray;
@end

@implementation CPSearchController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.poisearch = [[BMKPoiSearch alloc]init];
    _poisearch.delegate = self;
   
    [self addmapview];
    //[self addtableview];
    CPLocationManager * locationManeger =[CPLocationManager sharedInstance];
    [locationManeger startLocation];
    [self addCitySearch];
    self.mapView.showsUserLocation = YES;
    [self setUserImage];
    
}


-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _poisearch.delegate = nil; // 不用时，置nil
}

-(NSMutableArray *)chargingStopModelArray {
    if (_chargingStopModelArray == nil) {
        _chargingStopModelArray =[[NSMutableArray alloc]init];
    }
    return _chargingStopModelArray;
}
- (void)dealloc {
    if (_poisearch != nil) {
        _poisearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}
//添加地图视图
- (void)addmapview {
    self.mapView =[[BMKMapView alloc]initWithFrame:self.view.bounds];
    // 设置地图级别，1是显示最多的区域，显示整个地球，19是显示最少区域的
    [_mapView setZoomLevel:9];
    //设定是否总让选中的annotaion置于最前面
    _mapView.isSelectedAnnotationViewFront = YES;

    [self.view addSubview:self.mapView];
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
//添加城市检索功能
- (void)addCitySearch {
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    //分页数量,每页地图显示的城市数
    citySearchOption.pageCapacity = 20;
    citySearchOption.city= @"厦门";
    citySearchOption.keyword = @"充电";
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
   // [_mapView setZoomLevel:1];
}
////添加周边检索
//- (void)addNearbySearch {
//    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
//    option.pageIndex = 0;
//    option.pageCapacity = 10;
//   //厦门思明区软件园二期望海路2号4399游家网络大厦1楼   118.184263,24.495484
//    option.location =CLLocationCoordinate2DMake(24.495484, 118.184263);
//    //周边搜索半径
//    option.radius = 100000;
//    option.keyword = @"充电桩";
//    BOOL flag = [_poisearch poiSearchNearBy:option];
//
//    if(flag)
//    {
//        NSLog(@"周边检索发送成功");
//    }
//    else
//    {
//        NSLog(@"周边检索发送失败");
//    }

//}
//实现PoiSearchDeleage处理回调结果，详情回调
//- (void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
//{
//    // 清除屏幕中所有的annotation
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
//    
//    if (errorCode == BMK_SEARCH_NO_ERROR) {
//        NSMutableArray *annotations = [NSMutableArray array];
//       
//        
//            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
//            item.coordinate = poiDetailResult.pt;
//            item.title = poiDetailResult.name;
//            [annotations addObject:item];
//
//
//        //显示大头针
//        [_mapView addAnnotations:annotations];
//        [_mapView showAnnotations:annotations animated:YES];
//    } else if (errorCode == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
//        NSLog(@"起始点有歧义,检索地址有岐义");
//    } else {
//        // 各种情况的判断。。。
//        switch (errorCode) {
//            case BMK_SEARCH_AMBIGUOUS_KEYWORD:
//                NSLog(@"检索词有岐义");
//                break;
//            case BMK_SEARCH_RESULT_NOT_FOUND:
//                NSLog(@"没有找到检索结果");
//                break;
//            default:
//                break;
//        }
//       
//    }
//}
//添加tableview
- (void)addtableview {
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, 400, self.view.bounds.size.width, 100);
    [self.view addSubview:self.tableView];
}
//将视图视角切换到某一个坐标点,设置当前地图的经纬度范围，设定的该范围可能会被调整为适合地图窗口显示的范围。region是BMKMapView的一个属性，类型BMKCoordinateRegion ，这行的意思是创建一个以coordinate为中心，上下左右个0.5个经（纬）度。但是这时我们需要注意一个问题就是，创建的区域是一个正方形，并不符合我们所需要的BMKMapView比例；之后用方法regionThatFits调整显示范围。
-(void)region {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 24.495484;
    coordinate.longitude = 118.184263;
    BMKCoordinateSpan span ;
    span.latitudeDelta =0.05;
    span.longitudeDelta =0.05 ;
    BMKCoordinateRegion viewRegion;
    viewRegion.center = coordinate;
    viewRegion.span = span;
    
    //BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    
    [_mapView setRegion:viewRegion animated:YES];
}
#pragma mark -tableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =[self.tableView dequeueReusableCellWithIdentifier:@"cellll"];
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellll"];
    }
    CPChargingStopModel *model = [[CPChargingStopModel alloc]init];
    model = _chargingStopModelArray[indexPath.row];
    cell.textLabel.text =model.name;
    return  cell;
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
/**
 *双击地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 输出双击处坐标点的经纬度
 */
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"-------onDoubleClick-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    [_mapView setZoomEnabledWithTap:NO];
    
}


#pragma mark implement BMKSearchDelegate
//城市检索回调
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    _mapView.centerCoordinate =CLLocationCoordinate2DMake(24.495484, 118.184263);
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < result.poiInfoList.count; i++) {
         
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [annotations addObject:item];
            
            CPChargingStopModel *model = [[CPChargingStopModel alloc]init];
            model.name = poi.name;
            [self.chargingStopModelArray addObject:model];
            
        }
        [self.tableView reloadData];
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
       //在这边对mapView的范围和位置进行处理，会有效
       //_mapView.centerCoordinate =CLLocationCoordinate2DMake(24.495484, 118.184263);
       
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}


@end
