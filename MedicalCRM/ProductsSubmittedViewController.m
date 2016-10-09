//
//  ProductsSubmittedViewController.m
//  MedicalCRM
//
//  Created by admin on 16/9/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProductsSubmittedViewController.h"
#import "EquipmentListViewController.h"
#import "KeyboardToolBar.h"
@interface ProductsSubmittedViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSArray *titles;
    
    NSString *productName;
    NSString *productID;
    NSString *productPrice;
    NSString *productCount;
    BOOL isAdd;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ProductsSubmittedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titles = @[@"产品名:",@"数量:",@"单价:"];
    [self setTableView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-65 - 64, ScreenWidth, 60)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40,10,ScreenWidth-80,40);
    btn.backgroundColor = [UIColor orangeColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popCtrView) forControlEvents:UIControlEventTouchDown];
    [bg addSubview:btn];
    //    [self.view addSubview:bg];
    _tableView.tableFooterView = bg;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth*0.3, 0, ScreenWidth-ScreenWidth*0.3-10, 30)];
    tf.delegate = self;
    [KeyboardToolBar registerKeyboardToolBar:tf];
    tf.font = [UIFont systemFontOfSize:13];
    tf.placeholder = @"点击填写";
    tf.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:tf];
    if (indexPath.row == 0)
    {
        tf.hidden = YES;
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.35, 0, ScreenWidth-ScreenWidth*0.35-10, 30)];
        lb.font = [UIFont systemFontOfSize:13];
        lb.textAlignment = NSTextAlignmentRight;
        lb.textColor = [UIColor lightGrayColor];
        //                    lb.tag = 1010110;
        lb.text = @"请选择";
        if (productName)
        {
            lb.text = productName;
            lb.textColor = [UIColor blackColor];
        }
        else
        {
            lb.textColor = [UIColor lightGrayColor];
        }
        [cell.contentView addSubview:lb];
    }
    else if (indexPath.row == 1)
    {
        if (productPrice) {
            tf.text = productPrice;
        }
    }
    else if (indexPath.row == 2)
    {
        if (productCount) {
            tf.text = productCount;
        }
    }
    tf.tag = 10 + indexPath.row;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        EquipmentListViewController *sub = [[EquipmentListViewController alloc] init];
        sub.title = @"选择样机名";
        sub.block = ^(NSArray *demoName,NSArray *demoIDs)
        {
            NSString *ns=[demoName componentsJoinedByString:@","];
            productName = ns;
            productID = demoIDs[0];
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:sub animated:YES];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 11:
        {
            productPrice = textField.text;
        }
            break;
        case 12:
        {
            productCount = textField.text;
        }
            break;
            
        default:
            break;
    }
    return YES;
}
- (void)popCtrView
{
    isAdd = YES;
    if (self.productsblock)
    {
        self.productsblock(productName,productID,productPrice,productCount,isAdd);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
