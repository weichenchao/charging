//
//  CPTopicPictureModel.h
//  chargingPile
//
//  Created by wheat on 16/1/23.
//  Copyright © 2016年 private. All rights reserved.
//

#import "CPTopicBasicModel.h"

@interface CPTopicPictureModel : CPTopicBasicModel
/*
 *图片数
 */
@property (nonatomic,copy) NSString *pictureNumber;
/*
 *图片地址数组
 */
@property (nonatomic,copy) NSArray *pictureURL;
@end
