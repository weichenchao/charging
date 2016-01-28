//
//  CPGlobaLInfo.h
//  chargingPile
//
//  Created by wheat on 16/1/27.
//  Copyright © 2016年 private. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPUserModel.h"

@interface CPGlobaLInfo : NSObject
@property (nonatomic,strong) CPUserModel *userModel;
+ (CPGlobaLInfo *)sharedGlobal;
@end
