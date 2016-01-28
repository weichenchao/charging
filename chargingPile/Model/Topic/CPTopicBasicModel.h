//
//  CPTopicBasicModel.h
//  chargingPile
//
//  Created by wheat on 16/1/23.
//  Copyright © 2016年 private. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, CPTopicBasicModelStyle) {
    CPTopicBasicModelStyleDefault,
   
    CPTopicBasicModelStylePicture   
};
@interface CPTopicBasicModel : NSObject
/*
 *model类型
 */
@property (nonatomic,assign) CPTopicBasicModelStyle type;
/*
 *发布者
 */
@property (nonatomic,copy) NSString *authorName;
/*
 *发布者头像占位
 */
@property (nonatomic,copy) NSString *authorIconPlaceholder;
/*
 *发布者头像地址
 */
@property (nonatomic,copy) NSString *authorIconURL;
/*
 *发布时间
 */
@property (nonatomic,copy) NSString *publishTime;
/*
 *发布者等级
 */
@property (nonatomic,copy) NSString *rank;
/*
 *点赞数
 */
@property (nonatomic,copy) NSString *praiseNumber
/*
 *评论数
 */;
@property (nonatomic,copy) NSString *commentNumber;

@end
