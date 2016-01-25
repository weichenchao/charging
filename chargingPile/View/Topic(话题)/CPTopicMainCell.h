//
//  CPTopicMainCell.h
//  chargingPile
//
//  Created by weichenchao on 16/1/22.
//  Copyright © 2016年 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTopicBasicModel.h"
@protocol CPTopicMainCellDelegate<NSObject>
@optional
/*
 *选中整个cell的代理方法
 */
- (void)addMainViewGesture;
/*
 *选中头像的代理方法
 */
- (void)addAuthorViewGesture;
@end
@interface CPTopicMainCell : UITableViewCell

@property (nonatomic, strong) id<CPTopicMainCellDelegate> myDelegate;

@property (nonatomic,strong) CPTopicBasicModel *model;
//第一模块
@property (weak, nonatomic) IBOutlet UIView *mainView;
//第二模块
@property (weak, nonatomic) IBOutlet UIView *firstView;
//第三模块
@property (weak, nonatomic) IBOutlet UIView *secondView;
//第四模块
@property (weak, nonatomic) IBOutlet UIView *imageViews;

@end
