//
//  CPTopicController.m
//  chargingPile
//
//  Created by weichenchao on 16/1/22.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPTopicController.h"

@interface CPTopicController ()
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation CPTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"话题";
    [self addTheTableView];
    [self addTheHeader];
}
-(void)addTheTableView {
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0,44 , self.view.bounds.size.width, self.view.bounds.size.height-44-64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
}
-(void)addTheHeader {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -tableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =[self.tableView dequeueReusableCellWithIdentifier:@"CPTopicControllerCell"];
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CPTopicControllerCell"];
    }

    return  cell;
}
@end
