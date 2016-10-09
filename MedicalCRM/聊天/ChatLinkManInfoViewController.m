//
//  ChatLinkManInfoViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/21.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ChatLinkManInfoViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "FriendListRightCell.h"
#import "UIImageView+WebCache.h"
#import "ChatViewController.h"
#import "NetManger.h"
#import "AddFriendListViewController.h"
@interface ChatLinkManInfoViewController ()<UITableViewDataSource,UITableViewDelegate,RCIMUserInfoDataSource,UISearchControllerDelegate>
{
    NSArray *data;
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) NSMutableArray *m_datas2;
@property (nonatomic, strong) NSMutableArray *m_datas3;
@end

@implementation ChatLinkManInfoViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    [_m_datas removeAllObjects];
    [[RCIM sharedRCIM] getDiscussion:self.groupID success:^(RCDiscussion *discussion)
     {
             JCKLog(@"%@",discussion.memberIdList);
             self.datas = discussion.memberIdList;
//             [[RCIM sharedRCIM] setUserInfoDataSource:self];
         JCKLog(@"%ld",self.datas.count);
         for (int i = 0; i < self.datas.count; i++)
         {
//             JCKLog(@"%@",self.datas[i]);
             [[[RCIM sharedRCIM] userInfoDataSource] getUserInfoWithUserId:[NSString stringWithFormat:@"%@",self.datas[i]] completion:^(RCUserInfo *userInfo)
              {
                  JCKLog(@"%@",userInfo);
                   if (_m_datas.count == 0)
                   {
                       _m_datas = [[NSMutableArray alloc] initWithCapacity:0];
                   }
                  if (userInfo != nil)
                  {
                      [_m_datas addObject:[NSString stringWithFormat:@"%@|%@|%@",userInfo.name,userInfo.userId,userInfo.portraitUri]];
                  }
              }];
         }
        JCKLog(@"%@",_m_datas);
         
     } error:^(RCErrorCode status)
     {
         JCKLog(@"%ld",(long)status);
     }];
    [self setTableView];
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 20, 20);
        [meassageBut addTarget:self action:@selector(pushAddCtr) forControlEvents:UIControlEventTouchDown];
        [meassageBut setImage:[UIImage imageNamed:@"addIcon"]forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;

}
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{

}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
//    self.tableView.rowHeight = 60;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width
//                                                                           , 44)];
//    searchBar.placeholder = @"搜索";
//    
//    // 添加 searchbar 到 headerview
//    self.tableView.tableHeaderView = searchBar;
//    
//    // 用 searchbar 初始化 SearchDisplayController
//    // 并把 searchDisplayController 和当前 controller 关联起来
//    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    
//    // searchResultsDataSource 就是 UITableViewDataSource
//    searchDisplayController.searchResultsDataSource = self;
//    // searchResultsDelegate 就是 UITableViewDelegate
//    searchDisplayController.searchResultsDelegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        return 60;
    }
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        return _m_datas.count;
    }else{
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        filterData =  [[NSArray alloc] initWithArray:[_m_datas filteredArrayUsingPredicate:predicate]];
        return filterData.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == self.tableView) {
        NSArray *array = [[NSString stringWithFormat:@"%@",_m_datas[indexPath.row]] componentsSeparatedByString:@"|"]; //从字符A中分隔成2个元素的数组
        FriendListRightCell *cell = [FriendListRightCell selectedCell:tableView];
        cell.nameLab.text = [NSString stringWithFormat:@"%@",array[0]];
        cell.tagLab.hidden= YES;
        cell.selectedBtn.hidden = YES;
        //    JCKLog(@"%@",user.portraitUri);
        cell.hearImg.layer.cornerRadius = 5;
        cell.hearImg.layer.masksToBounds= YES;
        NSString *str = [NSString stringWithFormat:@"%@",array[2]];
        if (str.length > 6)
        {
            [cell.hearImg sd_setImageWithURL:[NSURL URLWithString:str]];
        }
        cell.tag = [array[1] integerValue];
        return cell;
    }else{
        NSArray *array = [[NSString stringWithFormat:@"%@",filterData[indexPath.row]] componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
        FriendListRightCell *cell = [FriendListRightCell selectedCell:tableView];
        cell.nameLab.text = [NSString stringWithFormat:@"%@",array[0]];
        cell.tagLab.hidden= YES;
        cell.selectedBtn.hidden = YES;
        //    JCKLog(@"%@",user.portraitUri);
        cell.hearImg.layer.cornerRadius = 5;
        cell.hearImg.layer.masksToBounds= YES;
        NSString *str = [NSString stringWithFormat:@"%@",array[2]];
        if (str.length > 6)
        {
            [cell.hearImg sd_setImageWithURL:[NSURL URLWithString:str]];
        }
        cell.tag = [array[1] integerValue];
        return cell;

    }



}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendListRightCell *cell = (FriendListRightCell *)[tableView cellForRowAtIndexPath:indexPath];
    ChatViewController   *conversationVC = [[ChatViewController alloc] init];
    conversationVC.conversationType = 1;
    conversationVC.targetId = [NSString stringWithFormat:@"%ld",cell.tag];
    conversationVC.ID = [NSString stringWithFormat:@"%ld",cell.tag];
    conversationVC.title = cell.nameLab.text;
    conversationVC.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
- (void)pushAddCtr
{
    AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
    sub.title = @"选择添加的好友";
    sub.isNogroup = 2;
    sub.ID = self.groupID;
    [self.navigationController pushViewController:sub animated:YES];

}
@end
