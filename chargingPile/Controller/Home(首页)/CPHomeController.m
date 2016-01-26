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
#import "CPHomeCell.h"
#import "CPNewsModel.h"
#import "CPMacro.h"
#import "CPConst.h"
#import "CPSearchController.h"
#import "CPLocationManager.h"
#import "CPLoginWebController.h"

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

@end

@implementation CPHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setingTableview];
    [self setingTableHeaderView];
    // 监听选择的城市改变
    [CPNotificationCenter addObserver:self selector:@selector(cityDidChange:) name:CPCityDidChangeNotification object:nil];
    // 监听定位的城市改变
    [CPNotificationCenter addObserver:self selector:@selector(cityLocationDidChange:) name:CPCityLocationDidChangeNotification object:nil];
    //开始定位
//    CPLocationManager *locationManager =[CPLocationManager sharedInstance];
//    [locationManager startLocation];
//    CPLog(@"%@",locationManager.cityName);
    
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
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"CPHomeHeaderView" owner:self options:nil][0];
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
    //切换城市
    [self.headerView.locationLabelButton setTitle:self.currentLocationCityName forState:UIControlStateNormal];
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
#pragma mark -button监听方法
- (void)clickInformationButton:(UIButton *)button {
    CPInformationController *infoVC= [[CPInformationController alloc]init];
    
    [self.navigationController pushViewController:infoVC animated:NO];
}
- (void)login {
    CPLoginWebController *loginVC = [[CPLoginWebController alloc]init];
    [self.navigationController pushViewController:loginVC animated:NO];
}
- (void)clickLocationButton {
    CPCityViewController *cityVC = [[CPCityViewController alloc]init];
    [self.navigationController pushViewController:cityVC animated:NO];
}
- (void)clickChargeButton {
    CPMapController *mapVC1 = [[CPMapController alloc]init];
    //CPSearchController *mapVC = [[CPSearchController alloc]init];
    [self.navigationController pushViewController:mapVC1 animated:NO];
}
#pragma mark - notification监听通知
//选择的城市改变
- (void)cityDidChange:(NSNotification *)notification {
    self.selectedCityName = notification.userInfo[CPSelectCityName];
    self.currentLocationCityName = self.selectedCityName;
    [self.headerView.locationLabelButton setTitle:self.selectedCityName forState:UIControlStateNormal];
    //[self.tableview reloadData];
  
}
//定位的城市改变
- (void)cityLocationDidChange:(NSNotification *)notification {
    self.currentLocationCityName = notification.userInfo[CPLocationCityName];
    [self.headerView.locationLabelButton setTitle:self.currentLocationCityName forState:UIControlStateNormal];
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
