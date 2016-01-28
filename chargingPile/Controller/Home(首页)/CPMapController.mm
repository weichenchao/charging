//
//  CPMapController.m
//  chargingPile
//
//  Created by wheat on 16/1/18.
//  Copyright © 2016年 private. All rights reserved.
//
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "CPMapController.h"
#import "CPGuideController.h"
#import "CPChargingStopModel.h"
#import "CPMacro.h"
@interface CPMapController ()

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
   
}


//添加地图视图
- (void)addmapview {
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mapView = mapView;
    [self.view addSubview:self.mapView];
    self.mapView.isSelectedAnnotationViewFront = YES;
    //地图比例尺显示
    //self.mapView.showMapScaleBar = YES;
}
//添加tableview
- (void)addtableview {
   self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 350, self.view.bounds.size.width,self.view.bounds.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    //添加头部
    UIView *header =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    header.backgroundColor = UIColorFromRGB(0x00abf3);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width, 22)];
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"找到充电桩---共%lu个",(unsigned long)self.chargingStopModelArray.count];
    [header addSubview:label];
    self.tableView.tableHeaderView = header;
    self.recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    self.recognizer.delegate = self;
    [self.tableView addGestureRecognizer:self.recognizer];
    [self.view addSubview:self.tableView];
    
}

//添加城市搜索
- (void)addCitySeacrh {
    //初始化检索对象
    self.searcher =[[BMKPoiSearch alloc]init];
    self.searcher.delegate = self;
    //发起检索
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    //20个的时候不显示软件园的两个充电桩
    citySearchOption.pageCapacity = 50;
    citySearchOption.city= @"厦门";
    citySearchOption.keyword = @"充电";
    BOOL flag = [self.searcher poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
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
            BMKMapPoint point1 = BMKMapPointForCoordinate(self.currentUserLocation.location.coordinate);
            BMKMapPoint point2 = BMKMapPointForCoordinate(poi.pt);
            CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
            
            CPChargingStopModel *model = [[CPChargingStopModel alloc]init];
            model.uid = poi.uid;
            model.name = poi.name;
            model.address = poi.address;
            model.locationCoordinate2D = poi.pt;
            model.distance = [NSNumber numberWithDouble:distance];
            [self.chargingStopModelArray addObject:model];
        }
        [self.mapView addAnnotations:annotations];
        [self.mapView showAnnotations:annotations animated:YES];
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

    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(24.495484, 118.184263);
    self.mapView.zoomLevel = 15;
    //self.mapView.showsUserLocation = YES;//显示定位图层
    [self.mapView updateLocationData:self.currentUserLocation];
    NSLog(@"self.userLocation.location%@",self.currentUserLocation.location);

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
    NSString *str =[NSString stringWithFormat:@"%d米--%@",[num intValue],model.name];
    cell.textLabel.text = str;
    cell.detailTextLabel.text = model.address;
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    CPChargingStopModel *model = self.sortedArray[indexPath.row];
    CPGuideController *guideVC = [[CPGuideController alloc]init];
    guideVC.model = model;
    [self.navigationController pushViewController:guideVC animated:YES];
}
@end
