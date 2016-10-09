//
//  ProjectMangerCollectViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProjectMangerCollectViewController.h"
#import "ProjectMangerCollectionViewCell.h"
#import "NetManger.h"
#import "GetprojectpagelistModel.h"
#import "ProjectInfoController.h"
#import "ProjectBuildViewController.h"
#import "MJRefresh.h"
#import "SeachViewController.h"
@interface ProjectMangerCollectViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NetManger *manger;
}
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ProjectMangerCollectViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    manger = [NetManger shareInstance];
    manger.sType = self.sType;
    manger.keywork = @"";
    [manger loadData:RequestOfgetprojectpagelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getprojectpagelist" object:nil];
}
- (void)reloadDatas
{
    [self.collectionView reloadData];
    [_collectionView.mj_header endRefreshing];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(235, 235, 235);
    // Do any additional setup after loading the view, typically from a nib.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置对齐方式
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setHeaderReferenceSize:CGSizeMake(ScreenWidth, 40)];
    [layout setFooterReferenceSize:CGSizeMake(ScreenWidth, 30)];
    //cell间距
    layout.minimumInteritemSpacing = 5.0f;
    //cell行距
    layout.minimumLineSpacing = 15.0f;
    
    //需要layout 否则崩溃：UICollectionView must be initialized with a non-nil layout parameter
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-40, ScreenHeight-54) collectionViewLayout:layout];
    _collectionView.showsVerticalScrollIndicator = FALSE;
    _collectionView.showsHorizontalScrollIndicator = FALSE;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView setUserInteractionEnabled:YES];
    [_collectionView setPagingEnabled:YES];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        manger.sType = self.sType;
        [manger loadData:RequestOfgetprojectpagelist];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"getprojectpagelist" object:nil];
    }];
//    //注册Cell类，否则崩溃: must register a nib or a class for the identifier or connect a prototype cell in a storyboard
    [_collectionView registerNib:[UINib nibWithNibName:@"ProjectMangerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProjectMangerCollectionViewCell"];
    [self.view addSubview:_collectionView];
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 20, 20);
        [meassageBut addTarget:self action:@selector(pushBulidCtr) forControlEvents:UIControlEventTouchDown];
        [meassageBut setImage:[UIImage imageNamed:@"addIcon"]forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    [self hearView];
}
#pragma mark -
- (void)hearView{
#pragma - mark 中间搜索栏
    UIButton *seachButton = ({
        UIButton *seachButton = [UIButton buttonWithType:UIButtonTypeCustom];
        seachButton.layer.borderWidth = 1.0; // set borderWidth as you want.
        seachButton.layer.cornerRadius = 3.0f;
        seachButton.layer.masksToBounds=YES;
        seachButton.layer.borderColor = [UIColor whiteColor].CGColor;
        seachButton.backgroundColor = [UIColor whiteColor];
        seachButton.frame = CGRectMake(0, 0, ScreenWidth/1.3, 25);
        seachButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [seachButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [seachButton setTitle:[NSString stringWithFormat:@"搜索项目"]  forState:UIControlStateNormal];
        [seachButton addTarget:self action:@selector(pushSeachVC) forControlEvents:UIControlEventTouchDown];
        seachButton;
    });
    self.navigationItem.titleView = seachButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//required
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    ProjectMangerCollectionViewCell *cell = [ProjectMangerCollectionViewCell setCollectionView:collectionView cellForItemAtIndexPath:indexPath Datas:manger.getprojectpagelist];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return manger.getprojectpagelist.count;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth/2)-25 ,(ScreenWidth/1.8-20)-15 );
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectMangerCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    ProjectInfoController *sub = [[ProjectInfoController alloc] init];
    sub.title = @"项目详细";
    if ([self.sType isEqualToString:@"0"]) {
        sub.isPublic = NO;
    }
    else
    {
        sub.isPublic = YES;
    }
    sub.ID = cell.tag;
    [self.navigationController pushViewController:sub animated:YES];
}
#pragma mark - pushBulidCtr
- (void)pushBulidCtr
{
    ProjectBuildViewController *sub = [[ProjectBuildViewController alloc] init];
    sub.title = @"项目申报";
    [self.navigationController pushViewController:sub animated:YES];
    
}
- (void)pushSeachVC
{
    SeachViewController *sub = [[SeachViewController alloc] init];
    sub.state = self.sType;
    [self.navigationController pushViewController:sub animated:YES];

}
@end
