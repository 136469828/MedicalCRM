//
//  GroupViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "GroupViewController.h"
#import "NetManger.h"
#import "MJRefresh.h"
#import "GroupListModel.h"
#import "ChatViewController.h"
@interface GroupViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation GroupViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTableView];
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfGetminediscussionlist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodas) name:@"getminediscussionlist" object:nil];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self relodas];
        [_tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
         [self relodas];
        [_tableView.mj_footer endRefreshing];
    }];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}
- (void)relodas
{
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return manger.minediscussionlist.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    GroupListModel *model = manger.minediscussionlist[indexPath.row];
    cell.textLabel.text = model.discussionName;
    cell.imageView.image = [UIImage imageNamed:@"groupIcon"];
    cell.tag = [model.ID integerValue];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    conversationVC.conversationType = ConversationType_DISCUSSION;
    conversationVC.targetId = [NSString stringWithFormat:@"%ld",cell.tag]; //这里模拟自己给自己发消息，您可以替换成其他登录的用户的UserId 110
    conversationVC.title = cell.textLabel.text;
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];

}

@end
