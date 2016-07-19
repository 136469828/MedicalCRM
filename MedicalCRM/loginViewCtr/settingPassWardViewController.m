//
//  settingPassWardViewController.m
//  chuanke
//
//  Created by mj on 15/11/30.
//  Copyright © 2015年 jinzelu. All rights reserved.
//

#import "settingPassWardViewController.h"
#import "settinhHeaderViewController.h"
#import "SVProgressHUD.h"
//#import "NextManger.h"
#import "MMZCViewController.h"
@interface settingPassWardViewController ()
{
    UIView *bgView;
    UITextField *passward;
    UITextField *againPassward;
}

@end

@implementation settingPassWardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"注册2/3";
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
//    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn)];
//    [addBtn setImage:[UIImage imageNamed:@"goback_back_orange_on"]];
//    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
//    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
//    [self.navigationItem setLeftBarButtonItem:addBtn];
    
    [self createTextFields];
}

-(void)createTextFields
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(30, 75, self.view.frame.size.width-90, 30)];
    label.text=@"请设置密码";
    label.textColor=[UIColor grayColor];
    label.textAlignment=UITextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 110, frame.size.width-20, 100)];
    bgView.layer.cornerRadius=3.0;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    passward=[self createTextFielfFrame:CGRectMake(100, 10, 200, 30) font:[UIFont systemFontOfSize:14] placeholder:@"6-20位字母或数字"];
    passward.clearButtonMode = UITextFieldViewModeWhileEditing;
    passward.secureTextEntry=YES;
    
    againPassward=[self createTextFielfFrame:CGRectMake(100, 50, 200, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请重复密码"];
    againPassward.clearButtonMode = UITextFieldViewModeWhileEditing;
    againPassward.secureTextEntry=YES;
   
    UILabel *phonelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 70, 25)];
    phonelabel.text=@"密       码";
    phonelabel.textColor=[UIColor blackColor];
    phonelabel.textAlignment=UITextAlignmentLeft;
    phonelabel.font=[UIFont systemFontOfSize:13];
    
    UILabel *phonelabel2=[[UILabel alloc]initWithFrame:CGRectMake(20, 50, 70, 25)];
    phonelabel2.text=@"重复密码";
    phonelabel2.textColor=[UIColor blackColor];
    phonelabel2.textAlignment=UITextAlignmentLeft;
    phonelabel2.font=[UIFont systemFontOfSize:13];
    
    
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, bgView.frame.size.height+bgView.frame.origin.y+30,self.view.frame.size.width-20, 37) backImageName:nil title:@"下一步" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:17] target:self action:@selector(landClick)];
    landBtn.backgroundColor= RGB(7, 115, 226);
    landBtn.layer.cornerRadius=5.0f;
    
    [bgView addSubview:passward];
    [bgView addSubview:againPassward];
    
    [bgView addSubview:phonelabel];
    [bgView addSubview:phonelabel2];
    [self.view addSubview:landBtn];
}

-(void)landClick
{
    if([passward.text isEqualToString:@""])
    {
        //[SVProgressHUD showInfoWithStatus:@"您还未设置密码"];
        [SVProgressHUD showErrorWithStatus:@"您还未设置密码"];
        return;
    }
    else if (passward.text.length <6)
    {
        //[SVProgressHUD showInfoWithStatus:@"亲,密码长度至少六位"];
        [SVProgressHUD showErrorWithStatus:@"亲,密码长度至少六位"];
        return;
    }
    else if (![passward.text isEqualToString:againPassward.text])
    {
        //[SVProgressHUD showInfoWithStatus:@"亲,密码长度至少六位"];
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        return;
    }
//    NextManger *manger = [NextManger shareInstance];
//    manger.registerName = self.userName;
//    manger.registerPwd = passward.text;
//    NSLog(@"%@ %@",manger.registerName,manger.registerPwd);
//    [manger loadData:RequestOfregister];
    settinhHeaderViewController *sub = [[settinhHeaderViewController alloc] init];
    sub.passward = passward.text;
    sub.userName = self.userName;
    [self.navigationController pushViewController:sub animated:YES];

//    [self.navigationController pushViewController:[[settinhHeaderViewController alloc]init] animated:YES];
//    [self.navigationController pushViewController:[[MMZCViewController alloc]init] animated:YES];
    //[CheckTools savePassword:passward.text];
}

-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

-(void)clickaddBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
