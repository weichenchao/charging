//
//  MTCityViewController.m
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "CPCityViewController.h"
#import "CPCityGroup.h"
#import "MJExtension.h"
#import "CPMacro.h"
#import "CPConst.h"
#import "CPCitySearchResultViewController.h"

const int MTCoverTag = 999;

@interface CPCityViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *showLocationButton;
@property (nonatomic, strong) NSArray *cityGroups;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cover;
- (IBAction)coverClick;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) CPCitySearchResultViewController *citySearchResult;
@end

@implementation CPCityViewController
//懒加载
- (CPCitySearchResultViewController *)citySearchResult
{
    
    if (_citySearchResult == nil) {
        CPCitySearchResultViewController *citySearchResult = [[CPCitySearchResultViewController alloc] init];
      
        [self addChildViewController:citySearchResult];
        _citySearchResult = citySearchResult;
        
        [self.view addSubview:self.citySearchResult.view];
//        [_citySearchResult.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
//        [_citySearchResult.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:15];
    }
    return _citySearchResult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 基本设置
    self.title = @"切换城市";

    self.tableView.sectionIndexColor = [UIColor blackColor];
    
    // 加载城市数据
    self.cityGroups = [CPCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    // 监听定位的城市改变
    [CPNotificationCenter addObserver:self selector:@selector(cityLocationDidChange:) name:CPCityLocationDidChangeNotification object:nil];
   
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//定位的城市改变
- (void)cityLocationDidChange:(NSNotification *)notification {
    
    [self.showLocationButton setTitle:notification.userInfo[CPLocationCityName]forState:UIControlStateNormal];
    NSLog(@"-----%@",notification.userInfo[CPLocationCityName]);
}
#pragma mark - 搜索框代理方法
/**
 *  键盘弹出:搜索框开始编辑文字
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 1.隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 2.修改搜索框的背景图片
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"]];
    
    // 3.显示搜索框右边的取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    
    // 4.显示遮盖
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha = 0.5;
    }];
}

/**
 *  键盘退下:搜索框结束编辑文字
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 1.显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 2.修改搜索框的背景图片
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"]];
    
    // 3.隐藏搜索框右边的取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    
    // 4.隐藏遮盖
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha = 0.0;
    }];
    
    // 5.移除搜索结果
    self.citySearchResult.view.hidden = YES;
    searchBar.text = nil;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

/**
 *  搜索框里面的文字变化的时候调用
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        self.citySearchResult.view.hidden = NO;
        self.citySearchResult.searchText = searchText;
    } else {
        self.citySearchResult.view.hidden = YES;
    }
}

/**
 *  点击遮盖
 */
- (IBAction)coverClick {
    [self.searchBar resignFirstResponder];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CPCityGroup *group = self.cityGroups[section];
    return group.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    CPCityGroup *group = self.cityGroups[indexPath.section];
    cell.textLabel.text = group.cities[indexPath.row];
    
    return cell;
}

#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CPCityGroup *group = self.cityGroups[section];
    return group.title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.cityGroups valueForKeyPath:@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPCityGroup *group = self.cityGroups[indexPath.section];
    // 发出通知
    [CPNotificationCenter postNotificationName:CPCityDidChangeNotification object:nil userInfo:@{CPSelectCityName : group.cities[indexPath.row]}];
    //移除当前controller
    [self.navigationController popToRootViewControllerAnimated:NO];
}
@end
