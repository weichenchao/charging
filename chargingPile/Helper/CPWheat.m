//
//  CPWheat.m
//  chargingPile
//
//  Created by weichenchao on 16/1/25.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPWheat.h"
static NSString *kConfirmAlertNotificationName = @"kConfirmAlertNotificationName";
@implementation CPWheat
 static CPWheat *wheat = nil;
+ (CPWheat *)sharedInstance {
    if (!wheat) {
        wheat = [[self alloc] init];
    }
    return wheat;
}
- (void)didLoginSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:kConfirmAlertNotificationName object:nil];
}

@end
