//
//  InformationViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "InformationViewController.h"
#import "ChatListViewController.h"
#import <RongIMKit/RCConversationViewController.h>
@interface InformationViewController ()

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"消息";
    UIButton*loginButton=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2-50, ScreenHeight/2-25, 100, 50)];
    
    [loginButton setTitle:@"进入聊天室" forState:UIControlStateNormal];
    loginButton.backgroundColor=[UIColor blueColor];
    [loginButton addTarget:self action:@selector(loginRongCloud) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *登录融云
 *
 */
-(void)loginRongCloud
{
    //登录融云服务器,开始阶段可以先从融云API调试网站获取，之后token需要通过服务器到融云服务器取。
    NSString*token=@"8IQEeIwNCfeTBXXkPrTXX8fKDSmkBZ3iMfp4c76/dYLk14c9moC0ZyGxWJnAWQ+DQdZDznXAxzg=";
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
//        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        NSLog(@"Login successfully with userId: %@.", userId);
        dispatch_async(dispatch_get_main_queue(), ^{
            ChatListViewController *chatListViewController = [[ChatListViewController alloc]init];
            [self.navigationController pushViewController:chatListViewController animated:YES];
        });
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"login error status: %ld.", (long)status);
    } tokenIncorrect:^{
        NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
    }];
    
}
/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    //此处为了演示写了一个用户信息
    if ([@"110" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"110";
        user.name = @"cong2";
        user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
        
        return completion(user);
    }else if([@"2" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"2";
        user.name = @"cong1";
        user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
        return completion(user);
    }
}


@end
