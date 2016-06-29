//
//  GBTabBar.h
//  GBTabbarFramework
//
//  Created by 郭彬 on 16/6/28.
//  Copyright © 2016年 walker. All rights reserved.
//

#import <UIKit/UIKit.h>

//custom delegate
@class GBTabBar;
@protocol GBTabBarDelegate <NSObject>

@optional
- (void)tabBarDidClickPlusButton:(GBTabBar *)tabBar;
@end

@interface GBTabBar : UITabBar
//此处代理名字不能为delegate，因为会和UITabbar本身的delegate冲突
@property (nonatomic, weak) id<GBTabBarDelegate> myDelegate;


@end
