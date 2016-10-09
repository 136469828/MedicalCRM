//
//  AppDelegate.m
//  MedicalCRM
//
//  Created by admin on 16/7/7.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabbarController.h"
#import "MMZCViewController.h"
#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>
#import "ViewController.h"
#import <RongIMKit/RongIMKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import "JPUSHService.h"
#define RONGCLOUD_IM_APPKEY @"6tnym1brnec17" //请换成您的appkey
#import "NetManger.h"
@interface AppDelegate ()
{
    BMKMapManager* _mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    MMZCViewController *tabbatCtl = [[MMZCViewController alloc] init];
    self.window.rootViewController = tabbatCtl;
    self.window.rootViewController=tabbatCtl;
    [self.window makeKeyAndVisible];
    
    //初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    [JPUSHService registrationID];
//    //登录融云服务器,开始阶段可以先从融云API调试网站获取，之后token需要通过服务器到融云服务器取。
//    NSString*token=@"/RKe9ovnDCAqSDRz8ju/15WWa9eXtvB/MYH0YpK1Y2AS9IvuDT8GcOGvil9UpZGL2GDzvJgCerW1QLvDVKSpyg==";
//    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
//        //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
//        [[RCIM sharedRCIM] setUserInfoDataSource:self];
//        NSLog(@"Login successfully with userId: %@.", userId);
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//        });
//    } error:^(RCConnectErrorCode status) {
//        NSLog(@"login error status: %ld.", (long)status);
//    } tokenIncorrect:^{
//        NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
//    }];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    
    // 极光推送
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PushConfig" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    [JPUSHService setupWithOption:launchOptions appKey:dic[@"APP_KEY"] channel:dic[@"CHANNEL"] apsForProduction:NO];

    
    // 百度地图
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"R0k5LhRonh8mr7rKmsGHuIVebgURvO7R"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/**
 *  将得到的devicetoken 传给融云用于离线状态接收push ，您的app后台要上传推送证书
 *
 *  @param application <#application description#>
 *  @param deviceToken <#deviceToken description#>
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    JCKLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushID"]);
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
    // ＊＊＊＊＊星标1＊＊＊＊＊＊＊
    [JPUSHService setTags:[NSSet setWithObjects:@"", nil] alias:[[NSUserDefaults standardUserDefaults] objectForKey:@"pushID"] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    // ＊＊＊＊＊星标1＊＊＊＊＊＊＊
}
// ＊＊＊＊＊星标2＊＊＊＊＊＊＊
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ntags: %@, \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\nalias: %@\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n", iResCode, tags , alias);
}
// ＊＊＊＊＊星标2＊＊＊＊＊＊＊

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
//        ViewController *loginVC = [[ViewController alloc] init];
//        UINavigationController *_navi =
//        [[UINavigationController alloc] initWithRootViewController:loginVC];
//        self.window.rootViewController = _navi;
    }
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}
#pragma mark - JPush
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    JCKLog(@"%@",userInfo[@"aps"][@"alert"]);
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"您有一条新消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
//    [al show];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


@end
