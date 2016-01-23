//
//  CPTopicController.m
//  chargingPile
//
//  Created by weichenchao on 16/1/22.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPTopicController.h"
#import "CPMacro.h"
@interface CPTopicController ()
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation CPTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"话题";
    
    [self addTheTableView];
    [self addTheHeader];
    
}
-(void)addTheTableView {
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0,0 , self.view.bounds.size.width, self.view.bounds.size.height-64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
}
-(void)addTheHeader {
    //navigationBar其实有三个子视图，leftBarButtonItem，rightBarButtonItem，以及titleView
    UIBarButtonItem *spaceItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *topicButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"话题" style:UIBarButtonItemStylePlain target:self action:@selector(bar)];
    UIBarButtonItem *hotButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"热门" style:UIBarButtonItemStylePlain target:self action:@selector(bar)];
    UIBarButtonItem *topButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"置顶" style:UIBarButtonItemStylePlain target:self action:@selector(bar)];
    UIBarButtonItem *mainButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"精华" style:UIBarButtonItemStylePlain target:self action:@selector(bar)];
    UIToolbar *toolbar =[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-80, 44)];
    NSArray  *items = [NSArray arrayWithObjects:spaceItem,topicButtonItem,spaceItem,hotButtonItem,spaceItem,topButtonItem,spaceItem,mainButtonItem,spaceItem, nil];
//    toolbar.backgroundColor =COLOR(0, 171, 243, 1) ;//UIColorFromRGB(0x00abf3);
    toolbar.items = items;
    toolbar.backgroundColor = [UIColor blueColor];
    //toolbar.barStyle = UIBarStyleBlackOpaque;设置类型都没有用
    //只有设置背景图片才能去除透明效果  toolbar
    UIImage *image = [self buttonImageFromColor:UIColorFromRGB(0x00abf3)];
    [toolbar setBackgroundImage:image forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.view addSubview:toolbar];
    
    
    //[toolbar setBackgroundImage:image forToolbarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    //[self.navigationController setToolbarHidden:NO];
    //[self.navigationController setValue:toolbar forKey:@"toolbar"];
   
    self.navigationItem.titleView = toolbar;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"11" style:UIBarButtonItemStylePlain target:self action:@selector(bar)];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"22" style:UIBarButtonItemStylePlain target:self action:@selector(bar)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}
//通过颜色来生成一个纯色图片
- (UIImage *)buttonImageFromColor:(UIColor *)color{

    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)bar {
    
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
