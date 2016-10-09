//
//  NewListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/6.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "NewListViewController.h"
#import "TheNewCell.h"
#import "MJRefresh.h"
#import "NetManger.h"
#import "EnterpriseModel.h"
#import "UIImageView+WebCache.h"
@interface NewListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NewListViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    manger.sType = self.ID;
    [manger loadData:RequestOfGetculturedocpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getculturedocpagelist" object:nil];
    [self setTableView];
}
- (void)relodatas
{
    JCKLog(@"%ld",manger.getculturedocpagelists.count);
    [self.tableView reloadData];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 130;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_tableView.header endRefreshing];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_tableView.footer endRefreshing];
    }];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return manger.getculturedocpagelists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     EnterpriseModel *model = manger.getculturedocpagelists[indexPath.row];
     contentStrData = @"测试公告";//model.summary;
     contentStr = [NSString stringWithFormat:@"内容：%@",model.Culturetent];
     normalCell.contentLabel.text = contentStr;
     normalCell.titleLab.text = model.Title;//model.title;
     normalCell.nameLab.text = @"巨烽科技有限公司";//model.author;
     normalCell.timeLab.text = [model.CreateDate substringToIndex:16];//model.listCreateDate;
     */
    EnterpriseModel *model = manger.getculturedocpagelists[indexPath.row];
    TheNewCell *cell = [TheNewCell selectedCell:tableView];
    cell.titleLab.text = model.Title;
    cell.contextLab.text = model.Culturetent;
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl]];
    UILabel *readLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-20, 5, 10, 10)];
    readLab.layer.cornerRadius = 5;
    readLab.layer.masksToBounds = YES;
    readLab.textAlignment = NSTextAlignmentCenter;
    readLab.font = [UIFont systemFontOfSize:10];
    readLab.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:readLab];
    
    return cell;
}

@end
