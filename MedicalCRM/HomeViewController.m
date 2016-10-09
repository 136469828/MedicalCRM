//
//  HomeViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"
#import "SigninViewController.h"
#import "NormalViewController.h"
#import "ProjectMangerViewController.h"
#import "PublicProjectViewController.h"
#import "PaymentViewController.h"
#import "NetManger.h"
#import "Advertiselist.h"
#import "MyPayViewController.h"
#import "ProjectBuildViewController.h"
#import "CustinfosaveViewController.h"
#import "HomeCollectionViewCell.h"
#import "MyDemoChiController.h"
#import "MyPerformanceViewController.h"
#import "CustomerListViewController.h"
#import "ProjectMangerCollectViewController.h"
#import "DayPlanListViewController.h"
#import "EnterpriseCultureViewController.h"
#import "ExhibitionListViewController.h"
#import "AuditListViewController.h"
#import "WebModel.h"
#import "WebViewController.h"
#import "LifeNavigationViewController.h";
@interface HomeViewController ()<SDCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NetManger *manger;
    NSArray *titles;
    NSArray *imageNames;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation HomeViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfadvertise];
    self.title = @"深圳市巨烽显示科技有限公司";
    [self setADView];
    self.view.backgroundColor = RGB(234, 234, 234);
    titles = @[@"审批管理", @"项目管理",@"客户管理",@"业绩管理",@"人生导航",@"重要事项",@"展会管理",@"公海池"];
    imageNames = @[         @"审批",
                            @"项目管理",
                            @"客户档案",
                            @"业绩管理",
                            @"人生导航",
                            @"重要事项",
                            @"会展管理",
                            @"公海池"];
//    [self drawHoneViewWithAppviewW:ScreenWidth/4 AppviewH:ScreenWidth/4 Totalloc:4 Count:8 ImageArray:imageNames TitleArray:titles];
    [self setCollectionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setADView) name:@"getadvertiselist" object:nil];
    
}

#pragma mark - setAD
- (void)setADView
{
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight*0.3) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];

    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.imageURLStringsGroup = manger.ads;
    [self.view addSubview:cycleScrollView3];
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    WebModel *model = [[WebModel alloc] initWithUrl:@"http://www.beacon-display.cn/jfxc.html"];
    WebViewController *SVC = [[WebViewController alloc] init];
    SVC.title = @"详情";
    SVC.hidesBottomBarWhenPushed = YES;
    [SVC setModel:model];
    [self.navigationController pushViewController:SVC animated:YES];
}
#pragma mark - collectionView
- (void)setCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    //设置对齐方式
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //cell间距
    layout.minimumInteritemSpacing = 0.5f;
    //cell行距
    layout.minimumLineSpacing = 1.0f;
    //需要layout 否则崩溃：UICollectionView must be initialized with a non-nil layout parameter
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ScreenHeight*0.3, ScreenWidth, ScreenHeight- ScreenHeight*0.3-110) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [layout setFooterReferenceSize:CGSizeMake(ScreenWidth, 10)];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView setUserInteractionEnabled:YES];
    [_collectionView setPagingEnabled:YES];
    //注册Cell类，否则崩溃: must register a nib or a class for the identifier or connect a prototype cell in a storyboard
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    [self.view addSubview:_collectionView];
}
// UICollectionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    cell.imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNames[indexPath.row]]];
    cell.titleLab.text = [NSString stringWithFormat:@"%@",titles[indexPath.row]];
    if (indexPath.row == 0 || indexPath.row == 1)
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/4-33, 13, 24, 24)];
        img.image = [UIImage imageNamed:@"132"];
        [cell.contentView addSubview:img];
    }
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return titles.count;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width/4)-0.5 ,([UIScreen mainScreen].bounds.size.width/4)-1 );
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    titles = @[@"审批管理", @"项目管理",@"客户档案",@"业绩管理",@"人生导航",@"重要事项",@"展会管理",@"公海池"];
    NSInteger tag = indexPath.row + 1000;
    switch (tag) {
        case 1000:
        {
            AuditListViewController *sub = [[AuditListViewController alloc] init];
            sub.title = @"审核列表";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];

        }
            break;
        case 1001:
        {
//            ProjectMangerCollectViewController  *sub = [[ProjectMangerCollectViewController alloc] init];
//            sub.title = @"项目管理";
//            sub.sType = @"0";
////            sub.isPayManger = YES;
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
            ProjectMangerViewController  *sub = [[ProjectMangerViewController alloc] init];
            sub.title = @"项目管理";
            sub.sType = @"0";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
        case 1002:
        {
            CustomerListViewController *sub = [[CustomerListViewController alloc] init];
            sub.title = @"客户档案";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];

        }
            break;
        case 1003:
        {
            MyPerformanceViewController *sub = [[MyPerformanceViewController alloc] init];
            sub.title = @"业绩管理";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
        case 1004:
        {
            LifeNavigationViewController *sub = [[LifeNavigationViewController alloc] init];
            sub.title = @"新的人生导航";
            [self.navigationController pushViewController:sub animated:YES];

        }
            break;
        case 1005:
        {
            EnterpriseCultureViewController *sub = [[EnterpriseCultureViewController alloc] init];
            sub.title = @"知识库";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
        case 1006:
        {
            ExhibitionListViewController*sub = [[ExhibitionListViewController alloc] init];
            sub.title = @"展会申请列表";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
        case 1007:
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
            //            ProjectMangerCollectViewController  *sub = [[ProjectMangerCollectViewController alloc] init];
            //            sub.title = @"项目公海池";
            //            sub.sType = @"1";
            //            sub.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
            
        default:
        {
           
        }
            break;
    }
//    switch (tag) {
//        case 1000:
//        {
//            NormalViewController  *sub = [[NormalViewController alloc] init];
//            sub.title = @"公告";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//        }
//            break;
//        case 1001:
//        {
//            AuditListViewController *sub = [[AuditListViewController alloc] init];
//            sub.title = @"审核列表";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//        }
//            break;
//        
//        case 1002:
//        {
////            ProjectMangerCollectViewController  *sub = [[ProjectMangerCollectViewController alloc] init];
////            sub.title = @"项目管理";
////            sub.sType = @"0";
//////            sub.isPayManger = YES;
////            sub.hidesBottomBarWhenPushed = YES;
////            [self.navigationController pushViewController:sub animated:YES];
//            ProjectMangerViewController  *sub = [[ProjectMangerViewController alloc] init];
//            sub.title = @"项目管理";
//            sub.sType = @"0";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//        }
//            break;
////        case 1003:
////        {
////            PaymentViewController  *sub = [[PaymentViewController alloc] init];
////            sub.title = @"项目跟踪";
////            sub.hidesBottomBarWhenPushed = YES;
////            [self.navigationController pushViewController:sub animated:YES];
////        }
////            break;
//        case 1003:
//        {
//            SigninViewController  *sub = [[SigninViewController alloc] init];
//            sub.title = @"客户拜访";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//        }
//            break;
//
//        case 1004:
//        {
//            DayPlanListViewController *sub = [[DayPlanListViewController alloc] init];
//            sub.title = @"工作计划";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//            
//        }
//            break;
//        case 1005:
//        {
//            MyPayViewController *sub = [[MyPayViewController alloc] init];
//            sub.title = @"费用报销";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//            //            PaymentViewController  *sub = [[PaymentViewController alloc] init];
//            //            sub.title = @"费用报销";
//            //            sub.hidesBottomBarWhenPushed = YES;
//            //            [self.navigationController pushViewController:sub animated:YES];
//        }
//            break;
//        case 1006:
//        {
//            ProjectBuildViewController *sub = [[ProjectBuildViewController alloc] init];
//            sub.title = @"新建项目";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//            
//        }
//            break;
//        case 1007:
//        {
//            CustomerListViewController *sub = [[CustomerListViewController alloc] init];
//            sub.title = @"客户档案";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//            
//        }
//            break;
//        case 1008:
//        {
//            MyDemoChiController *sub = [[MyDemoChiController alloc] init];
//            sub.title = @"样机管理";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//            
//        }
//            break;
//        case 1009:
//        {
//            MyPerformanceViewController *sub = [[MyPerformanceViewController alloc] init];
//            sub.title = @"业绩管理";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//            
//        }
//            break;
//
//        case 1010:
//        {
//            EnterpriseCultureViewController *sub = [[EnterpriseCultureViewController alloc] init];
//            sub.title = @"知识库";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//            
//        }
//            break;
//        case 1011:
//        {
//            ExhibitionListViewController*sub = [[ExhibitionListViewController alloc] init];
//            sub.title = @"展会申请列表";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//            
//        }
//            break;
//        case 1012:
//        {
//            //            PublicProjectViewController  *sub = [[PublicProjectViewController alloc] init];
//            //            sub.title = @"公海池";
//            //            sub.hidesBottomBarWhenPushed = YES;
//            //            [self.navigationController pushViewController:sub animated:YES];
//            ProjectMangerViewController  *sub = [[ProjectMangerViewController alloc] init];
//            sub.title = @"项目公海池";
//            sub.sType = @"1";
//            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//            //            ProjectMangerCollectViewController  *sub = [[ProjectMangerCollectViewController alloc] init];
//            //            sub.title = @"项目公海池";
//            //            sub.sType = @"1";
//            //            sub.hidesBottomBarWhenPushed = YES;
//            //            [self.navigationController pushViewController:sub animated:YES];
//        }
//            break;
//
//        default:
//            break;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
