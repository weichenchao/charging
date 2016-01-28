//
//  CPHomeHeaderView.m
//  chargingPile
//
//  Created by weichenchao on 16/1/11.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPHomeHeaderView.h"

@implementation CPHomeHeaderView
- (void)awakeFromNib {
    self.chargeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"location_bg"]];
    for (UIImageView *imageView in self.imageViewArray) {
        //将图片做成圆
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 24;
    }
    
}
- (void)addLocationIconTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents{
     [self.locationIconButton addTarget:target action:action forControlEvents:controlEvents];
}
- (void)addILocationLabelTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents {
     [self.locationLabelButton addTarget:target action:action forControlEvents:controlEvents];
}
- (void)addInformationTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.infomationButton addTarget:target action:action forControlEvents:controlEvents];
}
- (void)addSortTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents {
    //[self.sortButton[0] addTarget:target action:action forControlEvents:controlEvents];
}
- (IBAction)clickSortButton:(UIButton *)sender {
    NSLog(@"%ld",(long)sender.tag);
    if ([_myDelegate respondsToSelector:@selector(clickOneSortButton:)]) {
        [_myDelegate clickOneSortButton:sender];
    }
}
- (void)addChargeMapTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.chargeButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
