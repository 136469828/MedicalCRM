//
//  HistoryViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryCell.h"
#import "NetManger.h"
#import "CustcontactpagelistModel.h"
#import "MJRefresh.h"
#import "KeyboardToolBar.h"
#import "HistoryInfoViewController.h"
#import "WebModel.h"
#import "WebViewController.h"
@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
    UITextField *tf;
    int pag;
    UIScrollView *mainScrollView;

}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HistoryViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    manger.keywork = @"";
    pag = 15;
    manger.PageSize = [NSString stringWithFormat:@"%d",pag];
    [manger loadData:RequestOfGetcustcontactpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getcustcontactpagelist" object:nil];
    [self setTableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self reloadDatas];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        manger.keywork = @"";
        pag = pag +10;
        manger.PageSize = [NSString stringWithFormat:@"%d",pag];
        [manger loadData:RequestOfGetcustcontactpagelist];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getcustcontactpagelist" object:nil];
        [_tableView.mj_footer endRefreshing];
    }];
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 40, 20);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    [KeyboardToolBar registerKeyboardToolBar:tf];
    //    [tf becomeFirstResponder];
    self.navigationItem.titleView = tf;
}
- (void)reloadDatas
{
    [self.tableView reloadData];
    [self.tableView.header endRefreshing];
}

#pragma mark -
- (void)setTableView
{
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49)];
    mainScrollView.contentSize = CGSizeMake(1050, ScreenHeight - 49);
    [self.view addSubview:mainScrollView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 1050, ScreenHeight-54) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    self.tableView.estimatedRowHeight = 200;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.rowHeight = 31;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [mainScrollView addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (manger.getcustcontactpagelist.count == 0)
//    {
//        return 1;
//    }
    return manger.getcustcontactpagelist.count + 1;
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
    HistoryCell *cell = [HistoryCell selectedCell:tableView];
    if (indexPath.row != 0)
    {
        CustcontactpagelistModel *model = manger.getcustcontactpagelist[indexPath.row - 1];
        //        cell.contextLab.text = model.Contents;
        //        cell.creatorName.text = model.ProjectName;
        //        cell.addressLab.text = [NSString stringWithFormat:@"地址: %@",model.LocationAddress];
        //        cell.timeLab.text = [model.ModifiedDate substringToIndex:16];
        //        cell.nameLab.text = [NSString stringWithFormat:@"联系人: %@",model.CustLinkManName];
        cell.timeLab.text = [model.ModifiedDate substringToIndex:16];
        cell.customerLab.text = model.CustName;
        cell.creatorName.text = model.ProjectName;
        cell.nameLab.text = model.CreatorName;
        cell.priceLab.text = model.TotalAmount;
        cell.addressLab.text = model.LocationAddress;
        cell.tag = [model.CustID integerValue];
        cell.custLinkManNameLab.text = model.CustLinkManName;
        cell.nameLab.text = model.CreatorName;
        cell.contextLab.text = model.Contents;
        cell.telLab.text = model.LinkTel;
        cell.tagLab.text = model.ClickUrl;
    }

    return cell;


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
        HistoryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        HistoryInfoViewController *sub = [[HistoryInfoViewController alloc] init];
        sub.title = @"拜访详情";
        sub.ProName = cell.creatorName.text;
        sub.ID = [NSString stringWithFormat:@"%ld",cell.tag];
        [self.navigationController pushViewController:sub animated:YES];
    }
}
- (void)seachBtn
{
    manger.keywork = tf.text;
    [manger loadData:RequestOfGetcustcontactpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getcustcontactpagelist" object:nil];
}
@end
