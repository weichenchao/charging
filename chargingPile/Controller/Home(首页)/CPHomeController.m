//
//  CPHomeController.m
//  chargingPile
//
//  Created by weichenchao on 16/1/8.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPHomeController.h"
#import "CPInformationController.h"
#import "CPCityViewController.h"
#import "CPMapController.h"
#import "SDCycleScrollView.h"
#import "CPLoginController.h"
#import "CPHomeCell.h"
#import "CPNewsModel.h"
#import "CPMacro.h"
#import "CPConst.h"

 static NSString *cellReuseIdentifier = @"CPHomeCell";

@interface CPHomeController ()
@property (nonatomic,strong) UITableView *tableview;
/**
 * 头部信息
 */
@property (nonatomic,strong) CPHomeHeaderView *headerView;
/**
 * 新闻数组
 */
@property (nonatomic,strong) NSMutableArray *newsArray;
/** 
 *当前选中的城市
 */
@property (nonatomic, copy) NSString *selectedCityName;
/**
 *当前定位的城市
 */
@property (nonatomic, copy) NSString *currentLocationCityName;
/**
 * 定位服务
 */
@property (nonatomic,strong) BMKLocationService *locService;
@end

@implementation CPHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setingTableview];
    [self setingTableHeaderView];
    // 监听城市改变
    [CPNotificationCenter addObserver:self selector:@selector(cityDidChange:) name:CPCityDidChangeNotification object:nil];
    //开始定位
    //初始化BMKLocationService
    self.locService = [[BMKLocationService alloc]init];
    self.locService.delegate = self;
    //启动LocationService
    [self.locService startUserLocationService];
    NSLog(@"didUpdateUserLocation lat %f,long %f",self.locService.userLocation.location.coordinate.latitude,self.locService.userLocation.location.coordinate.longitude);
    
   
}

#pragma mark- 实现定位delegate，处理位置信息更新
/**
 *  处理方向变更信息
 *  @param data userLocation
 *
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}
/**
 *  处理位置坐标更新
 *   @param data  userLocation
 *
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {

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
           
            if (![self.currentLocationCityName isEqualToString:locality]) {
                 self.currentLocationCityName = locality;
                 //NSLog(@"----位置:%@,区域:%@,详细信息:%@，城市%@",location,region,addressDic,locality);
                //直接把城市切换成定位的城市
                 [self.headerView.locationLabelButton setTitle:self.currentLocationCityName forState:UIControlStateNormal];
            }
        }
    }];
}

//隐藏特定UIViewController的导航栏,在该视图控制器中加入代码
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
#pragma mark -设置tableView
- (void)setingTableview {
    //取消_tableView滚动条
    self.tableview.showsVerticalScrollIndicator = NO;
    //设置数据源，代理
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
    self.tableview.frame = self.view.bounds;
   
    
    UINib *nib = [UINib nibWithNibName:@"CPHomeCell" bundle:[NSBundle mainBundle]];
    [self.tableview registerNib:nib forCellReuseIdentifier:cellReuseIdentifier];
    [self.view addSubview:self.tableview];
}
- (void)setingTableHeaderView {
    self.headerView = [[CPHomeHeaderView alloc]init];
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"CPHomeHeaderView" owner:nil options:nil][0];
    self.headerView.frame=CGRectMake(0,0,SCREEN_WIDTH,519);
    //设置代理
    self.headerView.myDelegate = self;
    //判断是否登录
    self.headerView.labelView.hidden = YES;
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(94, 44+45-12, 60, 24);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTintColor:[UIColor whiteColor]];
    [loginButton setImage:[UIImage imageNamed:@"home_right_arrow"] forState:UIControlStateNormal];
    //实现button文字居左，图片居右
    CGFloat labelWidth = 30;
    CGFloat imageWith = 24;
    loginButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
    loginButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, 0, imageWith);
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:loginButton];
    //设置scrollView
    [self setingScrollView];
    [self.headerView.infomationButton addTarget:self action:@selector(clickInformationButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.locationIconButton addTarget:self action:@selector(clickLocationButton) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.locationLabelButton addTarget:self action:@selector(clickLocationButton) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.chargeButton addTarget:self action:@selector(clickChargeButton) forControlEvents:UIControlEventTouchUpInside];
    self.tableview.tableHeaderView=self.headerView;
}
- (void)setingScrollView {
    // 情景一：采用本地图片实现
    NSArray *imageNames = @[@"h1.jpg",
                            @"h2.jpg",
                            @"h3.jpg",
                            @"h4.jpg",
                            ];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.headerView.scrollView.bounds imageNamesGroup:imageNames];
    [self.headerView.scrollView addSubview:cycleScrollView];
}
#pragma mark -懒加载
- (UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]init];
    }
    return _tableview;
}
- (NSMutableArray *)newsArray{
    if (_newsArray == nil) {
        _newsArray = [[NSMutableArray alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"newsList" ofType:@"plist"];
        NSArray *array = [NSMutableArray arrayWithContentsOfFile:path];
        for (NSDictionary *dict in array) {
            CPNewsModel *model =[[CPNewsModel alloc]initWithDict:dict];
            [_newsArray addObject:model];
        }
    }
    return _newsArray;
}
//- (NSString *)currentLocationCityName {
//   
//    if(self.currentLocationCityName == nil) {
//        self.currentLocationCityName = [NSString stringWithFormat:@"北京"];
//    }
//    return self.currentLocationCityName;
//}
#pragma mark -button监听方法
- (void)clickInformationButton:(UIButton *)button {
    CPInformationController *infoVC= [[CPInformationController alloc]init];
    
    [self.navigationController pushViewController:infoVC animated:NO];
}
- (void)login {
    CPLoginController *loginVC = [[CPLoginController alloc]init];
    [self.navigationController pushViewController:loginVC animated:NO];
}
- (void)clickLocationButton {
    CPCityViewController *cityVC = [[CPCityViewController alloc]init];
    [self.navigationController pushViewController:cityVC animated:NO];
}
- (void)clickChargeButton {
    CPMapController *mapVC = [[CPMapController alloc]init];
    [self.navigationController pushViewController:mapVC animated:NO];
}
#pragma mark - notification监听通知
- (void)cityDidChange:(NSNotification *)notification {
    self.selectedCityName = notification.userInfo[CPSelectCityName];
    [self.headerView.locationLabelButton setTitle:self.selectedCityName forState:UIControlStateNormal];
    //[self.tableview reloadData];
    
}
#pragma mark -tableview数据源方法
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {   
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CPHomeCell *cell=[self.tableview dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    [cell setDataWithNewsModel:self.newsArray[indexPath.row]];
    
    return  cell;
}
#pragma mark -tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


}
#pragma mark-headerView代理方法

-(void)clickOneSortButton:(UIButton *)button{
    NSLog(@"%@",button);
}
@end
