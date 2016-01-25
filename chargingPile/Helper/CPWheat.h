//
//  CPWheat.h
//  chargingPile
//
//  Created by weichenchao on 16/1/25.
//  Copyright © 2016年 private. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>
@protocol WheatProtocol <JSExport>
- (void)didLoginSuccess;

@end

@interface CPWheat : NSObject
+ (CPWheat *)sharedInstance;
@property(nonatomic, copy) void(^login)(void);
@end
