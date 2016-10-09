//
//  MMZCViewController.m
//  MMR
//
//  Created by qianfeng on 15/6/30.
//  Copyright © 2015年 MaskMan. All rights reserved.
//

#import "MMZCViewController.h"
#import "forgetPassWardViewController.h"
#import "AppDelegate.h"
#import "MMZCHMViewController.h"
//#import "RootTabbarController.h"
#import "MainTabBarController.h"
#import "SVProgressHUD.h"
#import "NetManger.h"
#import "JPUSHService.h"
//#import "UMSocial.h"
//#import "UMSocialWechatHandler.h"
//#import "UMSocialQQHandler.h"
//#import "UMSocialSinaSSOHandler.h"
@interface MMZCViewController ()<RCIMUserInfoDataSource>
{
    UIImageView *View;
    UIView *bgView;
    UITextField *pwd;
    UITextField *user;
    UIButton *QQBtn;
    UIButton *weixinBtn;
    UIButton *xinlangBtn;
    BOOL isRemenber;
}
@property(copy,nonatomic) NSString * accountNumber;
@property(copy,nonatomic) NSString * mmmm;
@property(copy,nonatomic) NSString * user;


@end

@implementation MMZCViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
//   [[UINavigationBar appearance] setBarTintColor:RGB(7, 115, 226)];
    
    self.navigationController.navigationBarHidden = YES;
    isRemenber = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"userName"];
    NSString *passWord = [userDefaults objectForKey:@"passWord"];
    if (userName.length == 0 || passWord.length == 0)
    {
        //设置NavigationBar背景颜色
        View=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        View.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:View];
        UIImageView *bgTop = [[UIImageView alloc] initWithFrame:CGRectMake(1,30, ScreenWidth-2, 135)];
        bgTop.image = [UIImage imageNamed:@"touxiang_login"];
        bgTop.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:bgTop];
        [self createButtons];
        [self createImageViews];
        [self createTextFields];
        //    [self createLabel];
        // 导航栏返回btn
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        self.navigationItem.backBarButtonItem = backItem;
        //    self.navigationItem.backBarButtonItem.image = [UIImage imageNamed:@"leftBtn"];
        backItem.title = @" ";
        self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        // 所属机构
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight-30, ScreenWidth, 25)];
        lb.text = @"巨烽大数据管理平台";
        lb.textColor = [UIColor blackColor];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:lb];
    }
    else
    {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"launch"ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        self.view.layer.contents = (id)image.CGImage;
        NetManger *manger = [NetManger shareInstance];
        manger.userName = userName; manger.userPWD = passWord;
        [manger loadData:RequestOfLogin];
        [SVProgressHUD showWithStatus:@"正在登录"];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loging:) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorloging) name:@"errorlogin" object:nil];



}

-(void)clickaddBtn:(UIButton *)button
{
//      [kAPPDelegate appDelegateInitTabbar];
    self.view.backgroundColor=[UIColor whiteColor];
    exit(0);
}


-(void)createLabel
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-140)/2, ScreenHeight*0.75, 140, 21)];
    label.text=@"第三方账号快速登录";
    label.textColor=[UIColor whiteColor];
    label.textAlignment=UITextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:label];
}

-(void)createTextFields
{
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(10, ScreenHeight*0.15+60, frame.size.width-20, 100)];
    bgView.layer.cornerRadius=3.0;
    bgView.alpha=0.7;
    bgView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:bgView];
    
    user=[self createTextFielfFrame:CGRectMake(60, 10, 271, 30) font:[UIFont systemFontOfSize:14] placeholder:@"账号"];

    user.keyboardType=UIKeyboardTypeDefault;
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
   
    pwd=[self createTextFielfFrame:CGRectMake(60, 60, 271, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"密码" ];
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密文样式
    pwd.secureTextEntry=YES;
    //pwd.keyboardType=UIKeyboardTypeNumberPad;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userDefaults objectForKey:@"passWord"];
    if (str.length != 0)
    {
        NSLog(@"%@ %@",[userDefaults objectForKey:@"userName"],[userDefaults objectForKey:@"passWord"]);
        user.text = [userDefaults objectForKey:@"userName"];
        pwd.text = [userDefaults objectForKey:@"passWord"];
    }
    UIImageView *userImageView=[self createImageViewFrame:CGRectMake(20, 15, 18, 20) imageName:@"ic_landing_nickname" color:nil];
    UIImageView *pwdImageView=[self createImageViewFrame:CGRectMake(20, 65, 18, 20) imageName:@"mm_normal" color:nil];
    UIImageView *line1=[self createImageViewFrame:CGRectMake(20, 50, bgView.frame.size.width-40, 1) imageName:nil color:RGB(186, 227, 255)];
    UIImageView *line2=[self createImageViewFrame:CGRectMake(20, 105, bgView.frame.size.width-40, 1) imageName:nil color:RGB(186, 227, 255)];
    
    [bgView addSubview:user];
    [bgView addSubview:pwd];
    
    [bgView addSubview:userImageView];
    [bgView addSubview:pwdImageView];
    [bgView addSubview:line1];
    [bgView addSubview:line2];
}


-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [user resignFirstResponder];
    [pwd resignFirstResponder];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [user resignFirstResponder];
    [pwd resignFirstResponder];
}

-(void)createImageViews
{
    //    UIImageView *userImageView=[self createImageViewFrame:CGRectMake(25, 10, 25, 25) imageName:@"ic_landing_nickname" color:nil];
    //    UIImageView *pwdImageView=[self createImageViewFrame:CGRectMake(25, 60, 25, 25) imageName:@"ic_landing_password" color:nil];
    //    UIImageView *line1=[self createImageViewFrame:CGRectMake(25, 50, 260, 1.5) imageName:nil color:[UIColor lightGrayColor]];
    //
    //    //UIImageView *line2=[self createImageViewFrame:CGRectMake(88, 210, 280, 1) imageName:nil color:[UIColor grayColor]];
    
    UIImageView *line3=[self createImageViewFrame:CGRectMake(2,ScreenHeight*0.75+10, 70, 1) imageName:nil color:[UIColor lightGrayColor]];
    UIImageView *line4=[self createImageViewFrame:CGRectMake(self.view.frame.size.width-70-4, ScreenHeight*0.75+10, 70, 1) imageName:nil color:[UIColor lightGrayColor]];
    UIImageView *line5=[self createImageViewFrame:CGRectMake(self.view.frame.size.width/2,40+ScreenWidth/3+195, 1,20) imageName:nil color:[UIColor whiteColor]];
    
    //    [bgView addSubview:userImageView];
    //    [bgView addSubview:pwdImageView];
    //    [bgView addSubview:line1];
    //[self.view addSubview:line2];
//    [self.view addSubview:line3];
//    [self.view addSubview:line4];
    [self.view addSubview:line5];
    
}


-(void)createButtons
{
    UIButton *landBtn=[self createButtonFrame:CGRectMake(20,ScreenHeight*0.15+200, self.view.frame.size.width-40, 36) backImageName:nil title:@"登录" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:19] target:self action:@selector(landClick)];
    landBtn.backgroundColor= RGB(56, 173, 255);
    landBtn.layer.cornerRadius=5.0f;
    
    UIButton *newUserBtn=[self createButtonFrame:CGRectMake(self.view.frame.size.width*0.5-85, 270, 80, 30) backImageName:nil title:@"我要注册" titleColor:RGB(39, 143, 253) font:[UIFont systemFontOfSize:17] target:self action:@selector(registration:)];
    //newUserBtn.backgroundColor=[UIColor lightGrayColor];
    newUserBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    UIButton *forgotPwdBtn=[self createButtonFrame:CGRectMake(self.view.frame.size.width*0.5+5, 270, 80, 30) backImageName:nil title:@"找回密码" titleColor:RGB(39, 143, 253) font:[UIFont systemFontOfSize:17] target:self action:@selector(fogetPwd:)];
    //fogotPwdBtn.backgroundColor=[UIColor lightGrayColor];
    forgotPwdBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
//    UIButton *remberBtn=[self createButtonFrame:CGRectMake(self.view.frame.size.width*0.5-70, 305, 140, 30) backImageName:nil title:@"记住登录密码" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15] target:self action:@selector(rebberBtn:)];
    UIButton *remberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    remberBtn.backgroundColor=[UIColor lightGrayColor];
    remberBtn.frame = CGRectMake(self.view.frame.size.width*0.5-100, 40+ScreenWidth/3+100, self.view.frame.size.width-2*(self.view.frame.size.width*0.5-100), 30);
    [remberBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [remberBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    remberBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    remberBtn.selected = YES;
    [remberBtn setTitleColor:RGB(39, 143, 253) forState:UIControlStateNormal];
//    [remberBtn setImage:[UIImage imageNamed:@"勾选框"] forState:UIControlStateNormal];
//    [remberBtn setImage:[UIImage imageNamed:@"已勾选"] forState:UIControlStateSelected];
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(30, 7, 15, 15)];
    imv.image = [UIImage imageNamed:@"已勾选"];
    imv.tag = 999;
    [remberBtn addSubview:imv];
    [remberBtn addTarget:self action:@selector(remberAction:) forControlEvents:UIControlEventTouchDown];
    [remberBtn setTitle:@"记住登录密码" forState:UIControlStateNormal];
  
    
      #define Start_X 60.0f           // 第一个按钮的X坐标
      #define Start_Y 440.0f           // 第一个按钮的Y坐标
      #define Width_Space 50.0f        // 2个按钮之间的横间距
      #define Height_Space 20.0f      // 竖间距
      #define Button_Height 50.0f    // 高
      #define Button_Width 50.0f      // 宽


    
    //微信
    weixinBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-50)/2, ScreenHeight-70, 50, 50)];
    //weixinBtn.tag = UMSocialSnsTypeWechatSession;
    weixinBtn.layer.cornerRadius=25;
    weixinBtn=[self createButtonFrame:weixinBtn.frame backImageName:@"weixin" title:nil titleColor:nil font:nil target:self action:@selector(onClickWX:)];
    //qq
    QQBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-50)/2-100, ScreenHeight-70, 50, 50)];
    //QQBtn.tag = UMSocialSnsTypeMobileQQ;
    QQBtn.layer.cornerRadius=25;
    QQBtn=[self createButtonFrame:QQBtn.frame backImageName:@"QQ" title:nil titleColor:nil font:nil target:self action:@selector(onClickQQ:)];
    
    //新浪微博
    xinlangBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-50)/2+100, ScreenHeight-70, 50, 50)];
    //xinlangBtn.tag = UMSocialSnsTypeSina;
    xinlangBtn.layer.cornerRadius=25;
    xinlangBtn=[self createButtonFrame:xinlangBtn.frame backImageName:@"weibo" title:nil titleColor:nil font:nil target:self action:@selector(onClickSina:)];
    
//    [self.view addSubview:weixinBtn];
//    [self.view addSubview:QQBtn];
//    [self.view addSubview:xinlangBtn];
    [self.view addSubview:landBtn];
//    [self.view addSubview:newUserBtn];
//    [self.view addSubview:forgotPwdBtn];
    [self.view addSubview:remberBtn];

    
}


- (void)onClickQQ:(UIButton *)button
{
    
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
//    
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:@"qq"];
//
//            NSLog(@"userNane: %@  usid: %@  icon: %@",snsAccount.userName,snsAccount.usid,snsAccount.iconURL);
//            NextManger *manger = [NextManger shareInstance];
//            manger.userThirdInfos = @[snsAccount.usid,@"1",snsAccount.userName,snsAccount.iconURL];
//            [manger loadData:RequestOfloginbythird];
//        }});
}

- (void)onClickWX:(UIButton *)button
{
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
//    
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
////        NSDictionary *dic = response.data;
//////        NSLog(@"%@",dic);
//        if (response.responseCode == UMSResponseCodeSuccess) {
////            
////            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
////            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:@"platformName"];
//            NSLog(@"thirdPlatformUserProfile = %@  %@ %@",response.thirdPlatformUserProfile[@"headimgurl"],response.thirdPlatformUserProfile[@"nickname"],response.thirdPlatformUserProfile[@"unionid"]);
//            NextManger *manger = [NextManger shareInstance];
//            manger.userThirdInfos = @[
//                                      [NSString stringWithFormat:@"%@",response.thirdPlatformUserProfile[@"unionid"]],
//                                      
//                                      @"2",
//                                      
//                                      [NSString stringWithFormat:@"%@",
//                                       response.thirdPlatformUserProfile[@"nickname"]],
//                                      
//                                      [NSString stringWithFormat:@"%@",response.thirdPlatformUserProfile[@"headimgurl"]]];
//            
//            [manger loadData:RequestOfloginbythird];
//        }
//        
//    });
}


- (void)onClickSina:(UIButton *)button
{
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//    
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        
//        //          获取微博用户名、uid、token等
////        NSLog(@"新浪微博登录 %@",response);
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
////            NSLog(@"dic %@",dict);
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:@"sina"];
//            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
//            
//            NextManger *manger = [NextManger shareInstance];
//            manger.userThirdInfos = @[
//                                      [NSString stringWithFormat:@"%@",snsAccount.accessToken],
//                                      
//                                      @"4",
//                                      
//                                      [NSString stringWithFormat:@"%@",
//                                       snsAccount.userName],
//                                      
//                                      [NSString stringWithFormat:@"%@",snsAccount.iconURL]];
//            
//            [manger loadData:RequestOfloginbythird];
//            
//        }});

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


//登录
-(void)landClick
{
    if ([user.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"亲,请输入用户名"];
        return;
    }
//    else if (user.text.length <11)
//    {
//        [LCProgressHUD showMessage:@"您输入的手机号码格式不正确"];
//        return;
//    }
    else if ([pwd.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"亲,请输入密码"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
        return;
    }
//    else if (pwd.text.length <5)
//    {
//        [SVProgressHUD showErrorWithStatus:@"亲,密码长度至少五位"];
//        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
//        return;
//    }
    else
    {
        //
        NSLog(@"user:%@ pwd:%@ ",user.text,pwd.text);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (isRemenber == YES)
        {
            
            [userDefaults setObject:user.text forKey:@"userName"];
            [userDefaults setObject:pwd.text forKey:@"passWord"];

        }
        else
        {
            [userDefaults removeObjectForKey:@"userName"];
            [userDefaults removeObjectForKey:@"passWord"];
        }
        NetManger *manger = [NetManger shareInstance];
        manger.userName = user.text; manger.userPWD = pwd.text;
        [manger loadData:RequestOfLogin];
        [SVProgressHUD showWithStatus:@"正在登录"];
        
        
    }
//    RootTabbarController *rootTabbarCtr = [[RootTabbarController alloc] init];
//    [self presentViewController:rootTabbarCtr animated:YES completion:nil];

}
#pragma mark - 判断账号密码
- (void)loging:(NSNotification*)theObj
{
    NSLog(@"%@",[NetManger shareInstance].rongcloudToken);
        //登录融云服务器,开始阶段可以先从融云API调试网站获取，之后token需要通过服务器到融云服务器取。
    NSString*token=[NetManger shareInstance].rongcloudToken;
    //@"/RKe9ovnDCAqSDRz8ju/15WWa9eXtvB/MYH0YpK1Y2AS9IvuDT8GcOGvil9UpZGL2GDzvJgCerW1QLvDVKSpyg==";
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
//            [[RCIM sharedRCIM] setUserInfoDataSource:self];
            [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
            NSLog(@"Login successfully with userId: %@.", userId);
            dispatch_async(dispatch_get_main_queue(), ^{
    
            });
        } error:^(RCConnectErrorCode status) {
            NSLog(@"login error status: %ld.", (long)status);
        } tokenIncorrect:^{
            NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
        }];

//    RootTabbarController *rootTabbarCtr = [[RootTabbarController alloc] init];
//    [self presentViewController:rootTabbarCtr animated:YES completion:nil];
    [SVProgressHUD dismiss];
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    [users setObject:[NetManger shareInstance].pushID forKey:@"pushID"];
    MainTabBarController *rootTabbarCtr = [[MainTabBarController alloc] init];
    [self presentViewController:rootTabbarCtr animated:YES completion:nil];

}

//注册
-(void)zhuce
{
    [self.navigationController pushViewController:[[MMZCHMViewController alloc]init] animated:YES];
}

-(void)registration:(UIButton *)button
{
   [self.navigationController pushViewController:[[MMZCHMViewController alloc]init] animated:YES];
//    MMZCHMViewController *sub = [[TheOfficialTutorialController alloc] init];
//    sub.title = @"官方教程";
//    [self.navigationController pushViewController:sub animated:YES];
//    [self presentViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#> completion:<#^(void)completion#>]

}

-(void)fogetPwd:(UIButton *)button
{
   [self.navigationController pushViewController:[[forgetPassWardViewController alloc]init] animated:YES];
}



#pragma mark - 工具
//手机号格式化
-(NSString*)getHiddenStringWithPhoneNumber:(NSString*)number middle:(NSInteger)countHiiden{
    // if (number.length>6) {
    
    if (number.length<countHiiden) {
        return number;
    }
    NSInteger count=countHiiden;
    NSInteger leftCount=number.length/2-count/2;
    NSString *xings=@"";
    for (int i=0; i<count; i++) {
        xings=[NSString stringWithFormat:@"%@%@",xings,@"*"];
    }
    
    NSString *chuLi=[number stringByReplacingCharactersInRange:NSMakeRange(leftCount, count) withString:xings];
    // chuLi=[chuLi stringByReplacingCharactersInRange:NSMakeRange(number.length-count, count-leftCount) withString:xings];
    
    return chuLi;
}

//手机号格式化后还原
-(NSString*)getHiddenStringWithPhoneNumber1:(NSString*)number middle:(NSInteger)countHiiden{
    // if (number.length>6) {
    if (number.length<countHiiden) {
        return number;
    }
    NSString *xings=@"";
    for (int i=0; i<1; i++) {
        //xings=[NSString stringWithFormat:@"%@",[CheckTools getUser]];
    }
    
    NSString *chuLi=[number stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:@""];
    // chuLi=[chuLi stringByReplacingCharactersInRange:NSMakeRange(number.length-count, count-leftCount) withString:xings];
    
    return chuLi;
}
// 记住密码
- (void)remberAction:(UIButton *)btn
{
    UIImageView *imv = (UIImageView *)[self.view viewWithTag:999];
    if (btn.selected) {
        NSLog(@"不记住密码");
        isRemenber = NO;
        imv.image = [UIImage imageNamed:@"勾选框"];
        btn.selected = !btn.selected;
    }
    else
    {
        NSLog(@"记住密码");
        isRemenber = YES;
        imv.image = [UIImage imageNamed:@"已勾选"];
        btn.selected = !btn.selected;
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dismiss
{
    [SVProgressHUD dismiss];
}
- (void)errorloging
{
    //设置NavigationBar背景颜色
    View=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:View];
    UIImageView *bgTop = [[UIImageView alloc] initWithFrame:CGRectMake(1,30, ScreenWidth-2, 135)];
    bgTop.image = [UIImage imageNamed:@"touxiang_login"];
    bgTop.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bgTop];
    [self createButtons];
    [self createImageViews];
    [self createTextFields];
    //    [self createLabel];
    // 导航栏返回btn
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    //    self.navigationItem.backBarButtonItem.image = [UIImage imageNamed:@"leftBtn"];
    backItem.title = @" ";
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    // 所属机构
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight-30, ScreenWidth, 25)];
    lb.text = @"巨烽大数据管理平台";
    lb.textColor = [UIColor blackColor];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lb];
}

@end
