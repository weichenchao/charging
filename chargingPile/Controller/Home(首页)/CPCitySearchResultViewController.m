//
//  MTCitySearchResultViewController.m
//  美团HD
//
//  Created by apple on 14/11/24.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "CPCitySearchResultViewController.h"
#import "MJExtension.h"
#import "CPCity.h"
#import "CPMacro.h"
#import "CPConst.h"

@interface CPCitySearchResultViewController ()
@property (nonatomic, strong) NSArray *resultCities;
@property (nonatomic,strong) NSArray * cities;
@end

@implementation CPCitySearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(NSArray *)cities {
    if (_cities == nil) {
         _cities = [CPCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}
- (void)setSearchText:(NSString *)searchText {
    _searchText = [searchText copy];
    
    searchText = searchText.lowercaseString;

    // 谓词\过滤器:能利用一定的条件从一个数组中过滤出想要的数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@", searchText, searchText, searchText];
    //self.resultCities = [[MTMetaTool cities] filteredArrayUsingPredicate:predicate];
    self.resultCities = [self.cities filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    CPCity *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"共有%d个搜索结果", self.resultCities.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CPCity *city = self.resultCities[indexPath.row];
    // 发出通知
    [CPNotificationCenter postNotificationName:CPCityDidChangeNotification object:nil userInfo:@{CPSelectCityName : city.name}];
    [self.navigationController popViewControllerAnimated:NO];
}
@end
