//
//  CPTopicMainCell.m
//  chargingPile
//
//  Created by weichenchao on 16/1/22.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPTopicMainCell.h"
@interface CPTopicMainCell()
//第一模块
@property (weak, nonatomic) IBOutlet UIView *mainView;
//第一模块
@property (weak, nonatomic) IBOutlet UIView *firstView;
//第一模块
@property (weak, nonatomic) IBOutlet UIView *secondView;
//第一模块
@property (weak, nonatomic) IBOutlet UIView *imageViews;

@end
@implementation CPTopicMainCell

- (void)awakeFromNib {
    
    
}
- (void)setModel:(CPTopicBasicModel *)model {
    _model = model;
    [self setStatus:model];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setStatus:(CPTopicBasicModel *)model {
    if (model.type ==CPTopicBasicModelStylePicture) {
        [self.imageViews setHidden:NO];
       // self.bounds =CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
    }else{
        [self.imageViews setHidden:YES];
    }
}
@end
