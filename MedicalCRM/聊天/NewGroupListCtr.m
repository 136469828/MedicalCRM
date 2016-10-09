//
//  NewGroupListCtr.m
//  MedicalCRM
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "NewGroupListCtr.h"
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
@interface NewGroupListCtr ()<RCIMUserInfoDataSource,UIActionSheetDelegate>
{
    NetManger *manger;
}
@end
@implementation NewGroupListCtr
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    
    //此处为了演示写了一个用户信息
    if ([@"3" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"3";
        user.name = @"王显宁";
        //                user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
        
        return completion(user);
    }
    else if([@"4" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"4";
        user.name = @"熊国和";
        //                user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
        return completion(user);
    }
    else if([@"7" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"7";
        user.name = @"王健林";
        //                user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
        return completion(user);
    }
    else if([@"2" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"2";
        user.name = @"马云";
        //                user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
        return completion(user);
    }
    else if([@"1" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"1";
        user.name = @"汪志红";
        //                user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
        return completion(user);
    }
    return completion(nil);
}
-(void)viewDidLoad
{
    //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
//    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    [super viewDidLoad];
    //    [self loginRongCloud];

    [self setDisplayConversationTypes:@[@(ConversationType_DISCUSSION)]];

    self.conversationListTableView.tableFooterView = [UIView new];
    
    UIButton *settingBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn2 addTarget:self action:@selector(enterTeamCard:) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn2 setImage:[UIImage imageNamed:@"tianjiaIcon"] forState:UIControlStateNormal];
    [settingBtn2 sizeToFit];
    settingBtn2.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *settingBtnItem2 = [[UIBarButtonItem alloc] initWithCustomView:settingBtn2];
    
    
    self.navigationItem.rightBarButtonItems  = @[settingBtnItem2];
    
    UIView *seachView = [[UIView alloc]
                         initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    //    seachView.backgroundColor = [UIColor redColor];
    
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seachBtn.frame = CGRectMake(10,5,ScreenWidth-20,25);
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

    
    self.conversationListTableView.tableHeaderView = seachView;
    
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
    ChatViewController   *conversationVC = [[ChatViewController alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.ID = model.targetId;
    conversationVC.title = model.conversationTitle;
    conversationVC.hidesBottomBarWhenPushed =YES;
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
    switch (buttonIndex)
    {
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
    
}
@end
