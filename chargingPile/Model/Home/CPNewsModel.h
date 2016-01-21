//
//  CPNewsModel.h
//  chargingPile
//
//  Created by weichenchao on 16/1/14.
//  Copyright © 2016年 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPNewsModel : NSObject

@property (nonatomic,copy) NSString *newsImage;
@property (nonatomic,copy) NSString *newsTitle;
@property (nonatomic,copy) NSString *newsDescrip;
- (CPNewsModel *)initWithDict:(NSDictionary *)dict;
@end
