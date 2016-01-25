//
//  CPGuideController.m
//  chargingPile
//
//  Created by weichenchao on 16/1/25.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPGuideController.h"

@interface CPGuideController ()

@end

@implementation CPGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addmapview];
    [self addFooter];
}


//添加地图视图
- (void)addmapview {
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-300)];
    self.mapView = mapView;
    //self.mapView.centerCoordinate = self.model.locationCoordinate2D;
    
    [self.view addSubview:self.mapView];
    self.mapView.isSelectedAnnotationViewFront = YES;
    //地图比例尺显示
    self.mapView.showMapScaleBar = YES;
}
- (void)addFooter {
    CGFloat viewHeight = self.view.bounds.size.height;
    CGFloat viewWidth = self.view.bounds.size.width;
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeight-300,viewWidth , 300)];
    footer.backgroundColor = [UIColor whiteColor];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,viewWidth , 30)];
    nameLabel.text = self.model.name;
    [footer addSubview:nameLabel];
    [self.view addSubview:footer];
}
@end
