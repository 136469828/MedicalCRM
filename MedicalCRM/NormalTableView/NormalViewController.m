//
//  NormalViewController.m
//  MangerSystem
//
//  Created by JCong on 16/2/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "NormalViewController.h"
#import "NormalTableViewCell.h"
#import "NetManger.h"
#import "GetnoticepagelistModel.h"
//#import "MJRefresh.h"
#import "AnnouncementViewController.h"
#import "KeyboardToolBar.h"
@interface NormalViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
    UITextField *tf;
}
@property UITableView *normalTableView;

@end

@implementation NormalViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNewData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    manger = [NetManger shareInstance];
//    manger.channelID = @"1002";
//    [manger loadData:RequestOfGetarticlelist];
    [self setTableView];
    [self registerNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataw) name:@"Getarticlelist" object:nil];
//    self.normalTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [self loadNewData];
//    }];
    self.normalTableView.backgroundColor = RGB(239, 239, 244);
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 40, 20);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [meassageBut addTarget:self action:@selector(seachBtn) forControlEvents:UIControlEventTouchDown];
        [meassageBut setTitle:@"搜索" forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.6, 25)];
    tf.placeholder = @"请输入...";
    tf.font = [UIFont systemFontOfSize:12];
    tf.backgroundColor = [UIColor whiteColor];
    tf.layer.cornerRadius = 5;
    tf.layer.borderColor = [UIColor whiteColor].CGColor;
    tf.layer.borderWidth = 1;
    tf.layer.masksToBounds = YES;
    [KeyboardToolBar registerKeyboardToolBar:tf];
//    [tf becomeFirstResponder];
    self.navigationItem.titleView = tf;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 页面刷新
- (void)loadNewData
{
    manger = [NetManger shareInstance];
    manger.keywork = @"";
    [manger loadData:RequestOfGetarticlelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataw) name:@"getnoticepagelist" object:nil];
//    [_normalTableView.header endRefreshing];
}
- (void)reloadDataw
{
//    [LCProgressHUD showLoading:@"正在加载"];
    [self.normalTableView reloadData];
    [self hideHUD];
}
- (void)hideHUD {
//    [LCProgressHUD hide];
}

- (void)setTableView{
    _normalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-54) style:UITableViewStylePlain];
    _normalTableView.delegate = self;
    _normalTableView.dataSource = self;
    self.normalTableView.rowHeight = 170;
//    self.normalTableView.estimatedRowHeight = 100;
    self.normalTableView.separatorStyle = UITableViewCellSelectionStyleNone;
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

    return manger.getnoticepagelist.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NormalTableViewCell *normalCell = [_normalTableView dequeueReusableCellWithIdentifier:@"NormalTableViewCell"];
    NSString *contentStrData = @"无";
    NSString *contentStr = [NSString stringWithFormat:@"内容：%@",contentStrData];
    normalCell.contentLabel.text = contentStr;
    normalCell.titleLab.text = @"无";
    normalCell.nameLab.text = @"无";
    if (manger.getnoticepagelist.count != 0)
    {
        GetnoticepagelistModel *model = manger.getnoticepagelist[indexPath.row];
        contentStrData = @"测试公告";//model.summary;
        contentStr = [NSString stringWithFormat:@"内容：%@",model.NewsContent];
        normalCell.contentLabel.text = contentStr;
        normalCell.titleLab.text = model.NewsTitle;//model.title;
        normalCell.nameLab.text = @"系统公告";//model.author;
        normalCell.timeLab.text = [model.ComfirmDate substringToIndex:16];//model.listCreateDate;
        normalCell.tag = [model.ID integerValue];
        if ([model.isRead isEqualToString:@"0"])
        {
            normalCell.tagImg.hidden = NO;
        }
        normalCell.readLab.text = model.ReadCount;
    }

    normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return normalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalTableViewCell *cell = (NormalTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    AnnouncementViewController *sub = [[AnnouncementViewController alloc] init];
    sub.titleStr = [NSString stringWithFormat:@"%@\n%@",cell.titleLab.text,cell.timeLab.text];
    sub.context = cell.contentLabel.text;
    sub.title = @"详细内容";
    manger.ID = [NSString stringWithFormat:@"%ld",cell.tag];
    [manger loadData:RequestOfReadsave];
    [self.navigationController pushViewController:sub animated:YES];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)seachBtn
{
    manger.keywork = tf.text;
    [manger loadData:RequestOfGetarticlelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataw) name:@"getnoticepagelist" object:nil];
}
@end
