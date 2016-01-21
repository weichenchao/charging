//
//  CPHomeCell.h
//  chargingPile
//
//  Created by weichenchao on 16/1/11.
//  Copyright © 2016年 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPNewsModel.h"

@interface CPHomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsDescip;
- (void)setDataWithNewsModel:(CPNewsModel *)model;
@end
