//
//  OftenUseLinkViewController.m
//  MedicalCRM
//
//  Created by admin on 16/9/26.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "OftenUseLinkViewController.h"
#import "FriendListViewController.h"
#import "AddFriendViewController.h"
#import "SVProgressHUD.h"
#import "ChatViewController.h"
#import "NetManger.h"
#import "FriendListModel.h"
#import "AddFriendListViewController.h"
#import "NewGroupListCtr.h"
#import "FriendListModel.h"
#import "NewFriendInfoModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "SeachFriendViewController.h"


#import "JCKConversationViewController.h"

#import "AuditListViewController.h"
#import "ExhibitionListViewController.h"
#import "ProjectBuildViewController.h"
#import "DemoMachineSaveController.h"
#import "TheNewCustomerListController.h"
#import "CLDropDownMenu.h"
@interface OftenUseLinkViewController ()<RCIMUserInfoDataSource,UIActionSheetDelegate>
{
    NetManger *manger;
}

@end

@implementation OftenUseLinkViewController

// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self.conversationListTableView.header endRefreshing];
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
    JCKConversationViewController   *conversationVC = [[JCKConversationViewController alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.ID = model.targetId;
    conversationVC.title = model.conversationTitle;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)btnAction
{

    AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
    sub.title = @"选择好友";
    sub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sub animated:YES];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
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
