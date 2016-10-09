//
//  SeachFriendViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "SeachFriendViewController.h"
#import "KeyboardToolBar.h"
#import "NetManger.h"
#import "NewFriendGroupCell.h"
#import "NewFriendInfoModel.h"
#import "UIImageView+WebCache.h"
#import "JCKConversationViewController.h"
static NSString *keyword;
@interface SeachFriendViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NetManger *manger;
    UITextField *tf;
    
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SeachFriendViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    //    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 60;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [tf resignFirstResponder];
    tf = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    [manger.clouduserpagelist removeAllObjects];
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 40, 20);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [meassageBut addTarget:self action:@selector(seachBtn) forControlEvents:UIControlEventTouchDown];
        [meassageBut setTitle:@"搜索" forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.6, 25)];
    tf.placeholder = @"请输入...";
    tf.font = [UIFont systemFontOfSize:12];
    tf.backgroundColor = RGB(245, 245, 245);
    tf.layer.cornerRadius = 5;
    tf.layer.borderColor = RGB(245, 245, 245).CGColor;
    tf.layer.borderWidth = 1;
    tf.layer.masksToBounds = YES;
    tf.delegate = self;
    [KeyboardToolBar registerKeyboardToolBar:tf];
    [tf becomeFirstResponder];
    self.navigationItem.titleView = tf;
    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return manger.clouduserpagelist.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendInfoModel *model = manger.clouduserpagelist[indexPath.row];
    NewFriendGroupCell *cell = [NewFriendGroupCell selectedCell:tableView];
    cell.nameLab.text = model.EmployeeName;
    cell.subTitleLab.text = model.DeptName;
    cell.tag = [model.UserID integerValue];
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:model.PhotoURL]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewFriendGroupCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    JCKConversationViewController   *conversationVC = [[JCKConversationViewController alloc] init];
    conversationVC.conversationType = 1;
    conversationVC.targetId = [NSString stringWithFormat:@"%ld",cell.tag];
    conversationVC.ID =[NSString stringWithFormat:@"%ld",cell.tag];
    conversationVC.title = cell.nameLab.text;
    conversationVC.hidesBottomBarWhenPushed =YES;
    [[RCIM sharedRCIM] clearUserInfoCache];
    [self.navigationController pushViewController:conversationVC animated:YES];
}
- (void)popCtr
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)seachBtn
{
    if (tf.text.length != 0)
    {
        keyword = tf.text;
    }
    manger.keywork = keyword;
    [manger loadData:RequestOfGetrongclouduserpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getrongclouduserpagelist" object:nil];
}
- (void)reloadDatas
{
    [self.tableView reloadData];
}
@end
