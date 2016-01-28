//
//  CPTopicMainCell.m
//  chargingPile
//
//  Created by weichenchao on 16/1/22.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPTopicMainCell.h"
@interface CPTopicMainCell()


@end
@implementation CPTopicMainCell

- (void)awakeFromNib {
    [self addGesture];
    
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
- (void)addGesture {
    UITapGestureRecognizer *tapMainGesturRecognizer=[[UITapGestureRecognizer alloc]init];
    [tapMainGesturRecognizer setNumberOfTapsRequired:1];
    [tapMainGesturRecognizer addTarget:self action:@selector(addMainViewGestureTarget)];
    [self.mainView addGestureRecognizer:tapMainGesturRecognizer];
    UITapGestureRecognizer *tapAuthorGesturRecognizer=[[UITapGestureRecognizer alloc]init];
    [tapAuthorGesturRecognizer setNumberOfTapsRequired:1];
    [tapAuthorGesturRecognizer addTarget:self action:@selector(addAuthorViewGestureTarget)];
    [self.firstView addGestureRecognizer:tapAuthorGesturRecognizer];
}
- (void)addMainViewGestureTarget {

    if ([_myDelegate respondsToSelector:@selector(addMainViewGesture)]) {
        [_myDelegate addMainViewGesture];
    }
   
}
- (void)addAuthorViewGestureTarget {
    
    if ([_myDelegate respondsToSelector:@selector(addAuthorViewGesture)]) {
        [_myDelegate addAuthorViewGesture];
    }
    
}
@end
