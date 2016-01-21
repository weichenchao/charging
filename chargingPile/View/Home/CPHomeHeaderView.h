//
//  CPHomeHeaderView.h
//  chargingPile
//
//  Created by weichenchao on 16/1/11.
//  Copyright © 2016年 private. All rights reserved.
//

#import <UIKit/UIKit.h>
//协议
@protocol CPHomeHeaderViewDelegate<NSObject>
@required
//- returnChooseDay:(id)myChooseDayView;
@optional

- (void)clickOneSortButton:(UIButton *)button;
@end

@interface CPHomeHeaderView : UIView

//代理
@property (nonatomic, strong) id<CPHomeHeaderViewDelegate> myDelegate;

//location模块一
@property (weak, nonatomic) IBOutlet UIButton *locationIconButton;
@property (weak, nonatomic) IBOutlet UIButton *locationLabelButton;
@property (weak, nonatomic) IBOutlet UIButton *infomationButton;
- (void)addLocationIconTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addILocationLabelTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addInformationTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents;

//personInfo模块二
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewArray;

@property (weak, nonatomic) IBOutlet UITextField *chargeText;
@property (weak, nonatomic) IBOutlet UITextField *scoreText;

//模块三

@property (weak, nonatomic) IBOutlet UIView *chargeView;
@property (weak, nonatomic) IBOutlet UIButton *chargeButton;
- (void)addChargeMapTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (IBAction)clickSortButton:(UIButton *)sender;
- (void)addSortTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents;

//scrollView模块四
@property (weak, nonatomic) IBOutlet UIView *scrollView;

@end
