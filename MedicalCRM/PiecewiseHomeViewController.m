//
//  PiecewiseHomeViewController.m
//  MedicalCRM
//
//  Created by admin on 16/9/7.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "PiecewiseHomeViewController.h"
#import "HomeLeftView.h"
#import "HomeRightView.h"
#import "AddFriendListViewController.h"
#import "CLDropDownMenu.h"
#import "NetManger.h"
#import "SVProgressHUD.h"
#import "CostDetailModel.h"
@interface PiecewiseHomeViewController ()
{
    NetManger *manger;
}
@end

@implementation PiecewiseHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    manger = [NetManger shareInstance];
    if (![manger.userCode isEqualToString:manger.otherUserCode])
    {
        self.title = [NSString stringWithFormat:@"%@的工作",manger.otherUserName];
        UIButton *settingBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingBtn2 addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
        [settingBtn2 setTitle:@"退出" forState:UIControlStateNormal];
        settingBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
        [settingBtn2 sizeToFit];
        [settingBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        settingBtn2.frame = CGRectMake(0, 0, 60, 25);
        UIBarButtonItem *settingBtnItem2 = [[UIBarButtonItem alloc] initWithCustomView:settingBtn2];
        self.navigationItem.rightBarButtonItems  = @[settingBtnItem2];
    }
    else
    {
        self.title = @"工作";
        UIButton *settingBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingBtn2 addTarget:self action:@selector(setDownMenu:) forControlEvents:UIControlEventTouchUpInside];
        [settingBtn2 setImage:[UIImage imageNamed:@"menu_gruops"] forState:UIControlStateNormal];
        [settingBtn2 sizeToFit];
        settingBtn2.frame = CGRectMake(0, 0, 35, 35);
        UIBarButtonItem *settingBtnItem2 = [[UIBarButtonItem alloc] initWithCustomView:settingBtn2];
        self.navigationItem.rightBarButtonItems  = @[settingBtnItem2];
    }
    [CostDetailModel tearDown];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HomeLeftView *leftV = [[HomeLeftView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.25, ScreenHeight-69)];
    [self.view addSubview:leftV];
    
    HomeRightView *rightV = [[HomeRightView alloc]initWithFrame:CGRectMake(ScreenWidth*0.25,0,ScreenWidth-(ScreenWidth*0.25+1),ScreenHeight-120)];
    [self.view addSubview:rightV];
    
    leftV.blk = ^(NSInteger index){
        [rightV changeData:index];
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setDownMenu:(UIButton *)sender
{
        AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
        sub.title = @"选择好友";
        sub.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sub animated:YES];
    
//    CLDropDownMenu *dropMenu = [[CLDropDownMenu alloc] initWithBtnPressedByWindowFrame:CGRectMake(ScreenWidth-110, -50, 100, 40) Pressed:^(NSInteger index) {
//        
//        NSLog(@"点击了第%ld个btn",index);
//        switch (index) {
//            case 0:
//            {
//                AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
//                sub.title = @"选择好友";
//                sub.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:sub animated:YES];
//            }
//                break;
//            default:
//                break;
//        }
//        sender.selected = !sender.selected;
//        
//    }];
//    
//    dropMenu.direction = CLDirectionTypeBottom;
//    dropMenu.titleList = @[@"创建聊天"];
//    
//    if (!sender.selected)
//    {
//        [self.view addSubview:dropMenu];
//        sender.selected = !sender.selected;
//    }
//    else
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeMenu" object:nil];
//        sender.selected = !sender.selected;
//    }
}
- (void)exitAction
{
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否退出%@的工作",manger.otherUserName] preferredStyle: UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"已退出"];
        //点击按钮的响应事件；
        manger.otherUserCode = manger.userCode;
        manger.userOtherID = manger.userID;
        [self viewWillAppear:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
@end
