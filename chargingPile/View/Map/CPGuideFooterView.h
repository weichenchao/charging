//
//  CPGuideFooterView.h
//  chargingPile
//
//  Created by weichenchao on 16/1/26.
//  Copyright © 2016年 private. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPGuideFooterView : UIView
- (IBAction)clickTranstionButton:(id)sender;
//三个label
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addresslabel;

@end
