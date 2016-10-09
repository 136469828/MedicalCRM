//
//  SubEnterpriseCultureViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "SubEnterpriseCultureViewController.h"
#import "NormalTableViewCell.h"
#import "NetManger.h"
#import "EnterpriseModel.h"
#import "WebModel.h"
#import "WebViewController.h"
#import "AnnouncementViewController.h"
#import "UIImageView+WebCache.h"
@interface SubEnterpriseCultureViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property UITableView *normalTableView;
@end

@implementation SubEnterpriseCultureViewController

// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    manger = [NetManger shareInstance];
    manger.sType = [NSString stringWithFormat:@"%ld",self.ID];
    [manger loadData:RequestOfGetculturedocpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataw) name:@"getculturedocpagelist" object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)reloadDataw
{
    [self setTableView];
    [self registerNib];
}


- (void)setTableView{
    _normalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _normalTableView.delegate = self;
    _normalTableView.dataSource = self;
    self.normalTableView.rowHeight = 118;
    self.normalTableView.backgroundColor = RGB(239, 239, 244);
    //    self.normalTableView.estimatedRowHeight = 100;
//    self.normalTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.normalTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_normalTableView];
    
}
#pragma mark - 注册Cell
- (void)registerNib{
    NSArray *registerNibs = @[@"NormalTableViewCell"];
    for (int i = 0 ; i < registerNibs.count; i++) {
        [_normalTableView registerNib:[UINib nibWithNibName:registerNibs[i] bundle:nil] forCellReuseIdentifier:registerNibs[i]];
    }
    
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return manger.getculturedocpagelists.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NormalTableViewCell *normalCell = [_normalTableView dequeueReusableCellWithIdentifier:@"NormalTableViewCell"];
    NSString *contentStrData = @"无";
    NSString *contentStr = [NSString stringWithFormat:@"内容：%@",contentStrData];
    normalCell.contentLabel.text = contentStr;
    normalCell.titleLab.text = @"无";
    normalCell.nameLab.text = @"无";
    if (manger.getculturedocpagelists.count != 0)
    {
        EnterpriseModel *model = manger.getculturedocpagelists[indexPath.row];
        contentStrData = @"测试公告";//model.summary;
        contentStr = [NSString stringWithFormat:@"内容：%@",model.Culturetent];
        normalCell.contentLabel.text = contentStr;
        normalCell.titleLab.text = model.Title;//model.title;
        normalCell.nameLab.text = @"巨烽科技有限公司";//model.author;
        normalCell.timeLab.text = [model.CreateDate substringToIndex:16];//model.listCreateDate;
        [normalCell.imgV sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl]];
        if ([model.IsRead isEqualToString:@"0"]) // 0未读
        {
            normalCell.tagImg.hidden = NO;
        }
        normalCell.tagLab.text = model.ClickUrl;
        normalCell.textLabel.textColor = [UIColor clearColor];
    }
    
    normalCell.readLab.hidden = YES;
    normalCell.readTitleLab.hidden = YES;
    normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return normalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalTableViewCell *cell = (NormalTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    AnnouncementViewController *sub = [[AnnouncementViewController alloc] init];
//    sub.titleStr = [NSString stringWithFormat:@"%@\n%@",cell.titleLab.text,cell.timeLab.text];
//    sub.context = cell.contentLabel.text;
//    sub.title = @"详细内容";
//    [self.navigationController pushViewController:sub animated:YES];
    WebModel *model = [[WebModel alloc] initWithUrl:cell.tagLab.text];
    WebViewController *SVC = [[WebViewController alloc] init];
    SVC.title = self.title;
    SVC.hidesBottomBarWhenPushed = YES;
    [SVC setModel:model];
    [self.navigationController pushViewController:SVC animated:YES];


    
}

@end
