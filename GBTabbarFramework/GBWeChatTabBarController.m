//
//  GBWeChatTabBarController.m
//  GBTabbarFramework
//
//  Created by 郭彬 on 16/6/28.
//  Copyright © 2016年 walker. All rights reserved.
//

#import "GBWeChatTabBarController.h"
#import "GBOneTableViewController.h"
#import "GBTwoTableViewController.h"
#import "GBThreeTableViewController.h"
#import "GBFourTableViewController.h"

@interface GBWeChatTabBarController ()


@end

@implementation GBWeChatTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //创建正常的四个控制器（类似微信）
    [self setupAllChildViewControllers];

    //创建四个控制器加中间自定义按钮的控制器（类似未必）
    
}

#pragma mark - custom method
// 初始化所有的子控制器
- (void)setupAllChildViewControllers {
    // 1.ONE
    GBOneTableViewController *one = [[GBOneTableViewController alloc] init];
    [self addChildViewController:one  title:@"ONE" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    
    // 2.TWO
    GBTwoTableViewController *two = [[GBTwoTableViewController alloc] init];
    [self addChildViewController:two title:@"TWO" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    
    // 3.THREE
    GBThreeTableViewController *three = [[GBThreeTableViewController alloc] init];
    [self addChildViewController:three title:@"THREE" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    
    // 4.FOUR
    GBFourTableViewController *four = [[GBFourTableViewController alloc] init];
    [self addChildViewController:four title:@"FOUR" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中的图标
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    // 2.包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

@end
