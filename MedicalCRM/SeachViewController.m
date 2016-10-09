//
//  SeachViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/29.
//  Copyright © 2016年 JCK. All rights reserved.
// [textView becomeFirstResponder];

#import "SeachViewController.h"
#import "KeyboardToolBar.h"
#import "NetManger.h"
#import "ProjectMangerCell.h"
#import "GetprojectpagelistModel.h"
#import "ProjectInfoController.h"
@interface SeachViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
    UITextField *tf;
    UIScrollView *mainScrollView;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SeachViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -
- (void)setTableView
{
    // setScrollView
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49)];
    mainScrollView.contentSize = CGSizeMake(746, ScreenHeight - 49);
    [self.view addSubview:mainScrollView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 746, ScreenHeight-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 30;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:RGB(239, 239, 244)];
    [mainScrollView addSubview:_tableView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [tf resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
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
    switch (self.theState) {
        case Getprojectpagelist:
        {
            return manger.getprojectpagelist.count+1;
        }
            break;
            
        default:
            break;
    }

    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.theState) {
        case Getprojectpagelist:
        {
            ProjectMangerCell *cell = [ProjectMangerCell selectedCell:tableView];
            if (indexPath.row != 0)
            {
                GetprojectpagelistModel *model = manger.getprojectpagelist[indexPath.row-1];
                cell.nameLab.text = model.ProjectName;
                cell.ProjectNo.text = model.ProjectNo;
                cell.timeLab.text = [model.CreateDate substringToIndex:16];
                cell.stateLab.text = model.StatusName;
                cell.custorLab.text = model.CustName;
                cell.successLab.text = model.SuccessRate;
                cell.priceLab.text = model.AcceptMoney;
                if ([model.StatusName isEqualToString:@"提交项目"])
                {
                    cell.nameLab.backgroundColor = RGB(250, 235, 214);
                    cell.ProjectNo.backgroundColor = RGB(250, 235, 214);
                    cell.timeLab.backgroundColor = RGB(250, 235, 214);
                    cell.stateLab.backgroundColor = RGB(250, 235, 214);
                    cell.custorLab.backgroundColor = RGB(250, 235, 214);
                    cell.successLab.backgroundColor = RGB(250, 235, 214);
                    cell.priceLab.backgroundColor = RGB(250, 235, 214);
                }
                else if ([model.StatusName isEqualToString:@"付款"])
                {
                    cell.nameLab.backgroundColor = RGB(240  , 255, 240);
                    cell.ProjectNo.backgroundColor = RGB(240  , 255, 240);
                    cell.timeLab.backgroundColor = RGB(240  , 255, 240);
                    cell.stateLab.backgroundColor = RGB(240  , 255, 240);
                    cell.custorLab.backgroundColor = RGB(240  , 255, 240);
                    cell.successLab.backgroundColor = RGB(240  , 255, 240);
                    cell.priceLab.backgroundColor = RGB(240  , 255, 240);
                    
                }
                else
                {
                    cell.nameLab.backgroundColor = RGB(240, 248, 255);
                    cell.ProjectNo.backgroundColor = RGB(240, 248, 255);
                    cell.timeLab.backgroundColor = RGB(240, 248, 255);
                    cell.stateLab.backgroundColor = RGB(240, 248, 255);
                    cell.custorLab.backgroundColor = RGB(240, 248, 255);
                    cell.successLab.backgroundColor = RGB(240, 248, 255);
                    cell.priceLab.backgroundColor = RGB(240, 248, 255);
                    
                }
                
                
                //    static NSString *allCell = @"cell";
                //    UITableViewCell *cell = nil;
                //    if (!cell) {
                //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
                //        cell.selectionStyle = UITableViewCellAccessoryNone;
                //    }
                //    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",model.CustName,model.ProjectName];
                //    cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.tag = [model.ID integerValue];
            }
            
            return cell;
        }
            break;
            
        default:
            break;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.theState) {
        case Getprojectpagelist:
        {
            if (indexPath.row != 0)
            {
                ProjectMangerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                ProjectInfoController *sub = [[ProjectInfoController alloc] init];
                sub.title = @"项目详细";
                if ([self.state isEqualToString:@"0"]) {
                    sub.isPublic = NO;
                }
                else
                {
                    sub.isPublic = YES;
                }
                sub.ID = cell.tag;
                [self.navigationController pushViewController:sub animated:YES];
            }

        }
            break;
            
        default:
            break;
    }

}
- (void)popCtr
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)seachBtn
{
    manger = [NetManger shareInstance];
    manger.sType = @"";
    manger.keywork = tf.text;
    manger.sType2 = @"";
    if ([self.state isEqualToString:@"1"])
    {
        [manger loadData:RequestOfGetpublicprojectpagelist];
    }
    else
    {
        [manger loadData:RequestOfgetprojectpagelist];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getprojectpagelist" object:nil];

}
- (void)reloadDatas
{
    [self.tableView reloadData];
}
@end
