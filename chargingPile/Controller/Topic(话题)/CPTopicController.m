//
//  CPTopicController.m
//  chargingPile
//
//  Created by weichenchao on 16/1/22.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPTopicController.h"
#import "CPForumController.h"
#import "CPMacro.h"
static NSString *cellReuseIdentifier = @"CPTopicMainCell";
@interface CPTopicController ()
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * cellModelArray;
/*
 *根据加载的cell数据，创建对应的cell高度，如果cell是有图片的，cellHeightArray对应添加一个106元素
 *看微博项目（34.cell数据    首页15-计算原创微博的frame -10分）
 */
@property (nonatomic,strong) NSMutableArray *cellHeightArray;
@end

@implementation CPTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"话题";
    _cellHeightArray = [[NSMutableArray alloc]initWithObjects:@183,@111,@183,@111,@183, nil];
    [self addTheTableView];
    [self addTheHeader];
    
    
    
}
-(void)addTheTableView {
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0,0 , self.view.bounds.size.width, self.view.bounds.size.height-64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //取消垂直滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    //取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    UINib *nib =[UINib nibWithNibName:@"CPTopicMainCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellReuseIdentifier];
    
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
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"topic_new"] style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"topic_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(bar)];
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
- (NSMutableArray *)cellModelArray {
    if (_cellModelArray == nil) {
        _cellModelArray = [[NSMutableArray alloc]init];
        
    }
    
    return _cellModelArray;
}
-(void)bar {
    
}
#pragma mark -cell点击事件
//点击cell
-(void)addMainViewGesture {
    NSLog(@"main.............");
    CPForumController *forumVC =[[CPForumController alloc]init];
    [self.navigationController pushViewController:forumVC animated:NO];
    
}
//点击作者头像
-(void)addAuthorViewGesture {
    NSLog(@"author.............");
}
#pragma mark -tableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
-(CPTopicMainCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    CPTopicMainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (cell == nil) {
        cell = [[CPTopicMainCell alloc]init];

        
    }
    //关闭选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myDelegate = self;
    //cell偶数有图片，高度188；无图片138
    if (indexPath.row%2 == 0) {
        CPTopicBasicModel *model = [[CPTopicBasicModel alloc]init];
        
        model.type =CPTopicBasicModelStylePicture;
        cell.bounds =CGRectMake(0, 0, self.view.bounds.size.width, 180);
        cell.model = model;
        
    }else{
        CPTopicBasicModel *model1 = [[CPTopicBasicModel alloc]init];
        
        model1.type = CPTopicBasicModelStyleDefault;
        cell.bounds =CGRectMake(0, 0, self.view.bounds.size.width, 108);
        cell.model = model1;
    }
    cell.bounds =CGRectMake(0, 0, self.view.bounds.size.width, 180);
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *numb =_cellHeightArray[indexPath.row];
    CGFloat number =[numb doubleValue];
    return number;
}

@end
