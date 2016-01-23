//
//  CPNewsModel.m
//  chargingPile
//
//  Created by weichenchao on 16/1/14.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPNewsModel.h"

@implementation CPNewsModel
- (CPNewsModel *)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
