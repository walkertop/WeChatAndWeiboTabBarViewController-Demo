//
//  GBWeiboTabBarViewController.m
//  GBTabbarFramework
//
//  Created by 郭彬 on 16/6/28.
//  Copyright © 2016年 walker. All rights reserved.
//

#import "GBWeiboTabBarViewController.h"
#import "GBOneTableViewController.h"
#import "GBTwoTableViewController.h"
#import "GBThreeTableViewController.h"
#import "GBFourTableViewController.h"
#import "GBTabBar.h"    //自定义tabBar


@interface GBWeiboTabBarViewController ()<GBTabBarDelegate,UITabBarControllerDelegate>

@end


@implementation GBWeiboTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAllChildViewControllers];
    self.selectedIndex = 3;
    
    //把自定义的tabBar替换掉系统tabBar
    GBTabBar *customTabBar = [[GBTabBar alloc]init];
    //成为代理对象
    customTabBar.myDelegate = self;
    self.delegate = self;
    //注意：因为是系统的tabBar是readonly的，所以用KVO方法替换
    [self setValue:customTabBar forKey:@"tabBar"];
    NSLog(@"viewControllers === %@",self.viewControllers);
    NSLog(@"childViewControllers===%@",self.childViewControllers);
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    NSLog(@"%ld",self.selectedIndex);
    NSLog(@"%@",self.tabBarController);
    NSLog(@"%@",self.selectedViewController);
    UINavigationController *selectedNav =  (UINavigationController *)self.selectedViewController;
    NSLog(@"%@",selectedNav.viewControllers);
    if (self.selectedIndex == 2) {
        self.selectedIndex = 0;
    }
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

#pragma mark - implement delegate
- (void)tabBarDidClickPlusButton:(GBTabBar *)tabBar {
    NSLog(@"点击，在这里实现代理操作");
   
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor greenColor];
    
    UIViewController *oneVc = [[UIViewController alloc]init];
    oneVc.view.frame = CGRectMake(10, 80, 100 , 200);
    oneVc.view.backgroundColor = [UIColor whiteColor];
    
    UIViewController *twoVc = [[UIViewController alloc]init];
    twoVc.view.frame = CGRectMake(150, 180, 70, 100);
    twoVc.view.backgroundColor = [UIColor blackColor];
    [vc.view addSubview:oneVc.view];
    [vc.view addSubview:twoVc.view];
    [vc addChildViewController:oneVc];
    [vc addChildViewController:twoVc];

    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"普通控制器的子控制器包含%@,数量有%lu",vc.childViewControllers,(unsigned long)vc.childViewControllers.count);
    
    NSLog(@"导航控制器的的子控制器包含%@,数量有%lu",self.navigationController.viewControllers,(unsigned long)self.navigationController.viewControllers.count);
    
    NSLog(@"导航控制器的childViewControllers是%@",self.navigationController.childViewControllers);
    NSLog(@"自己的是childViewControllers%@，自己的viewControllers是%@",self.childViewControllers,self.viewControllers
);

    NSLog(@"栈顶%@",self.navigationController.topViewController);
    
}
@end
