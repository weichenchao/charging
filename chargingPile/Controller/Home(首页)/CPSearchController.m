//
//  CPSearchController.m
//  chargingPile
//
//  Created by weichenchao on 16/1/21.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPSearchController.h"
#import "CPChargingStopModel.h"
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
    [self addmapview];
    [self addtableview];
    
}


-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    //[self addSearch];
    [self addNearbySearch];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _poisearch.delegate = nil; // 不用时，置nil
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
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
    _mapView.isSelectedAnnotationViewFront = YES;
    [self.view addSubview:self.mapView];
}
//添加城市检索功能
- (void)addSearch {
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= @"厦门";
    citySearchOption.keyword = @"充电站";
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
//添加周边检索
- (void)addNearbySearch {
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
   //厦门思明区软件园二期望海路2号4399游家网络大厦1楼   118.184263,24.495484
    option.location =CLLocationCoordinate2DMake(24.495484, 118.184263);
    //周边搜索半径
    option.radius = 100000;
    option.keyword = @"充电桩";
    BOOL flag = [_poisearch poiSearchNearBy:option];

    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }

}
////实现PoiSearchDeleage处理回调结果，详情回调
//- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
//{
//    // 清除屏幕中所有的annotation
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
//    
//    if (error == BMK_SEARCH_NO_ERROR) {
//        NSMutableArray *annotations = [NSMutableArray array];
//        for (int i = 0; i < poiResultList.poiInfoList.count; i++) {
//            BMKPoiInfo* poi = [poiResultList.poiInfoList objectAtIndex:i];
//            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
//            item.coordinate = poi.pt;
//            item.title = poi.name;
//            [annotations addObject:item];
//        }
//        //显示大头针
//        [_mapView addAnnotations:annotations];
//        [_mapView showAnnotations:annotations animated:YES];
//    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
//        NSLog(@"起始点有歧义,检索地址有岐义");
//    } else {
//        // 各种情况的判断。。。
//        switch (error) {
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
    self.tableView.frame = CGRectMake(0, 400, self.view.bounds.size.width, 200);
    [self.view addSubview:self.tableView];
}
#pragma mark -tableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
    NSLog(@"onDoubleClick-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
    
}


#pragma mark implement BMKSearchDelegate
//城市检索回调
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
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
            [_chargingStopModelArray addObject:model];
            
        }
       // [self.tableView reloadData];
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}


@end
