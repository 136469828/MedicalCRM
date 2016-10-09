//
//  ChatGroupMembersViewController.m
//  MedicalCRM
//
//  Created by admin on 16/9/6.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ChatGroupMembersViewController.h"
#import "GroupMembersCell.h"
#import "NetManger.h"
#import <RongIMKit/RongIMKit.h>
#import "UIImageView+WebCache.h"
#import "AddFriendListViewController.h"
@interface ChatGroupMembersViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NetManger *manger;
}
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ChatGroupMembersViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    
    manger = [NetManger shareInstance];
    [_m_datas removeAllObjects];
    [[RCIM sharedRCIM] getDiscussion:self.groupID success:^(RCDiscussion *discussion)
     {
        JCKLog(@"%@",discussion.memberIdList);
         self.datas = discussion.memberIdList;
         //             [[RCIM sharedRCIM] setUserInfoDataSource:self];
         JCKLog(@"%ld",self.datas.count);
         for (int i = 0; i < self.datas.count; i++)
         {
             JCKLog(@"%@",self.datas[i]);
             [[[RCIM sharedRCIM] userInfoDataSource] getUserInfoWithUserId:[NSString stringWithFormat:@"%@",self.datas[i]] completion:^(RCUserInfo *userInfo)
              {
//                  JCKLog(@"%@",userInfo);
                  if (_m_datas.count == 0)
                  {
                      _m_datas = [[NSMutableArray alloc] initWithCapacity:0];
                  }
                  if (userInfo != nil)
                  {
                      [_m_datas addObject:[NSString stringWithFormat:@"%@|%@|%@",userInfo.name,userInfo.userId,userInfo.portraitUri]];
                  }
              }];
             [_collectionView reloadData];
         }
         JCKLog(@"%@",_m_datas);
         
     } error:^(RCErrorCode status)
     {
         JCKLog(@"%ld",(long)status);
     }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 20, 20);
        [meassageBut addTarget:self action:@selector(pushAddCtr) forControlEvents:UIControlEventTouchDown];
        [meassageBut setImage:[UIImage imageNamed:@"addIcon"]forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;


    
    [self setCollectView];
    
}
- (void)setCollectView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //设置对齐方式
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //cell间距
    layout.minimumInteritemSpacing = 0.5f;
    //cell行距
    layout.minimumLineSpacing = 1.0f;
    //需要layout 否则崩溃：UICollectionView must be initialized with a non-nil layout parameter
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-69) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [layout setFooterReferenceSize:CGSizeMake(ScreenWidth, 10)];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView setUserInteractionEnabled:YES];
    [_collectionView setPagingEnabled:YES];
    //注册Cell类，否则崩溃: must register a nib or a class for the identifier or connect a prototype cell in a storyboard
    [_collectionView registerNib:[UINib nibWithNibName:@"GroupMembersCell" bundle:nil] forCellWithReuseIdentifier:@"GroupMembersCell"];
    [self.view addSubview:_collectionView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// UICollectionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupMembersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupMembersCell" forIndexPath:indexPath];
    NSArray *array = [[NSString stringWithFormat:@"%@",_m_datas[indexPath.row]] componentsSeparatedByString:@"|"]; //从字符A中分隔成2个元素的数组
    cell.nameLab.text = [NSString stringWithFormat:@"%@",array[0]];
    cell.imgv.layer.cornerRadius = 5;
    cell.imgv.layer.masksToBounds= YES;
    NSString *str = [NSString stringWithFormat:@"%@",array[2]];
    if (str.length > 6)
    {
        [cell.imgv sd_setImageWithURL:[NSURL URLWithString:str]];
    }
    cell.tag = [array[1] integerValue];
    return cell;


    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _m_datas.count;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width/5)-0.5 ,([UIScreen mainScreen].bounds.size.width/4)-1);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)pushAddCtr
{
    AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
    sub.title = @"选择添加的好友";
    sub.isNogroup = 2;
    sub.ID = self.groupID;
    [self.navigationController pushViewController:sub animated:YES];
    
}
@end
