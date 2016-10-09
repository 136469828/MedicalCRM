//
//  AdvicesendpagelistViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 JCK. All rights reserved.
//RequestOfGetpersonaladvicesendpagelist

#import "AdvicesendpagelistViewController.h"
#import "MJExtension.h"
#import "NetManger.h"
#import "MJRefresh.h"
#import "Advicesendpagelistodel.h"
#import "AdviceListCell.h"
#import "AnnouncementViewController.h"
#import "FeedbackController.h"
#import "FeedbackProductController.h"
#import "WebModel.h"
#import "WebViewController.h"
@interface AdvicesendpagelistViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger x;
    NetManger *manger;
    BOOL isNoFirstLoad;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) UIView *line;
@end

@implementation AdvicesendpagelistViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
//    if (isNoFirstLoad)
//    {
//        [manger loadData:RequestOfGetpersonaladvicesendpagelist];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getpersonaladvicesendpagelist" object:nil];
//        [self setTableView];
//    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance]; // 1 产品 2商务 3技术
    manger.sType = @"1";
    [manger loadData:RequestOfGetpersonaladvicesendpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getpersonaladvicesendpagelist" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodata2) name:@"personaladvicesendsave" object:nil];
    
     [self setTableView];
}
- (void)relodata2
{
    [manger loadData:RequestOfGetpersonaladvicesendpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getpersonaladvicesendpagelist" object:nil];
    [self setTableView];
}
- (void)relodatas
{
    [_m_datas removeAllObjects];
    for (NSDictionary *dic in manger.getpersonaladvicesendpagelist)
    {
        Advicesendpagelistodel *model = [Advicesendpagelistodel mj_objectWithKeyValues:dic];
        if (!_m_datas) {
            _m_datas = [NSMutableArray array];
        }
        [_m_datas addObject:model];
    }
    [_tableView reloadData];

#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 20, 20);
        [meassageBut addTarget:self action:@selector(pushBulidCtr) forControlEvents:UIControlEventTouchDown];
        [meassageBut setImage:[UIImage imageNamed:@"addIcon"]forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
}

#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_tableView.mj_header endRefreshing];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_tableView.footer endRefreshing];
    }];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    NSArray *registerNibs = @[@"NormalTableViewCell"];
    for (int i = 0 ; i < registerNibs.count; i++) {
        [_tableView registerNib:[UINib nibWithNibName:registerNibs[i] bundle:nil] forCellReuseIdentifier:registerNibs[i]];
    }
    NSArray *titleArray = @[@"产品意见",@"商务意见",@"技术意见",@"服务意见",@"其他意见"];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 34)];
//    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
//    bgV.backgroundColor = [UIColor whiteColor];
//    [topView addSubview:bgV];
//    
////    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 40, 40)];
////    imgv.image = [UIImage imageNamed:@"icon_1024"];
////    [bgV addSubview:imgv];
//    
//    UIButton *bulidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    bulidBtn.frame = CGRectMake(ScreenWidth-100, 8, 90, 30);
//    bulidBtn.backgroundColor = RGB(18, 181, 242);
//    bulidBtn.layer.cornerRadius = 8;
//    bulidBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [bulidBtn setTitle:@"发表意见" forState:UIControlStateNormal];
//    [bulidBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [bulidBtn addTarget:self action:@selector(pushBulidCtr) forControlEvents:UIControlEventTouchDown];
//    [bgV addSubview:bulidBtn];
    
    for (int i = 0; i<5; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*ScreenWidth/5, 0, ScreenWidth/5-1, 30);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(productAction:) forControlEvents:UIControlEventTouchDown];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [topView addSubview:btn];
    }
    self.line = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth/5)*x, 34-2, ScreenWidth/5, 2)];
    self.line.backgroundColor = [UIColor orangeColor];
    [topView addSubview:self.line];
    _tableView.tableHeaderView = topView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _m_datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdviceListCell *normalCell = [AdviceListCell selectedCell:tableView];
    NSString *contentStrData = @"无";
    NSString *contentStr = [NSString stringWithFormat:@"内容：%@",contentStrData];
    normalCell.contextLab.text = contentStr;
    normalCell.titleLab.text = @"无";
//    normalCell.nameLab.text = @"无";
    if (_m_datas.count != 0)
    {
        Advicesendpagelistodel *model = _m_datas[indexPath.row];
        contentStrData = @"测试公告";//model.summary;
        contentStr = [NSString stringWithFormat:@"内容：%@",model.Content];
        normalCell.contextLab.text = contentStr;
        normalCell.titleLab.text = model.Title;//model.title;
//        normalCell.nameLab.hidden = YES;//model.author;
        normalCell.timeLab.text = [model.CreateDate substringToIndex:16];//model.listCreateDate;
        normalCell.tag = [model.ID integerValue];
//        normalCell.imgV.image = [UIImage imageNamed:@"yijian"];
//        normalCell.imgV.contentMode = UIViewContentModeScaleToFill;
    }
//    normalCell.readLab.hidden = YES;
//    normalCell.readTitleLab.hidden = YES;
    normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return normalCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isNoFirstLoad = YES;
    AdviceListCell *cell = (AdviceListCell*)[tableView cellForRowAtIndexPath:indexPath];
//    AnnouncementViewController *sub = [[AnnouncementViewController alloc] init];
//    sub.titleStr = [NSString stringWithFormat:@"%@\n%@",cell.titleLab.text,cell.timeLab.text];
//    sub.context = cell.contextLab.text;
    
//    cell.tag;
    NSString *url = [NSString stringWithFormat:@"http://beaconapi.meidp.com/Mobi/office/PersonalAdviceSend?Id=%@",[NSString stringWithFormat:@"%ld",cell.tag]];
    WebModel *model = [[WebModel alloc] initWithUrl:url];
    WebViewController *sub = [[WebViewController alloc] init];
    if ([manger.sType isEqualToString:@"1"])
    {
        sub.title = @"产品意见详细内容";
    }
    else if ([manger.sType isEqualToString:@"2"])
    {
        sub.title = @"商务意见详细内容";
    }
    else if ([manger.sType isEqualToString:@"3"])
    {
        sub.title = @"技术意见详细内容";
    }
    else if ([manger.sType isEqualToString:@"4"])
    {
        sub.title = @"技术意见详细内容";
    }
    else if ([manger.sType isEqualToString:@"5"])
    {
        sub.title = @"技术意见详细内容";
    }
    sub.hidesBottomBarWhenPushed = YES;
    [sub setModel:model];
    [self.navigationController pushViewController:sub animated:YES];
    
}
- (void)pushBulidCtr
{
    if (x == 0)
    {
        FeedbackProductController *sub = [[FeedbackProductController alloc] init];
        sub.title = @"提交产品意见";
        sub.stpy = @"1";
        [self.navigationController pushViewController:sub animated:YES];

    }
    else if (x == 1)
    {
        FeedbackController *sub = [[FeedbackController alloc] init];
        sub.title = @"提交商务意见";
        sub.stpy = @"2";
        [self.navigationController pushViewController:sub animated:YES];
    }
    else if (x == 2)
    {
        FeedbackController *sub = [[FeedbackController alloc] init];
        sub.title = @"提交技术意见";
        sub.stpy = @"3";
        [self.navigationController pushViewController:sub animated:YES];
    }
    else if (x == 3)
    {
        FeedbackController *sub = [[FeedbackController alloc] init];
        sub.title = @"提交服务意见";
        sub.stpy = @"4";
        [self.navigationController pushViewController:sub animated:YES];
    }
    else if (x == 4)
    {
        FeedbackController *sub = [[FeedbackController alloc] init];
        sub.title = @"提交其他意见";
        sub.stpy = @"5";
        [self.navigationController pushViewController:sub animated:YES];
    }

}
- (void)productAction:(UIButton *)btn
{
    x = btn.tag-100;
    switch (btn.tag) {
        case 100:
        {
            manger.sType = @"1";
        }
            break;
        case 101:
        {
            manger.sType = @"2";
        }
            break;
        case 102:
        {
            manger.sType = @"3";
        }
            break;
        case 103:
        {
            manger.sType = @"4";
        }
            break;
        case 104:
        {
            manger.sType = @"5";
        }
            break;
            
        default:
            break;
    }
    [manger loadData:RequestOfGetpersonaladvicesendpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getpersonaladvicesendpagelist" object:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.line.frame = CGRectMake((ScreenWidth/5)*x, 34-2, ScreenWidth/5,2);
    }];
}
@end
