//
//  PasswordViewController.m
//  ManagementSystem
//
//  Created by admin on 16/3/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "PasswordViewController.h"
#import "NetManger.h"
#import "SVProgressHUD.h"
@interface PasswordViewController ()<UITextFieldDelegate>

@end

@implementation PasswordViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.theNewPassword.delegate = self;
    self.theNewPassword.secureTextEntry = YES;

    self.theOldPassword.delegate = self;
    self.theOldPassword.secureTextEntry = YES;
    self.btn.layer.cornerRadius = 5;
    [self.btn addTarget:self action:@selector(updatepassword) forControlEvents:UIControlEventTouchDown];
    
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
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"textField.tex %@",textField.text);
    return YES;
}

- (void)updatepassword
{
    if ([self.theNewPassword.text isEqualToString:self.againTf.text])
    {
        [SVProgressHUD showWithStatus:@"正在加载"];
        if (self.theOldPassword.text.length == 0 || self.theNewPassword.text.length == 0)
        {
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请正确输入" preferredStyle: UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        }
        else
        {
            NetManger *manger = [NetManger shareInstance];
            manger.oldPword = self.theOldPassword.text;
            manger.passwordOfnew = self.theNewPassword.text;
            [manger loadData:RequestOfUpdatepassword];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUpdatepassword:) name:@"updatepassword" object:nil];
        }

    }
    else
    {
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入不一致,请重新输入" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        self.againTf.text = @"";
    }
    
    
}
- (void)showUpdatepassword:(NSNotification*)theObj
{
    [self hideHUD];
     [SVProgressHUD showWithStatus:theObj.object[@"msg"]];
    NSString *str = [NSString stringWithFormat:@"%@",theObj.object[@"msg"]];
    if ([str isEqualToString:@"success"])
    {
        str = @"修改成功";
    }
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [al show];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([str isEqualToString:@"修改成功"])
    {
         [self.navigationController popViewControllerAnimated:YES];
    }

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)hideHUD {
    
    [SVProgressHUD dismiss];
}
@end
