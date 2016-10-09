//
//  StockUpInfoViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/16.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "StockUpInfoViewController.h"
#import "MJExtension.h"
#import "NetManger.h"
#import "FuntionObj.h"
#import "StockUpInfoModel.h"
@interface StockUpInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    NetManger *manger;
    NSArray *context;
    NSString *OrderNo;
    NSString *ProductName;
}
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *FlowSteps;
@property (nonatomic, strong) NSMutableArray *Details;
@end

@implementation StockUpInfoViewController
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
    manger = [NetManger shareInstance];
    manger.ID = self.ID;
    [manger loadData:RequestOfGetsellorder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getsellorder" object:nil];
}
- (void)relodatas
{
    NSDictionary *dic = (id)manger.getsellorders;
    NSString *date = [NSString stringWithFormat:@"申请时间: %@",dic[@"CreateDate"]];
    JCKLog(@"%@",dic[@"Title"]);
    NSString *CountTotal;
    NSString *TotalFee;
    NSString *CustName;
    NSString *Title;
    OrderNo = dic[@"OrderNo"];
    if ([FuntionObj isNullDic:dic Key:@"CountTotal"])
    {
        CountTotal = dic[@"CountTotal"];
    }
    else
    {
        CountTotal = @"无";
    }
    if ([FuntionObj isNullDic:dic Key:@"TotalFee"])
    {
        TotalFee = dic[@"TotalFee"];
    }
    else
    {
        TotalFee = @"无";
    }
    if ([FuntionObj isNullDic:dic Key:@"CustName"])
    {
        CustName = dic[@"CustName"];
    }
    else
    {
        CustName = @"无";
    }
    if ([FuntionObj isNullDic:dic Key:@"Title"])
    {
        Title = dic[@"Title"];
    }
    else
    {
        Title = @"无";
    }
    if (ProductName.length == 0)
    {
        ProductName = @"";
    }
    _Details = dic[@"Details"];
    ProductName = (id)_Details[0][@"ProductName"];
    context = @[ @[[NSString stringWithFormat:@"标题: %@",Title]],
                 @[[NSString stringWithFormat:@"货物名: %@",Title],
                   [NSString stringWithFormat:@"数量: %@",CountTotal],
                   [NSString stringWithFormat:@"总额(￥): %@",TotalFee]],
                 @[[NSString stringWithFormat:@"单位名: %@",CustName],[NSString stringWithFormat:@"申请人: %@",dic[@"CreatorName"]],[date substringToIndex:22]]];
    NSArray *datas = dic[@"FlowSteps"];
    for (NSDictionary *dic_obj in datas)
    {
        StockUpInfoModel *model = [StockUpInfoModel mj_objectWithKeyValues:dic_obj];
        if (!_FlowSteps)
        {
            _FlowSteps = [NSMutableArray array];
        }
        [_FlowSteps addObject:model];
        
    }

    [self setTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.view addSubview:_tableView];
    if (self.isAudit != 2)
    {
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69 - 70);
        [self setBottomView];
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
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width,ScreenHeight - 64-70);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 69, ScreenWidth, ScreenHeight - 64-70 - 69);
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
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 3;
    }
    else if (section == 3)
    {
        return _FlowSteps.count;
    }
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section // 返回组的尾宽
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 3)
    {
        static NSString *allCell = @"cell";
        UITableViewCell *cell = nil;
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
            cell.selectionStyle = UITableViewCellAccessoryNone;
        }
        if (indexPath.section == 1 && indexPath.row == 1)
        {
            cell.textLabel.textColor = [UIColor orangeColor];
        }
        if (indexPath.section == 2 && indexPath.row == 1)
        {
            cell.textLabel.textColor = RGB(56, 173, 255);
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",context[indexPath.section][indexPath.row]];
        return cell;
    }
    
    else
    {
        static NSString *allCell = @"cell";
        UITableViewCell *cell = nil;
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:allCell];
            cell.selectionStyle = UITableViewCellAccessoryNone;
        }
        StockUpInfoModel *model = _FlowSteps[indexPath.row];
        cell.textLabel.text = model.StepName;
        cell.detailTextLabel.text = model.CheckStatusName;
        return cell;
    }
}
- (void)bottomBtnAction:(UIButton *)btn
{

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
        if ([self.textView.text isEqualToString:@"请输入审批意见(可不填)"])
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
            manger.flowstepchecks = @[OrderNo,tag,@"5",@"3",self.textView.text];
            JCKLog(@"%@ %@",tag,OrderNo);
            [manger loadData:RequestOfFlowstepcheck];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popctr) name:@"flowstepcheck" object:nil];
        }

    }
    else
    {
        if ([self.textView.text isEqualToString:@"请输入审批意见(可不填)"])
        {
            self.textView.text = @"无";
        }
        manger.flowstepchecks = @[OrderNo,tag,@"5",@"3",self.textView.text];
        JCKLog(@"%@ %@",tag,OrderNo);
        [manger loadData:RequestOfFlowstepcheck];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popctr) name:@"flowstepcheck" object:nil];
    }

}
- (void)popctr
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)commentTableViewTouchInSide{
    [_tableView endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableView endEditing:YES];
}
@end
