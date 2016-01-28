//
//  CPGlobaLInfo.m
//  chargingPile
//
//  Created by wheat on 16/1/27.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPGlobaLInfo.h"

@implementation CPGlobaLInfo
static CPGlobaLInfo *global = nil;
+ (CPGlobaLInfo *)sharedGlobal {
    if (!global) {
        global = [[self alloc] init];
    }
    return global;
}
@end
