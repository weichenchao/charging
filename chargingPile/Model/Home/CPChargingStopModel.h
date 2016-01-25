//
//  CPChargingStopModel.h
//  chargingPile
//
//  Created by weichenchao on 16/1/25.
//  Copyright © 2016年 private. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPChargingStopModel : NSObject
/*
 *id
 */
@property (nonatomic,copy) NSString *uid;
/*
 *名称
 */
@property (nonatomic,copy) NSString *name;
/*
 *地址
 */
@property (nonatomic,copy) NSString *address;
/*
 *电话
 */
@property (nonatomic,copy) NSString *authorIconURL;
/*
 *离用户当前位置的地理距离
 */
@property (nonatomic,strong)  NSNumber *distance;

@end
