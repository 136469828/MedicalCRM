//
//  ImportantItemsBulidViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ImportantItemsBulidViewController.h"
#import "KeyboardToolBar.h"
#import "NetManger.h"
#import "AddFriendListViewController.h"
@interface ImportantItemsBulidViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    NSArray *data_ID;
}
@end

@implementation ImportantItemsBulidViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tv.font = [UIFont systemFontOfSize:13];
    self.tv.text = @"请输入发布的内容...";
    self.tv.textColor = [UIColor lightGrayColor];
    self.tv.delegate = self;
    [KeyboardToolBar registerKeyboardToolBar: self.titleTf];
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tableViewGesture];
    [self.btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchDown];
    [self.MembersBtn addTarget:self action:@selector(addMembersBtn) forControlEvents:UIControlEventTouchDown];
}
#pragma mark - textViewdelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.tv.text isEqualToString:@"请输入发布的内容..."])
    {
        self.tv.text=@"";
    }
    self.tv.textColor = [UIColor blackColor];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ( self.tv.text.length == 0)
    {
        self.tv.text=@"请输入发布的内容...";
        self.tv.textColor = [UIColor lightGrayColor];
    }
    return YES;
}
- (void)commentTableViewTouchInSide{
    [self.tv endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tv endEditing:YES];
}
- (void)btnAction
{
    if (self.tv.text.length == 0 || [self.tv.text isEqualToString:@"请输入发布的内容..."] || self.titleTf.text.length == 0 || !data_ID)
    {
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"部分信息为空,请补全" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    else
    {
        NetManger *manger = [NetManger shareInstance];
        manger.title = self.titleTf.text;
        manger.context = self.tv.text;
        manger.canViewUsers = [data_ID componentsJoinedByString:@","];
        [manger loadData:RequestOfPersonaldatearrangesave];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCtr) name:@"personaldatearrangesave" object:nil];
    }
    
    
}
- (void)popCtr
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addMembersBtn
{
    AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
    sub.title = @"选择相关人员";
    sub.isNogroup = 1;
    sub.hidesBottomBarWhenPushed = YES;
    sub.block = ^(NSArray *datas,NSArray *IDdatas)
    {
//        JCKLog(@"%@",datas);
        self.MembersLab.text = [datas componentsJoinedByString:@","];
        data_ID = IDdatas;
    };
    [self.navigationController pushViewController:sub animated:YES];
}
@end
