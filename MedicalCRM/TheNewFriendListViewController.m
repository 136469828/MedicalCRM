//
//  TheNewFriendListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TheNewFriendListViewController.h"
#import "TheNewFriendListModel.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "NewFriendModel.h"
#import "NewFriendGroupCell.h"
#import "ChatListViewController.h"
#import "SeachFriendViewController.h"
//#import "FriendCell.h"
#define  DIC_EXPANDED @"expanded" //是否是展开 0收缩 1展开
#define  DIC_ARARRY @"array"
#define  DIC_TITILESTRING @"title"

#define  CELL_HEIGHT 40.0f
@interface TheNewFriendListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView *_tableVIew;
    NetManger *manger;
    NSMutableArray *_DataArray;
}
@property(nonatomic,strong) NSArray *menuArray;
@property (nonatomic, strong) NSMutableArray *m_datas;
@property (nonatomic, strong) NSMutableArray *m_nameDatas;
@property (nonatomic, strong) NSMutableArray *m_nameGroupDatas;
@property (nonatomic, strong) NSMutableArray *m_dateArray;
@property (nonatomic, strong) NSMutableArray *m_groups;
@end

@implementation TheNewFriendListViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

//初始化数据
- (void)loadDataSource
{
    [_m_groups removeAllObjects];
    [_m_dateArray removeAllObjects];
    for (NSDictionary *dic in manger.friendLists)
    {
        if (!_m_groups) {
            _m_groups = [NSMutableArray array];
        }
        
        [_m_groups addObject:dic[@"DeptName"]];
        if (!_m_dateArray) {
            _m_dateArray = [NSMutableArray array];
        }
        NSArray *datas = dic[@"Users"];
        for (NSDictionary *dic in datas)
        {
            NewFriendModel *model = [NewFriendModel mj_objectWithKeyValues:dic];
            JCKLog(@"%@",model.EmployeeName);
        }
        
    }

        //创建一个数组
        _DataArray=[[NSMutableArray alloc] init];
        NSArray *titles = _m_groups;
        NSArray *subTitles = @[@[@"马化腾",@"乔布斯",@"库克",@"路飞",@"鸣人"],
                               @[@"马云",@"李彦宏",@"乔布斯",@"库克",@"路飞",@"鸣人"],
                               @[@"习近平",@"马云",@"马化腾",@"乔布斯",@"库克",@"路飞",@"鸣人"],
                               @[@"马云",@"李彦宏",@"路飞",@"鸣人"],
                               @[@"习近平",@"马云",@"马化腾",@"乔布斯",@"库克",@"路飞",@"鸣人"],
                               @[@"马云",@"李彦宏",@"乔布斯",@"库克"],
                               @[@"库克",@"路飞",@"鸣人"],
                               @[@"马云",@"李彦宏",@"乔布斯",@"库克",@"路飞",@"鸣人"]];
        for (int i=0;i<titles.count ; i++) {
            NSMutableArray *array=[[NSMutableArray alloc] init];
            for (int j=0; j< [_m_dateArray count];j++) {
                NSString *string= @"1";//[NSString stringWithFormat:@"%@",subTitles[i][j]];
                [array addObject:string];
            }
            
            NSString *string=[NSString stringWithFormat:@"%@",titles[i]];
            
            //创建一个字典 包含数组，分组名，是否展开的标示
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:array,DIC_ARARRY,string,DIC_TITILESTRING,[NSNumber numberWithInt:1],DIC_EXPANDED,nil];
            
            
            //将字典加入数组
            [_DataArray addObject:dic];
            [self initTableView];
        }

}
- (void)nameDatas:(NSArray *)arr
{
    [_m_nameDatas removeAllObjects];
    for (NSDictionary *dic in arr)
    {
        //        NSLog(@"%@ %@ %@",dic[@"Date"],dic[@"TotalCount"],dic[@"LeaveCount"]);
        NewFriendModel *model = [[NewFriendModel alloc] init];
        model.UserID          = [NSString stringWithFormat:@"%@",dic[@"UserID"]];
        model.EmployeeName    = [NSString stringWithFormat:@"%@",dic[@"EmployeeName"]];
        model.PhotoURL    = [NSString stringWithFormat:@"%@",dic[@"PhotoURL"]];
        if (_m_nameDatas.count == 0)
        {
            _m_nameDatas = [[NSMutableArray alloc] initWithCapacity:0];
        }
        [_m_nameDatas addObject: model];
    }
}
//初始化表
- (void)initTableView
{
    _tableVIew = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 119) style:UITableViewStylePlain];
    _tableVIew.dataSource=self;
    _tableVIew.delegate=self;
    [_tableVIew setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableVIew];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"联系人";
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfGetdeptusers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataSource) name:@"getdeptusers" object:nil];
    
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _DataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary *dic=[_DataArray objectAtIndex:section];
    NSArray *array=[dic objectForKey:DIC_ARARRY];
    
    //判断是收缩还是展开
    if (![[dic objectForKey:DIC_EXPANDED]intValue]) {
        return array.count;
    }else
    {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *array=[[_DataArray objectAtIndex:indexPath.section] objectForKey:DIC_ARARRY];

    NewFriendGroupCell *cell = [NewFriendGroupCell selectedCell:tableView];
    cell.nameLab.text = [array objectAtIndex:indexPath.row];
    return cell;
}
//设置分组头的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, CELL_HEIGHT)];
    hView.backgroundColor=[UIColor whiteColor];
    UIButton* eButton = [[UIButton alloc] init];
    //按钮填充整个视图
    eButton.frame = hView.frame;
    [eButton addTarget:self action:@selector(expandButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(8, 40/2-10/2, 10, 10)];
    
    //把节号保存到按钮tag，以便传递到expandButtonClicked方法
    eButton.tag = section;
    
    //设置图标
    //根据是否展开，切换按钮显示图片
    if ([self isExpanded:section])
    {
        img.image = [UIImage imageNamed:@"mark_down"];
//        [eButton setImage: [ UIImage imageNamed: @"mark_down" ]forState:UIControlStateNormal];
    }
    
    else
    {
        img.image = [UIImage imageNamed:@"mark_up"];
//        [eButton setImage: [ UIImage imageNamed: @"mark_up" ]forState:UIControlStateNormal];
    }
    [eButton addSubview:img];
    //设置分组标题
    eButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [eButton setTitle:[[_DataArray objectAtIndex:section]  objectForKey:DIC_TITILESTRING]forState:UIControlStateNormal];
    [eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置button的图片和标题的相对位置
    //4个参数是到上边界，左边界，下边界，右边界的距离
    eButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [eButton setTitleEdgeInsets:UIEdgeInsetsMake(5,30, 0,0)];
    [eButton setImageEdgeInsets:UIEdgeInsetsMake(5,ScreenWidth-20, 0,0)];
    
    //上显示线
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, -1, hView.frame.size.width,1)];
    label1.backgroundColor=RGB(245, 245, 245);
    [hView addSubview:label1];
    
    //下显示线
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, hView.frame.size.height-1, hView.frame.size.width,1)];
    label.backgroundColor= RGB(245, 245, 245);
    [hView addSubview:label];
    
    [hView addSubview: eButton];
    
    return hView;
    
}
//单元行内容递进
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 2;
}
//控制表头分组表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CELL_HEIGHT;
}

#pragma mark -- 内部调用
//对指定的节进行“展开/折叠”操作,若原来是折叠的则展开，若原来是展开的则折叠
-(void)collapseOrExpand:(int)section{
    NSMutableDictionary *dic=[_DataArray objectAtIndex:section];
    
    int expanded=[[dic objectForKey:DIC_EXPANDED] intValue];
    if (expanded) {
        [dic setValue:[NSNumber numberWithInt:0]forKey:DIC_EXPANDED];
    }else
    {
        [dic setValue:[NSNumber numberWithInt:1]forKey:DIC_EXPANDED];
    }
}
//返回指定节是否是展开的
-(int)isExpanded:(int)section{
    NSDictionary *dic=[_DataArray objectAtIndex:section];
    int expanded=[[dic objectForKey:DIC_EXPANDED] intValue];
    return expanded;
}

//按钮被点击时触发
-(void)expandButtonClicked:(id)sender{
    
    UIButton* btn= (UIButton*)sender;
    int section= btn.tag;//取得tag知道点击对应哪个块
    
    [self collapseOrExpand:section];
    
    //刷新tableview
    [_tableVIew reloadData];
    
}
- (void)seachBtnAction
{
    SeachFriendViewController *sub = [[SeachFriendViewController alloc] init];
    sub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)pushBtnAction
{
    ChatListViewController *sub = [[ChatListViewController alloc] init];
    sub.title = @"我的群组";
    sub.isOnlyGroup = 1;
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)pushBtnAction2
{
    ChatListViewController *sub = [[ChatListViewController alloc] init];
    sub.title = @"最近联系人";
    sub.isOnlyGroup = 2;
    [self.navigationController pushViewController:sub animated:YES];
   
}
@end
