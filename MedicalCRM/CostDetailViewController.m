//
//  CostDetailViewController.m
//  MedicalCRM
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "CostDetailViewController.h"
#import "TheNewSignin4Cell.h"
#import "KeyboardToolBar.h"
#import "CostDetailModel.h"
@interface CostDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    CostDetailModel *model;
}
@property (nonnull, strong) UITableView *tableView;
@end

@implementation CostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    model = [CostDetailModel shareInstance];
    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = 44;

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
#pragma mark - UITableViewDataSource

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isTravelOrOther)
    {
        return 8;
    }
    else
    {
        return 6;
    }
    
}
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TheNewSignin4Cell *cell = [TheNewSignin4Cell selectedCell:tableView];
    if (_isTravelOrOther)
    {
        switch (indexPath.row) {
            case 0:
            {
                cell.titleLab.text = @"物流(快递)";
                if (model.logistics)
                {
                    cell.costTf.text = model.logistics;
                }
                
            }
                break;
            case 1:
            {
                cell.titleLab.text = @"打印";
                
                if (model.print)
                {
                    cell.costTf.text = model.print;
                }
            }
                break;
            case 2:
            {
                cell.titleLab.text = @"标书制作";
                
                if (model.bidToMake)
                {
                    cell.costTf.text = model.bidToMake;
                }
            }
                break;
            case 3:
            {
                cell.titleLab.text = @"办公用品";
                
                if (model.officeSupplies)
                {
                    cell.costTf.text = model.officeSupplies;
                }
            }
                break;
            case 4:
            {
                cell.titleLab.text = @"外购物品";
                
                if (model.purchaseditems)
                {
                    cell.costTf.text = model.purchaseditems;
                }
            }
                break;
            case 5:
            {
                cell.titleLab.text = @"通讯补贴";
                
                if (model.communicationallowance)
                {
                    cell.costTf.text = model.communicationallowance;
                }
            }
                break;
            case 6:
            {
                cell.titleLab.text = @"交通补贴";
                
                if (model.trafficSubsidies)
                {
                    cell.costTf.text = model.trafficSubsidies;
                }
            }
                break;
            case 7:
            {
                cell.titleLab.text = @"住房补贴";
                
                if (model.housingSubsidies)
                {
                    cell.costTf.text = model.housingSubsidies;
                }
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {
                cell.titleLab.text = @"飞机";
                
                if (model.planeCost)
                {
                    cell.costTf.text = model.planeCost;
                }
            }
                break;
            case 1:
            {
                cell.titleLab.text = @"长途车船";
                
                if (model.longDistanceTransport)
                {
                    cell.costTf.text = model.longDistanceTransport;
                }
            }
                break;
            case 2:
            {
                cell.titleLab.text = @"住宿费";
                
                
                if (model.accommodation)
                {
                    cell.costTf.text = model.accommodation;
                }
            }
                break;
            case 3:
            {
                cell.titleLab.text = @"路桥";
                cell.costTf.text = model.luqiao;
                if (model.luqiao)
                {
                    cell.costTf.text = model.luqiao;
                }
            }
                break;
            case 4:
            {
                cell.titleLab.text = @"出差地交通";
                
                if (model.onAbusinessTripToTheTraffic)
                {
                    cell.costTf.text = model.onAbusinessTripToTheTraffic;
                }
            }
                break;
            case 5:
            {
                cell.titleLab.text = @"出差补助";
                
                if (model.onAbusinessTripAllowance)
                {
                    cell.costTf.text = model.onAbusinessTripAllowance;
                }
            }
                break;
                
            default:
                break;
        }
    }
    cell.costTf.delegate = self;
//    cell.rightTf.delegate = self;
//    if (_isTravelOrOther)
//    {
//        cell.costTf.tag = indexPath.row;
//    }
//    else
//    {
//        cell.costTf.tag = indexPath.row+6;
//    }
    cell.costTf.tag = indexPath.row;
    [KeyboardToolBar registerKeyboardToolBar:cell.costTf];
//    [KeyboardToolBar registerKeyboardToolBar:cell.rightTf];
    return cell;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (!_isTravelOrOther)
    {
        switch (textField.tag)
        {
            case 0:
            {
                model.planeCost = textField.text;
            }
                break;
            case 1:
            {
                model.longDistanceTransport = textField.text;
            }
                break;
            case 2:
            {
                model.accommodation = textField.text;
            }
                break;
            case 3:
            {
                model.luqiao = textField.text;
            }
                break;
            case 4:
            {
                model.onAbusinessTripToTheTraffic = textField.text;
            }
                break;
            case 5:
            {
                model.onAbusinessTripAllowance = textField.text;
            }
                break;
            default:
                break;
        }

    }
    else
    {
        switch (textField.tag)
        {
            case 0:
                {
                    model.logistics = textField.text;
                }
                break;
            case 1:
                {
                    model.print = textField.text;
                }
                break;
            case 2:
                {
                    model.bidToMake = textField.text;
                }
                break;
            case 3:
                {
                    model.officeSupplies = textField.text;
                }
                break;
            case 4:
                {
                    model.purchaseditems = textField.text;
                }
                break;
            case 5:
                {
                    model.communicationallowance = textField.text;
                }
                break;
            case 6:
                {
                    model.trafficSubsidies = textField.text;
                }
                break;
            case 7:
                {
                    model.housingSubsidies = textField.text;
                }
                break;
            default:
                break;
        }

    }
//    switch (textField.tag)
//    {
//        case 0:
//        {
//            model.planeCost = textField.text;
//        }
//            break;
//        case 1:
//        {
//            model.longDistanceTransport = textField.text;
//        }
//            break;
//        case 2:
//        {
//            model.accommodation = textField.text;
//        }
//            break;
//        case 3:
//        {
//            model.luqiao = textField.text;
//        }
//            break;
//        case 4:
//        {
//            model.onAbusinessTripToTheTraffic = textField.text;
//        }
//            break;
//        case 5:
//        {
//            model.onAbusinessTripAllowance = textField.text;
//        }
//            break;
//        case 6:
//        {
//            model.logistics = textField.text;
//        }
//            break;
//        case 7:
//        {
//            model.print = textField.text;
//        }
//            break;
//        case 8:
//        {
//            model.bidToMake = textField.text;
//        }
//            break;
//        case 9:
//        {
//            model.officeSupplies = textField.text;
//        }
//            break;
//        case 10:
//        {
//            model.purchaseditems = textField.text;
//        }
//            break;
//        case 11:
//        {
//            model.communicationallowance = textField.text;
//        }
//            break;
//        case 12:
//        {
//            model.trafficSubsidies = textField.text;
//        }
//            break;
//        case 13:
//        {
//            model.housingSubsidies = textField.text;
//        }
//            break;
//            
//        default:
//            break;
//    }
    return YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.costDetailblock)
    {
        self.costDetailblock(model);
    }
}
- (void)popCtrView
{
//    if (self.costDetailblock)
//    {
//        self.costDetailblock(model);
//    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
