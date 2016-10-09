//
//  AuditViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "AuditViewController.h"
#import "GetsellsamplepagelistforcheckModel.h"
#import "CostAuditingListModel.h"
#import "NetManger.h"
#import "AuditFollowCell.h"
#import "MJExtension.h"
#import "AuditFollowModel.h"
@interface AuditViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    NSArray *titles;
    NSString *costExpCode;
    
}
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) NSMutableArray *m_Details;
@end

@implementation AuditViewController
/*
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.j
    
//    JCKLog(@"%@",self.model.FlowSteps);
    if (self.stye == 0)
    {
        for (NSDictionary *dic in self.model.FlowSteps)
        {
            AuditFollowModel *model = [AuditFollowModel mj_objectWithKeyValues:dic];
            
            if (_m_datas == nil)
            {
                _m_datas = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [_m_datas addObject:model];
        }
        JCKLog( @"%ld",_m_datas.count);
        if (!self.model.CustName)
        {
            self.model.CustName = @" ";
        }
        
        titles = @[@[[NSString stringWithFormat:@"样机名: %@",self.model.ProductName],
                     [NSString stringWithFormat:@"状 态: %@",self.model.CheckStatusName],
                     @"",@""],
                   @[[NSString stringWithFormat:@"项目名: %@",self.self.model.ProjectName],
                     [NSString stringWithFormat:@"客户名: %@",self.model.CustName],
                     [NSString stringWithFormat:@"负责人: %@",self.model.CreatorName]]];
    }
    else if (self.stye == 1)
    {
        JCKLog(@"%@",self.model2);
        for (NSDictionary *dic in self.model2.FlowSteps)
        {
            CostAuditingListModel *model2 = [CostAuditingListModel mj_objectWithKeyValues:dic];
            if (_m_datas == nil)
            {
                _m_datas = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [_m_datas addObject:model2];
        }
        NSMutableArray *Details;
        for (NSDictionary *dic in self.model2.Details)
        {
            
            if (Details == nil)
            {
                Details = [[NSMutableArray alloc] initWithCapacity:0];
            }
//            if ([dic[@"ExpTypeName"] isKindOfClass:[NSNull class]])
//            {
//                [dic setValue:@"" forKey:@"ExpTypeName"];
//            }
            [Details addObject:[NSString stringWithFormat:@"%@:￥%@",dic[@"ExpTypeName"],dic[@"Amount"]]];
        }
        JCKLog( @"model2 %ld",self.model2.Details.count);
        costExpCode = self.model2.ExpCode;
        if (self.model2.Reason.length <= 0)
        {
            self.model2.Reason = @"";
        }
        if (self.model2.Title.length <= 0)
        {
            self.model2.Title = @"";
        }
        [Details componentsJoinedByString:@","];
        if ([Details isKindOfClass:[NSNull class]])
        {
            titles = @[@[[NSString stringWithFormat:@"标 题: %@",self.model2.Title],
                         [NSString stringWithFormat:@"总费用:%@",self.model2.TotalAmount]],
                       @[[NSString stringWithFormat:@"项目名: %@",self.model2.ProjectName],
                         [NSString stringWithFormat:@"申请人: %@",self.model2.CreatorName]]];

        }
        else
        {
                titles = @[@[[NSString stringWithFormat:@"标 题: %@",self.model2.Title],
                             [NSString stringWithFormat:@"总费用:%@",self.model2.TotalAmount],
                             [Details componentsJoinedByString:@","]],
                           @[[NSString stringWithFormat:@"项目名: %@",self.model2.ProjectName],
                             [NSString stringWithFormat:@"申请人: %@",self.model2.CreatorName]]];
                       
        }


    }
   
    [self setBottomView];
    [self setTableView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64-70) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tableViewGesture];
    UIView *bgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    //    bgv.backgroundColor = [UIColor whiteColor];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 8, ScreenWidth-16, 100)];
    _textView.text = @"请输入审批意见(可不填)";
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.delegate = self;
    [bgv addSubview:_textView];
    _tableView.tableFooterView = _textView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (_textView.frame.origin.y/2+_textView.frame.size.height+10) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f,-ScreenHeight*0.2, self.view.frame.size.width,ScreenHeight - 64-70);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 69, ScreenWidth, ScreenHeight-69);
    }];
}
- (void)setBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight-69 - 70, ScreenWidth, 70)];
    bottomView.backgroundColor = RGB(239, 239, 244);
    for (int i = 0; i<2; i++) {
        UIButton *bottomBtn         =
        [UIButton buttonWithType:UIButtonTypeCustom];
        
        bottomBtn.frame             =
        CGRectMake(i*(ScreenWidth/2)+10, 20, ScreenWidth/2-20, 40);
        bottomBtn.backgroundColor   =
        [UIColor orangeColor];
        [bottomBtn setTitle:@"通过" forState:UIControlStateNormal];
        if (i == 0)
        {
            [bottomBtn setTitle:@"不通过" forState:UIControlStateNormal];
            [bottomBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            bottomBtn.layer.borderWidth = 1;
            bottomBtn.layer.borderColor = [UIColor orangeColor].CGColor;
            bottomBtn.backgroundColor = [UIColor clearColor];
        }
        [bottomBtn setTintColor:[UIColor whiteColor]];
        bottomBtn.titleLabel.font   =
        [UIFont systemFontOfSize:16];
        
        bottomBtn.tag               =
        2000+i;
        
        [bottomBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        bottomBtn.layer.cornerRadius = 5;
        bottomBtn.layer.masksToBounds = YES;
        [bottomView addSubview:bottomBtn];
    }
    //    [self.view addSubview:bottomView];
    [self.view addSubview: bottomView];
}
- (void)commentTableViewTouchInSide{
    [_tableView endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableView endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        return 120;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section // 返回组的尾宽
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.stye == 1)
        {
            return 3;
        }
        else
        {
            return 2;
        }
        
    }
    else if (section == 1)
    {
        return 2;
    }
    return _m_datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.stye == 0)
    {
        if (indexPath.section != 2)
        {
            static NSString *allCell = @"cell";
            UITableViewCell *cell = nil;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
                cell.selectionStyle = UITableViewCellAccessoryNone;
            }
            if (indexPath.section == 0 && indexPath.row == 1)
            {
                cell.textLabel.textColor = [UIColor orangeColor];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",titles[indexPath.section][indexPath.row]];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(8, 44-1, ScreenWidth, 1)];
            line.backgroundColor = RGB(234, 234, 234);
            [cell.contentView addSubview:line];
            return cell;
        }
        
        AuditFollowModel *model = _m_datas[indexPath.row];
        AuditFollowCell *cell3 = [AuditFollowCell selectedCell:tableView];
        cell3.bumenLab.text = [NSString stringWithFormat:@"审批部门:%@",model.StepName];
        cell3.yijianLab.text = [NSString stringWithFormat:@"审批情况: %@",model.CheckStatusName];
        cell3.shijianLab.text = [model.ModifiedDate substringToIndex:16];
        
        return cell3;

    }
    else if (self.stye == 1)
    {
        static NSString *allCell = @"cell";
        UITableViewCell *cell = nil;
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
            cell.selectionStyle = UITableViewCellAccessoryNone;
        }
        if (indexPath.section != 2)
        {
            if (indexPath.section == 0 && indexPath.row == 1)
            {
                cell.textLabel.textColor = [UIColor orangeColor];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",titles[indexPath.section][indexPath.row]];
            cell.textLabel.numberOfLines = 0;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(8, 44-1, ScreenWidth, 1)];
            line.backgroundColor = RGB(234, 234, 234);
            [cell.contentView addSubview:line];
            return cell;
            
        }
        CostAuditingListModel *model = _m_datas[indexPath.row];
        AuditFollowCell *cell3 = [AuditFollowCell selectedCell:tableView];
        cell3.bumenLab.text = [NSString stringWithFormat:@"审批部门:%@",model.StepName];
        cell3.yijianLab.text = [NSString stringWithFormat:@"审批情况: %@",model.CheckStatusName];
        cell3.shijianLab.text = [model.AriseDate substringToIndex:16];
        
        return cell3;
    }
    return nil;
    
}
#pragma mark - textViewdelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入审批意见(可不填)"])
    {
        self.textView.text=@"";
    }
    self.textView.textColor = [UIColor blackColor];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ( self.textView.text.length == 0)
    {
        self.textView.text=@"请输入审批意见(可不填)";
        self.textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}
- (void)bottomBtnAction:(UIButton *)btn
{

    NetManger *manger = [NetManger shareInstance];
    NSString *tag;
    if (btn.tag == 2000)
    {
        tag = @"2";
    }
    else  if (btn.tag == 2001)
    {
        tag = @"0";
    }
    if ([tag isEqualToString:@"2"])
    {
        if ([_textView.text isEqualToString:@"请输入审批意见(可不填)"])
        {
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入审批意见" preferredStyle: UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        }
        else
        {
            if (self.stye == 0)
            {
                manger.flowstepchecks = @[self.ID,tag,@"5",@"11",_textView.text];
            }
            else
            {
                manger.flowstepchecks = @[costExpCode,tag,@"1",@"4",_textView.text];
            }
            JCKLog(@"%@",tag);
            
            [manger loadData:RequestOfFlowstepcheck];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popctr) name:@"flowstepcheck" object:nil];
        }
    }
    else
    {
        if ([_textView.text isEqualToString:@"请输入审批意见(可不填)"])
        {
            _textView.text =@"无";
        }
        if (self.stye == 0)
        {
            manger.flowstepchecks = @[self.ID,tag,@"5",@"11",_textView.text];
        }
        else
        {
            manger.flowstepchecks = @[costExpCode,tag,@"1",@"4",_textView.text];
        }
        JCKLog(@"%@",tag);
        
        [manger loadData:RequestOfFlowstepcheck];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popctr) name:@"flowstepcheck" object:nil];
    }
    
}
- (void)popctr
{
    [self.navigationController popViewControllerAnimated:YES];
}
 */
@end
