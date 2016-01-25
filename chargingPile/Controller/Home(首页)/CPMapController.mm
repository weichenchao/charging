//
//  CPMapController.m
//  chargingPile
//
//  Created by wheat on 16/1/18.
//  Copyright © 2016年 private. All rights reserved.
//
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "CPMapController.h"
#import "CPChargingStopModel.h"
@interface CPMapController ()
@property (nonatomic,strong) BMKMapView* mapView;
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,strong) BMKPoiSearch *searcher;
@property (nonatomic,strong) BMKUserLocation *userLocation;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *chargingStopModelArray;
@property (nonatomic,strong) NSArray *sortedArray;
@property (nonatomic,strong) UIPanGestureRecognizer *recognizer;
@end

@implementation CPMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addmapview];
    self.chargingStopModelArray = [[NSMutableArray alloc]init];
    
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
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mapView = mapView;
    [self.view addSubview:self.mapView];
    _mapView.isSelectedAnnotationViewFront = YES;
    //地图比例尺显示
    _mapView.showMapScaleBar = YES;
}
//添加tableview
- (void)addtableview {
   self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 350, self.view.bounds.size.width,self.view.bounds.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    //添加头部
    UIView *header =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    header.backgroundColor = [UIColor greenColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width, 22)];
    label.text = [NSString stringWithFormat:@"找到充电桩%lu",(unsigned long)self.chargingStopModelArray.count];
    [header addSubview:label];
    self.tableView.tableHeaderView = header;
    //添加向上的手势
//    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(verticalUp)];
//    recognizer.delegate = self;
//    [recognizer setDirection:UISwipeGestureRecognizerDirectionUp];
//    [self.tableView addGestureRecognizer:recognizer];
    self.recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    self.recognizer.delegate = self;
    [self.tableView addGestureRecognizer:self.recognizer];
    [self.view addSubview:self.tableView];
    
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
-(void)verticalUp {
    [self.tableView setFrame:self.view.bounds];
}
//tableview跟着鼠标移动，往上往下运动，x轴不变;地图y轴也跟着变化
-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translatedPoint = [recognizer translationInView:self.view];
    CGFloat x = recognizer.view.center.x;
    CGFloat y = recognizer.view.center.y + translatedPoint.y;
    NSLog(@"pan gesture testPanView moving  is %@,%@", NSStringFromCGPoint(recognizer.view.center), NSStringFromCGRect(recognizer.view.frame));

    if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (y>650) {//tableView滚动到底部，只留下header
                y = 860;
                
            }else if (y<650) {//tableview铺满屏幕
                y = 300;
                
            }
    }
    recognizer.view.center = CGPointMake(x, y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    //tableview铺满屏幕的时候，移除拖动手势
    if (y == 300) {
        [self.tableView removeGestureRecognizer:self.recognizer];
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
            
            //使用以下函数，注意导入百度地图计算工具包
            BMKMapPoint point1 = BMKMapPointForCoordinate(self.userLocation.location.coordinate);
            BMKMapPoint point2 = BMKMapPointForCoordinate(poi.pt);
            CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
            
            CPChargingStopModel *model = [[CPChargingStopModel alloc]init];
            model.uid = poi.uid;
            model.name = poi.name;
            model.address = poi.address;
            model.distance = [NSNumber numberWithDouble:distance];
            [self.chargingStopModelArray addObject:model];
        }
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
        //对数组排序，按距离升序排序
        NSArray *sortedArray  = [self.chargingStopModelArray sortedArrayUsingComparator:^NSComparisonResult(CPChargingStopModel *p1, CPChargingStopModel *p2){
            return [p1.distance compare:p2.distance];
        }];
        self.sortedArray = [NSArray arrayWithArray:sortedArray];
        //先检索了，才能创建tableview
        [self addtableview];
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
#pragma mark implement tableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CPMapViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CPMapViewCell"];
        }
    CPChargingStopModel *model = self.sortedArray[indexPath.row];
    NSNumber *num =model.distance;
    NSString *str =[NSString stringWithFormat:@"%f米--%@",[num doubleValue],model.name];
    cell.textLabel.text = str;
    cell.detailTextLabel.text = model.address;
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CPChargingStopModel *model = self.sortedArray[indexPath.row];
}
@end
