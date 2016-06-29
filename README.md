# WeChatAndWeiboTabBarViewController-Demo
#精讲系列之—— 十分钟学会搭建微信和微博两种主流框架（纯代码）

[TOC]

目录：
> - 1、两种框架的介绍
> - 2、微信主流框架的实现思路
> - 3、微信主流框架的代码实现
> - 4、微博主流框架的实现思路
> - 5、微博主流框架的代码实现
> - 6、总结
> - 7、[Demo下载](https://github.com/walkertop/WeChatAndWeiboTabBarViewController-Demo)

## 介绍
实际开发中，我们常会见到两种主流框架，一种类似于微信，UIWindow的根`rootViewController`为`UITabBarController`，然后调用`addChildViewController`（继承自UIViewController）添加子控制器。然后实现控制器的跳转。

> 简述下点击UITabBarController的UITabBar切换控制器的原理：
 
点击UITabBarController上的UITabBar跳转控制器的原理是：
很多人未曾注意到`UIViewController`有个容器属性，可以添加一组子控制器。
 `@property(nonatomic,readonly) NSArray<__kindof UIViewController *> *childViewControllers NS_AVAILABLE_IOS(5_0);`
当然也可以通过如下方法添加子控制器

`- (void)addChildViewController:(UIViewController *)childController NS_AVAILABLE_IOS(5_0);`

UITabBarController继承自UIViewController，当然也会继承这个属性和方法。
UITabBarController的代理协议`UITabBarControllerDelegate`中有`- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;`这个方法，点击UITabBar时，会将数组中的对应的UIViewController取出放在当前界面并显示。

当点击UITabBarController上的UITabBar时,会实现这个代理方法并完成控制器的切换。


## 一、微信主流框架的搭建
### 1、微信主流框架的实现思路
微信的UITabBarController和系统的样式相同，实现原理也一样，所以在此主要讲解下控制器之间代码的实现思路和封装。

> - 1. 在appDelegate中，将window的rootViewController设置为带有UITabBarController的导航控制器;
> - 2. 创建子控制器，设置子控制器的title,image,selectedImage等属性
> - 3. 设置子控制器的导航控制器，并添加到childViewController中

### 2、微信主流框架的代码实现
#### 1. 在appDelegate中，将window的rootViewController设置为带有UITabBarController的导航控制器;
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 //类似微信的UITabBarController
	GBWeChatTabBarController *weChatVc = [[GBWeChatTabBarController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:weiboVc];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}
```

#### 2. 创建子控制器，设置子控制器的title,image,selectedImage等属性
```
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

```


#### 3. 设置子控制器的导航控制器，并添加到childViewController中
```

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
```
-

## 二、微博主流框架的搭建
但是微博就不同了。
回想一下，微信的UITabBarController切换是调用了代理方法，取出数组中对应的控制器，然后现实出来。
但点击微博的中间的加号按钮，弹出pop动画的界面，而不是子控制器。
那怎么实现这个功能呢？
严格来说，有UITabBarController有n个子控制器，下面的UITabBar就有n个UITabBarItem。但我们只有4个控制器，下面却有5个UITabBarItem怎么办？
显然系统的UITabBar不好用，那就只能重写了。
所以我们自定义一个UITabBar类的新类GBTabBar。
由于UITabBar继承自UIView，所以我们只要把中间的加号按钮定义为一个button，然后通过在GBTabBar中`[self addSubview:button]`就可以了。
然后实现按钮的点击事件，并通过代理（或者block等方式）将点击方法传到UITabBarController中。
但注意，由于系统的UITabBarItem的会平分整个UITabBar，所以添加完button之后，我们需要重写每一个UITabBarItem的尺寸。

### 1、微博主流框架的实现思路
微信的UITabBarController和系统的样式相同，实现原理也一样，所以在此主要讲解下控制器之间代码的实现思路和封装。

> - 1. 在appDelegate中，将window的rootViewController设置为带有UITabBarController的导航控制器;
> - 2. 创建子控制器，设置子控制器的title,image,selectedImage等属性
> - 3. 设置子控制器的导航控制器，并添加到childViewController中，
> - 4. 自定义新的UITabBar，然后在UITabBar上添加中间的加号按钮
> - 5. 重写layoutSubviews，完成布局。
> - 6. 实现点击事件，并定义代理方法，将代理方法传至UITabBarController中

### 2、微博主流框架的代码实现

#### 1.
```
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
```



#### 2.

```
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

```

#### 3.

```
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
```
#### 4.

```
//  GBTabBar.h文件中

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


//  GBTabBar.m文件中

#pragma mark - custom method
- (void)customButtonClick {
    NSLog(@"click");
    //遵守代理
    if ([self.myDelegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.myDelegate tabBarDidClickPlusButton:self];
    }
}
```


文末总结：
在我认为，写技术博客，两种方式会尤low:
> - 从不结合实际需求，全篇大段的copy概念性知识点，不讲自己的理解的很low; 
> - 大段的copy代码，只做代码表层级别的注释说明，不讲解实现原理和思路的更low；

以上两种技术博客极少需要动脑，写作成本很低。 
因为粘贴大段纯概念知识点，不建立在实际使用场景下很难形象理解，加深记忆；
大篇幅粘贴纯代码可以说纯了碰到实际需求，解决浅层问题，读者看了很难举一反三；
当然，也并非说无用，只是说用处不大，见效甚微而且只是无根。 
所以我把这类博客归结为无根知识。 
所以也希望读者在看作者的文章时，多带思考。很多知识点是代入式的讲解，希望能帮你构建自己的知识网罗。
我不做无根的作者，你也不要做浅层的读者。

如有错误欢迎指出，文毕，程序员注定不能做一个孤独的勇士，也欢迎大家加微信号` bin5211bin`学习交流。
[Demo下载](https://github.com/walkertop/WeChatAndWeiboTabBarViewController-Demo)


