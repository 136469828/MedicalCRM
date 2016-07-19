//
//  ChatListViewController.m
//  RongCloudDemo
//
//  Created by 杜立召 on 15/4/18.
//  Copyright (c) 2015年 dlz. All rights reserved.
//

#import "ChatListViewController.h"
#import "FriendListViewController.h"
#import "AddFriendViewController.h"
#import "SVProgressHUD.h"
@interface ChatListViewController ()<RCIMUserInfoDataSource,UIActionSheetDelegate>

@end

@implementation ChatListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"消息";
//    testCtrl = [[UIViewCtrlTest alloc] initW];
//    testCtrl.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:testCtrl animated:YES];
//    testCtrl.hidesBottomBarWhenPushed = NO;//马上设置回NO

}
/**
 * 登录融云
 *
 */
-(void)loginRongCloud
{
    //登录融云服务器,开始阶段可以先从融云API调试网站获取，之后token需要通过服务器到融云服务器取。
    NSString*token=@"8IQEeIwNCfeTBXXkPrTXX8fKDSmkBZ3iMfp4c76/dYLk14c9moC0ZyGxWJnAWQ+DQdZDznXAxzg=";
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        NSLog(@"Login successfully with userId: %@.", userId);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:@"正在连接"];
        });
        [SVProgressHUD dismiss];
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
    }else if([@"10010" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"10010";
        user.name = @"cong1";
        user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
        return completion(user);
    }
}
-(void)viewDidLoad
{
    [super viewDidLoad];
//    [self loginRongCloud];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION)]];
    //自定义导航左右按钮
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed:)];
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 25, 25);
        [meassageBut addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchDown];
        [meassageBut setImage:[UIImage imageNamed:@"新建消息"]forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
//    self.navigationItem.rightBarButtonItem = rBtn;
    
    [rightButton setTintColor:[UIColor blackColor]];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 6, 67, 23);
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigator_btn_back"]];
    backImg.frame = CGRectMake(-10, 0, 22, 22);
    [backBtn addSubview:backImg];

    self.navigationItem.rightBarButtonItem = rightButton;
    
#pragma mark - 设置navigationItem左侧按钮
    UIButton *friendBut = ({
        UIButton *friendBut = [UIButton buttonWithType:UIButtonTypeCustom];
        friendBut.frame = CGRectMake(0, 0, 25, 25);
        [friendBut addTarget:self action:@selector(pushMSG) forControlEvents:UIControlEventTouchDown];
        [friendBut setImage:[UIImage imageNamed:@"联系人"]forState:UIControlStateNormal];
        friendBut;
    });
    
    UIBarButtonItem *lBtn = [[UIBarButtonItem alloc] initWithCustomView:friendBut];
    self.navigationItem.leftBarButtonItem = lBtn;
    
    self.conversationListTableView.tableFooterView = [UIView new];
}

/**
 *重写RCConversationListViewController的onSelectedTableRow事件
 *
 *  @param conversationModelType 数据模型类型
 *  @param model                 数据模型
 *  @param indexPath             索引
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    conversationVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
    
    
}


/**
 *  退出登录
 *
 *  @param sender <#sender description#>
 */
- (void)leftBarButtonItemPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alertView show];
}

/**
 *  重载右边导航按钮的事件
 *
 *  @param sender <#sender description#>
 */
-(void)rightBarButtonItemPressed:(id)sender
{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE;
    conversationVC.targetId = @"10011"; //这里模拟自己给自己发消息，您可以替换成其他登录的用户的UserId 110
    conversationVC.title = @"测试";
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
//    FriendListViewController *sub = [[FriendListViewController alloc] init];
//    sub.title = @"好友管理";
//    sub.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:sub animated:YES];

}
- (void)btnAction
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加好友",@"创建新群聊",@"新建聊天", nil];
    [as showInView:self.conversationListTableView];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            // 添加好友
            AddFriendViewController *sub = [[AddFriendViewController alloc] init];
            sub.title = @"添加好友";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];

        }
            break;
        case 1:
        {
            FriendListViewController *sub = [[FriendListViewController alloc] init];
            sub.title = @"选择好友";
            sub.isAdd = YES;
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];


        }
            break;
        case 2:
        {
            // 新建聊天
            
        }
            break;
        case 3:
        {
            // 取消
        }
            break;
            
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[RCIM sharedRCIM]disconnect];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - btnAction
- (void)btnAction:(UIButton *)btn
{

    
}
- (void)pushMSG
{
    FriendListViewController *sub = [[FriendListViewController alloc] init];
    sub.title = @"好友列表";
    sub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sub animated:YES];

}
@end