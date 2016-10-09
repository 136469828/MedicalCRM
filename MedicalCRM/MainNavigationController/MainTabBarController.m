//
//  MainTabBarController.m
//  模仿简书自定义Tabbar（纯代码）
//
//  Created by 余钦 on 16/5/30.
//  Copyright © 2016年 yuqin. All rights reserved.
//

#import "MainTabBarController.h"

//#import "HomeViewController.h"
#import "NewHomeViewController.h"
#import "ChatListViewController.h"
#import "MeViewController.h"
//#import "FriendListViewController.h"
//#import "TheNewFriendListViewController.h"

#import "NewFriendViewController.h"
#import "TheCompanyViewController.h"
#import "MainTabBar.h"
#import "MainNavigationController.h"
#import "PiecewiseHomeViewController.h"
@interface MainTabBarController ()<MainTabBarDelegate>
@property(nonatomic, weak)MainTabBar *mainTabBar;
@property(nonatomic, strong)PiecewiseHomeViewController *homeVc;
@property(nonatomic, strong)ChatListViewController *subscriptionVc;
@property(nonatomic, strong)NewFriendViewController *notificationVc;
//@property(nonatomic, strong)TheNewFriendListViewController *notificationVc;
@property(nonatomic, strong)MeViewController *meVc;
@property(nonatomic, strong)TheCompanyViewController *companyVC;
@end

@implementation MainTabBarController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self SetupMainTabBar];
    [self SetupAllControllers];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

- (void)SetupMainTabBar{
    MainTabBar *mainTabBar = [[MainTabBar alloc] init];
    mainTabBar.frame = self.tabBar.bounds;
    mainTabBar.delegate = self;
    [self.tabBar addSubview:mainTabBar];
    _mainTabBar = mainTabBar;
}

- (void)SetupAllControllers{

    NSArray *titles = @[ @"信息",@"公司",@"工作", @"通讯录", @"我的"];
    NSArray *images = @[@"unmsg",@"ungongsi",@"unwork",  @"unfriend", @"unme"];
    NSArray *selectedImages =@[@"msg",@"gongsi",@"work",  @"friend", @"me"];
    
    
    
    ChatListViewController * subscriptionVc = [[ChatListViewController alloc] init];
    self.subscriptionVc = subscriptionVc;
    
    TheCompanyViewController * companyVC = [[TheCompanyViewController alloc] init];
    self.companyVC = companyVC;
    
    PiecewiseHomeViewController * homeVc = [[PiecewiseHomeViewController alloc] init];
    self.homeVc = homeVc;
    
    NewFriendViewController * notificationVc = [[NewFriendViewController alloc] init];
    self.notificationVc = notificationVc;
    
    MeViewController * meVc = [[MeViewController alloc] init];
    self.meVc = meVc;
    
    NSArray *viewControllers = @[ subscriptionVc,companyVC,homeVc, notificationVc, meVc];
    
    for (int i = 0; i < 5; i++) {
        UIViewController *childVc = viewControllers[i];
        [self SetupChildVc:childVc title:titles[i] image:images[i] selectedImage:selectedImages[i]];
    }
}

- (void)SetupChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName{
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:childVc];
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.title = title;
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarMetrics:UIBarMetricsDefault];    //设置tabbar的背景图片
//        [navC.navigationBar setTranslucent:NO];  // 不透明
    [self.mainTabBar addTabBarButtonWithTabBarItem:childVc.tabBarItem];
    [self addChildViewController:nav];
}



#pragma mark --------------------mainTabBar delegate
- (void)tabBar:(MainTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag{
    self.selectedIndex = toBtnTag;
}

- (void)tabBarClickWriteButton:(MainTabBar *)tabBar{
//    WriteViewController *writeVc = [[WriteViewController alloc] init];
//    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:writeVc];
//    
//    [self presentViewController:nav animated:YES completion:nil];
}
@end
