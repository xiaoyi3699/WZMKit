//
//  WZMTabBarController.m
//  LLTabBarViewController
//
//  Created by zhaomengWang on 2017/3/31.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMTabBarController.h"
#import "WZMNavigationController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "WZMMacro.h"

@interface WZMTabBarController ()

@end

@implementation WZMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view insertSubview:[self screenShotView] atIndex:0];
}

+ (instancetype)tabBarController {
    static WZMTabBarController *tabBarController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBarController = [[WZMTabBarController alloc] init];
        tabBarController.tabBar.translucent = NO;
        
        FirstViewController *firstViewController = [[FirstViewController alloc] init];
        WZMNavigationController *firstNav = [[WZMNavigationController alloc] initWithRootViewController:firstViewController];
        
        SecondViewController *secondViewController = [[SecondViewController alloc] init];
        WZMNavigationController *secondNav = [[WZMNavigationController alloc] initWithRootViewController:secondViewController];
        
        ThirdViewController *thirdViewController = [[ThirdViewController alloc] init];
        WZMNavigationController *thirdNav = [[WZMNavigationController alloc] initWithRootViewController:thirdViewController];
        
        [tabBarController setViewControllers:@[firstNav,secondNav,thirdNav]];
        [tabBarController setConfig];
    });
    return tabBarController;
}

- (void)setConfig {
    NSArray *titles = @[@"第一页",@"第二页",@"第三页"];
    NSArray *normalImages = @[@"tabbar_icon",@"tabbar_icon",@"tabbar_icon"];
    NSArray *selectImages = @[@"tabbar_icon_on",@"tabbar_icon_on",@"tabbar_icon_on"];
    for (NSInteger i = 0; i < self.viewControllers.count; i ++) {
        
        UIViewController *viewController = self.viewControllers[i];
        
        NSDictionary *atts = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:12]};
        NSDictionary *selAtts = @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:12]};
        
        UIImage *img = [[UIImage imageNamed:normalImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selImg = [[UIImage imageNamed:selectImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        viewController.tabBarItem.title = titles[i];
        viewController.tabBarItem.image = img;
        viewController.tabBarItem.selectedImage = selImg;
        [viewController.tabBarItem setTitleTextAttributes:atts forState:UIControlStateNormal];
        [viewController.tabBarItem setTitleTextAttributes:selAtts forState:UIControlStateSelected];
    }
}

- (void)setBadgeValue:(NSString *)badgeValue atIndex:(NSInteger)index{
    if (index < self.viewControllers.count) {
        UIViewController *vc = [self.viewControllers objectAtIndex:index];
        vc.tabBarItem.badgeValue = badgeValue;
    }
}

//- (UIViewController *)childViewControllerForStatusBarHidden {
//    return self.selectedViewController;
//}
//
//- (UIViewController *)childViewControllerForStatusBarStyle {
//    return self.selectedViewController;
//}
//
//- (UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures {
//    return self.selectedViewController;
//}

#pragma mark - lazy load
- (WZMScreenShotView *)screenShotView {
    if (_screenShotView == nil) {
        _screenShotView = [[WZMScreenShotView alloc] init];
        _screenShotView.frame = WZM_SCREEN_BOUNDS;
        _screenShotView.hidden = YES;
    }
    return _screenShotView;
}

@end
