//
//  CPHomeCell.m
//  chargingPile
//
//  Created by weichenchao on 16/1/11.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPHomeCell.h"
#import "CPNewsModel.h"

@interface CPHomeCell()


@end

@implementation CPHomeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataWithNewsModel:(CPNewsModel *)model {
    self.newsTitle.text = model.newsTitle;
    self.newsDescip.text = model.newsDescrip;
}
@end
