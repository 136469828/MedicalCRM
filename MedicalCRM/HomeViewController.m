//
//  HomeViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"
#import "MJRefresh.h"
#import "SigninViewController.h"
#import "NormalViewController.h"
#import "ProjectMangerViewController.h"
#import "PublicProjectViewController.h"
#import "PaymentViewController.h"
#import "NetManger.h"
#import "Advertiselist.h"
@interface HomeViewController ()<SDCycleScrollViewDelegate>
{
    NetManger *manger;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfadvertise];
    
    self.navigationItem.title = @"工作";
    [self setADView];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight*0.4-0.5, ScreenWidth,( ScreenWidth/4*2)+1.5)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bgView];
    NSArray *titles = @[@"公告", @"公海池", @"项目管理", @"货款管理",@"客户拜访",@"价格审批",@" ",@" "];
    NSArray *imageNames = @[@"chat_btn_action_email",
                            @"chat_btn_action_redevelop3",
                            @"auth_icon_manage_member",
                            @"cspace_favorite_thumb_oa_placeholderx",
                            @"chat_btn_action_location",
                            @"chat_btn_action_favorite",
                            @"",@"",@""];
    [self drawHoneViewWithAppviewW:ScreenWidth/4 AppviewH:ScreenWidth/4 Totalloc:4 Count:8 ImageArray:imageNames TitleArray:titles];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setADView) name:@"getadvertiselist" object:nil];
    
}

#pragma mark - setAD
- (void)setADView
{
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 54, ScreenWidth, ScreenHeight*0.3) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    NSArray *testDatas = @[@"http://meist.meidp.com/upload/201606/cb0e7883733d466b9a86f51f662cf94b.jpg",@"http://meist.meidp.com/upload/201607/07bd92c7c2844d7f8bd5c857e62a128d.png"];
    cycleScrollView3.imageURLStringsGroup = manger.ads;
    [self.view addSubview:cycleScrollView3];
}
#pragma mark - 创建九宫格
- (void)drawHoneViewWithAppviewW:(CGFloat)appviewWith AppviewH:(CGFloat)appviewHeght Totalloc:(int)totalloc Count:(int)count ImageArray:(NSArray *)images TitleArray:(NSArray *)titles{
    //    三列
    //    int totalloc=3;
    //    CGFloat appvieww=80;
    //    CGFloat appviewh=100;
    CGFloat margin=([UIScreen mainScreen].bounds.size.width-totalloc*appviewWith)/(totalloc+1);
    //    int count = 8;
    for (int i=0; i<count; i++) {
        int row=i/totalloc;//行号
        //1/3=0,2/3=0,3/3=1;
        int loc=i%totalloc;//列号
        CGFloat appviewx=margin+(appviewWith + .5)*loc;
        CGFloat appviewy=margin+(appviewHeght + .5)*row;
        
        //创建uiview控件
        UIView *appview=[[UIView alloc]initWithFrame:CGRectMake(appviewx,appviewy+ScreenHeight*0.4, appviewWith, appviewHeght)];
      appview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:appview];
        // 创建按钮
        UIButton *bTn = [UIButton buttonWithType:UIButtonTypeCustom];
        bTn.frame = CGRectMake(0, 0, appviewWith,appviewHeght);
        bTn.tag = 1000+i;
        [bTn addTarget:self action:@selector(clickOn:) forControlEvents:UIControlEventTouchDown];
        //        [bTn setBackgroundColor:[UIColor redColor]];
        bTn.tag = 1000 + i;
        [appview addSubview:bTn];
        
        //创建uiview控件中的子视图
        UIImageView *appimageview=[[UIImageView alloc]initWithFrame:CGRectMake((appviewWith*0.6)/2,appviewWith*0.14, appviewWith-appviewWith*0.6,appviewWith-appviewWith*0.6)];
        UIImage *appimage=[UIImage imageNamed:images[i]];
        appimageview.image=appimage;
        [appimageview setContentMode:UIViewContentModeScaleAspectFit];
        // NSLog(@"%@",self.apps[i][@"icon"]);
        [appview addSubview:appimageview];
        
        //创建文本标签
        UILabel *applable=[[UILabel alloc]initWithFrame:CGRectMake(0, appview.bounds.size.height*0.6, appview.bounds.size.width, 20)];
        //        applable.backgroundColor = [UIColor redColor];
        [applable setText:titles[i]];
        [applable setTextAlignment:NSTextAlignmentCenter];
        [applable setFont:[UIFont systemFontOfSize:12.0]];
        [appview addSubview:applable];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)clickOn:(UIButton *)btn
{
    switch (btn.tag) {
        case 1000:
        {
            NormalViewController  *sub = [[NormalViewController alloc] init];
            sub.title = @"公告";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
        case 1001:
        {
//            PublicProjectViewController  *sub = [[PublicProjectViewController alloc] init];
//            sub.title = @"公海池";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
            ProjectMangerViewController  *sub = [[ProjectMangerViewController alloc] init];
            sub.title = @"项目公海池";
            sub.sType = @"1";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
        case 1002:
        {
            ProjectMangerViewController  *sub = [[ProjectMangerViewController alloc] init];
            sub.title = @"项目管理";
            sub.sType = @"0";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
        case 1003:
        {
            PaymentViewController  *sub = [[PaymentViewController alloc] init];
            sub.title = @"货款管理";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
        case 1004:
        {
            SigninViewController  *sub = [[SigninViewController alloc] init];
            sub.title = @"客户拜访";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
        case 1005:
        {
//            ProjectMangerViewController  *sub = [[ProjectMangerViewController alloc] init];
//            sub.title = @"价格审批";
//            sub.hidesBottomBarWhenPushed = YES;
//            sub.isPayManger = YES;
//            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
            
        default:
            break;
    }

}

@end
