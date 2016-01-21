//
//  AppDelegate.h
//  chargingPile
//
//  Created by weichenchao on 16/1/8.
//  Copyright © 2016年 private. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BMKMapManager * mapManager;

@end

