//
//  RootTabbarController.m
//  ManagementSystem
//
//  Created by JCong on 16/2/27.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "RootTabbarController.h"
#import "HomeViewController.h"
#import "ChatListViewController.h"
#import "MeViewController.h"
#import "FriendListViewController.h"
//#import "LoginViewController.h"
//#import "GameViewController.h"
@interface RootTabbarController ()

@end

@implementation RootTabbarController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self setTabBarController];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarMetrics:UIBarMetricsDefault];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark TabBarView
- (void)setTabBarController{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    [self setUpOneChildViewController:homeVC Homepage:[UIImage imageNamed:@"newwork"] Selected:[UIImage imageNamed:@"work"] title:@"工作"];
    
    FriendListViewController *friendListCtr = [[FriendListViewController alloc] init];
    [self setUpOneChildViewController:friendListCtr Homepage:[UIImage imageNamed:@"newlinkman"] Selected:[UIImage imageNamed:@"linkMan"] title:@"联系人"];
   
    ChatListViewController *messageVC = [[ChatListViewController alloc] init];
    [self setUpOneChildViewController:messageVC Homepage:[UIImage imageNamed:@"newmag"] Selected:[UIImage imageNamed:@"msg"] title:@"消息"];
//    FriendListViewController *firendVC = [[FriendListViewController alloc] init];
//    [self setUpOneChildViewController:firendVC Homepage:[UIImage imageNamed:@"search_icon_home_group"] Selected:[UIImage imageNamed:@""] title:@"好友"];
   
    MeViewController *infoVC = [[MeViewController alloc] init];
    [self setUpOneChildViewController:infoVC Homepage:[UIImage imageNamed:@"newme"] Selected:[UIImage imageNamed:@"me"] title:@"我的"];
    
    
}

#pragma mark 快速创建TabBarView模板
- (void)setUpOneChildViewController:(UIViewController *)viewController Homepage:(UIImage *)homepage Selected:(UIImage *)selectedImage title:(NSString *)title{

    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:viewController];
    navC.title = title; // 标题
    //    navC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[homepage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]selectedImage:selectedImage];
    navC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:homepage selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarMetrics:UIBarMetricsDefault];    //设置tabbar的背景图片
    //    [navC.navigationBar setTranslucent:NO];  // 不透明
    
    [self addChildViewController:navC];
}
- (void)pushMSG
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
