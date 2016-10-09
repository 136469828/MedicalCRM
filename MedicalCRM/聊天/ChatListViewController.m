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
#import "ChatViewController.h"
#import "NetManger.h"
#import "FriendListModel.h"
#import "AddFriendListViewController.h"
#import "MsgListViewController.h"
#import "ErweimaViewController.h"
#import "NewGroupListCtr.h"
#import "FriendListModel.h"
#import "NewFriendInfoModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "SeachFriendViewController.h"
#import "SigninViewController.h" // 签到
#import "ProjectMangerViewController.h" // 项目管理
#import "MyPayViewController.h" // 费用
#import "MyDemoChiController.h" // 样机

#import "JCKConversationViewController.h"

#import "MyPerformanceViewController.h" // 业绩
#import "AssessmentViewController.h" // 我的价值
#import "CreditViewController.h" // 诚信度
#import "LifeNavigationViewController.h" // 人生导航
#import "AuditListViewController.h"
#import "ExhibitionListViewController.h"
#import "ProjectBuildViewController.h"
#import "DemoMachineSaveController.h"
#import "TheNewCustomerListController.h"
#import "CLDropDownMenu.h"
@interface ChatListViewController ()<RCIMUserInfoDataSource,UIActionSheetDelegate,RCIMGroupInfoDataSource>
{
    NetManger *manger;
}
@end

@implementation ChatListViewController


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
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[RCIM sharedRCIM] clearUserInfoCache];
    self.navigationItem.title = @"消息";
    manger = [NetManger shareInstance];
    manger.ID = @"1";
    [manger loadData:RequestOfGetnoreadtotal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getnoreadtotal" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[RCIM sharedRCIM] clearUserInfoCache];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    manger = [NetManger shareInstance];
    manger.keywork = @"";
    [manger loadData:RequestOfGetrongclouduserpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserInfoDataSources) name:@"getrongclouduserpagelist" object:nil];
    if (self.isOnlyGroup == 1)
    {
         [self setDisplayConversationTypes:@[@(ConversationType_DISCUSSION)]];
    }
    else if (self.isOnlyGroup == 0)
    {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION)]];
    }
    else if (self.isOnlyGroup == 2)
    {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    }
    self.conversationListTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self setUserInfoDataSources];
    }];
    self.conversationListTableView.tableFooterView = [UIView new];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn addTarget:self action:@selector(erweima) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setImage:[UIImage imageNamed:@"saomiaoIcon"] forState:UIControlStateNormal];
    [settingBtn sizeToFit];
    settingBtn.frame = CGRectMake(0, 0, 35, 35);
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    
    
    UIButton *settingBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn2 addTarget:self action:@selector(setDownMenu:) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn2 setImage:[UIImage imageNamed:@"menu_gruops"] forState:UIControlStateNormal];
    [settingBtn2 sizeToFit];
    settingBtn2.frame = CGRectMake(0, 0, 35, 35);
    UIBarButtonItem *settingBtnItem2 = [[UIBarButtonItem alloc] initWithCustomView:settingBtn2];
    
    
    self.navigationItem.rightBarButtonItems  = @[settingBtnItem2];
    
    UIView *seachView = [[UIView alloc]
                         initWithFrame:CGRectMake(0, 0, ScreenWidth, 35 + 60)];
//    seachView.backgroundColor = [UIColor redColor];
    
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seachBtn.frame = CGRectMake(10,2,ScreenWidth-20,28);
    seachBtn.backgroundColor = RGB(238, 238, 238);
    seachBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    seachBtn.layer.cornerRadius = 3;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-20)/2 - 28, 7, 12, 12)];
    imgv.image = [UIImage imageNamed:@"seacchIcon"];
    [seachBtn addSubview:imgv];
    [seachBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [seachBtn setTitleColor:RGB(165, 165, 165) forState:UIControlStateNormal];
    [seachBtn addTarget:self action:@selector(seachBtnAction) forControlEvents:UIControlEventTouchDown];
    [seachView addSubview:seachBtn];
    // 分割线
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 35, ScreenWidth , 1)];
    line2.backgroundColor = RGB(235, 235, 235);
    [seachView addSubview:line2];
    // 标题
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12 + 45 + 8, 35+60 - 10 - 45, ScreenWidth - 12 + 45 + 8-60, 30)];
//    titleLab.backgroundColor = [UIColor redColor];
    titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    titleLab.text = @"巨烽小助手";
    [seachView addSubview:titleLab];
    
    // 时间
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 48, 35+60 - 10 - 48,40, 30)];
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.textColor = RGB(160, 160, 160);
    timeLab.text = @"13:10";
    timeLab.font = [UIFont systemFontOfSize:14];
    [seachView addSubview:timeLab];
    
    // 未读标记
    UILabel *readLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-40, 35+60 - 10 - 20, 20, 20)];
    readLab.tag = 5555;
    readLab.layer.cornerRadius = 10;
    readLab.layer.masksToBounds = YES;
    readLab.textAlignment = NSTextAlignmentCenter;
    readLab.font = [UIFont systemFontOfSize:10];
    readLab.textColor = [UIColor whiteColor];
    readLab.backgroundColor = [UIColor redColor];
    [seachView addSubview:readLab];
    
    // 头像
    UIImageView *imgv2 = [[UIImageView alloc] initWithFrame:CGRectMake(12, 35+60 - 10 - 45, 45, 45)];
    imgv2.image = [UIImage imageNamed:@"xiaomishuIcon"];
    imgv2.layer.cornerRadius = 5;
    [seachView addSubview:imgv2];
    
    // 分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(16, 35+60 - 1, ScreenWidth - 10, 1)];
    line.backgroundColor = RGB(235, 235, 235);
    [seachView addSubview:line];
    
    // btn
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pushBtn.frame = CGRectMake(0,30,ScreenWidth,65+35 - 30);
    pushBtn.backgroundColor = [UIColor clearColor];
    [pushBtn addTarget:self action:@selector(pushBtnAction) forControlEvents:UIControlEventTouchDown];
    [seachView addSubview:pushBtn];
    
    self.conversationListTableView.tableHeaderView = seachView;
    
    
     [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor blackColor];
}
- (void)reloadDatas
{
    UILabel *lb = (UILabel *)[self.view viewWithTag:5555];
    lb.text = [NSString stringWithFormat:@"%@",manger.getnoreadtotal];
    if ([lb.text isEqualToString:@"0"])
    {
        lb.hidden = YES;
    }
}
- (void)setUserInfoDataSources
{
    [self refreshConversationTableViewIfNeeded];
    //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
//     [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [self.conversationListTableView.header endRefreshing];
}
- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion
{
    RCGroup *user = [[RCGroup alloc] init];
    if ([groupId isEqual:@"0ad9fb11-d57d-4b90-8312-de264afb7f68"] ) {
        JCKLog(@"%@",user);
//        RCGroup *user = [[RCGroup alloc] init];
//        if (![user.portraitUri isEqualToString:model.PhotoURL])
//        {
//            user.userId = model.UserID;
//            user.name = model.EmployeeName;
//            user.portraitUri = model.PhotoURL;
//            [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:userId];
//        }
        return completion(user);
    }
}
/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    JCKLog(@"userId - %@",userId);
    for (int i = 0; i<manger.clouduserpagelist.count; i++)
    {
        FriendListModel *model = manger.clouduserpagelist[i];
        if ([userId isEqualToString:@"17,16"])
        {
            JCKLog(@"%@",model);
        }
        if ([userId isEqual:model.UserID] ) {
            RCUserInfo *user = [[RCUserInfo alloc] init];
            if (![user.portraitUri isEqualToString:model.PhotoURL])
            {
                user.userId = model.UserID;
                user.name = model.EmployeeName;
                user.portraitUri = model.PhotoURL;
                [[RCIM sharedRCIM]refreshUserInfoCache:user withUserId:userId];
            }
            return completion(user);
        }
    }
    //    JCKLog(@"User iD %@",userId);
    //    //此处为了演示写了一个用户信息
    //    if ([@"3" isEqual:userId]) {
    //        RCUserInfo *user = [[RCUserInfo alloc]init];
    //        user.userId = @"3";
    //        user.name = @"王显宁";
    //        user.portraitUri = @"http://beacon.meidp.comC1002/20160709102108552577.jpg";
    //        return completion(user);
    //    }
    //    else if([@"4" isEqual:userId]) {
    //        RCUserInfo *user = [[RCUserInfo alloc]init];
    //        user.userId = @"4";
    //        user.name = @"熊国和";
    ////                user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
    //        return completion(user);
    //    }
    
}
-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
//    RCConversationModel *model= self.conversationListDataSource[indexPath.row];
//    JCKLog(@"%@",model.targetId);
//    if (model.conversationType == ConversationType_DISCUSSION) {
//        if ([model.targetId isEqualToString:@"f7336b71-30b0-407f-a497-0b7483f7ede2"]) {
//            UIImageView *headImage = (UIImageView *)((RCConversationCell *)cell).headerImageView;
//            headImage.image = [UIImage imageNamed:@"分类"];
//        }
//    }
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
//    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
//    conversationVC.conversationType =model.conversationType;
//    conversationVC.targetId = model.targetId;
//    conversationVC.title = model.conversationTitle;
//    conversationVC.hidesBottomBarWhenPushed =YES;
//    [self.navigationController pushViewController:conversationVC animated:YES];
    
    JCKConversationViewController   *conversationVC = [[JCKConversationViewController alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.ID = model.targetId;
    conversationVC.title = model.conversationTitle;
    conversationVC.hidesBottomBarWhenPushed = YES;
//    [[RCIM sharedRCIM] clearUserInfoCache];
    [self.navigationController pushViewController:conversationVC animated:YES];
}


/**
 *  退出登录
 *
 *  @param sender <#sender description#>
 */
- (void)leftBarButtonItemPressed:(id)sender
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
//    [alertView show];
}


- (void)btnAction
{
//    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"创建新群聊", nil];
//    [as showInView:self.conversationListTableView];
    AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
    sub.title = @"选择好友";
    sub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sub animated:YES];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
//        case 0:
//        {
//            // 添加好友
//            AddFriendViewController *sub = [[AddFriendViewController alloc] init];
//            sub.title = @"添加好友";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//
//        }
//            break;
        case 0:
        {
            AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
            sub.title = @"选择好友";
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
- (void)enterTeamCard:(UIButton *)btn
{
    AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
    sub.title = @"选择好友";
    sub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sub animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[RCIM sharedRCIM]disconnect];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)pushBtnAction
{
    MsgListViewController *sub = [[MsgListViewController alloc] init];
    sub.title = @"我的消息";
    sub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sub animated:YES];
//    NewGroupListCtr *sub = [[NewGroupListCtr alloc] init];
//    sub.title = @"群组";
//    sub.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:sub animated:YES];

}
- (void)erweima
{
    ErweimaViewController *sub = [[ErweimaViewController alloc] init];
    sub.title = @"请把二维码至于方框内";
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)seachBtnAction
{
    SeachFriendViewController *sub = [[SeachFriendViewController alloc] init];
    sub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sub animated:YES];
}
- (void)setDownMenu:(UIButton *)sender
{
    AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
    sub.title = @"选择好友";
    sub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sub animated:YES];
}
@end
