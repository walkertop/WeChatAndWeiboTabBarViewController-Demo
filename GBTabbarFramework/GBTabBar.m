//
//  GBTabBar.m
//  GBTabbarFramework
//
//  Created by 郭彬 on 16/6/28.
//  Copyright © 2016年 walker. All rights reserved.
//

#import "GBTabBar.h"

@interface GBTabBar ()

@property(nonatomic,strong) UIButton *customButton; //自定义加号按钮

@end

@implementation GBTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];

    if (self) {
        // 添加一个加号按钮
        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [customButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [customButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [customButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [customButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        customButton.bounds = CGRectMake(0, 0, customButton.currentBackgroundImage.size.width, customButton.currentBackgroundImage.size.height);
        //添加方法
        [customButton addTarget:self action:@selector(customButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:customButton];
        self.customButton = customButton;
    }
    return self;
}

#pragma mark - system method
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //先设置中间按钮的位置
    self.customButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    //计算每个按钮的宽度
    CGFloat tabBarButtonW = self.frame.size.width / 5;
    CGFloat tabBarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.frame = CGRectMake(tabBarButtonIndex * tabBarButtonW, 0, tabBarButtonW, self.frame.size.height);
            
            tabBarButtonIndex++;
            if (tabBarButtonIndex == 2) {
                tabBarButtonIndex++;
                }
        }
    }
}

#pragma mark - custom method
- (void)customButtonClick {
    NSLog(@"click");
    //遵守代理
    if ([self.myDelegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.myDelegate tabBarDidClickPlusButton:self];
    }
}

@end
