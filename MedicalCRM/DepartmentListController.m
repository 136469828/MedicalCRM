//
//  DepartmentListController.m
//  MedicalCRM
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "DepartmentListController.h"
#import "NetManger.h"
#define  DIC_EXPANDED @"expanded" //是否是展开 0收缩 1展开
#define  DIC_ARARRY @"array"
#define  DIC_TITILESTRING @"title"

#define  CELL_HEIGHT 40.0f
@interface DepartmentListController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
    UITableView *_tableVIew;
    
    NSMutableArray *_DataArray;
}
@property(nonatomic,strong) NSArray *menuArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DepartmentListController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        /*
         主要思路：
         1.tableView:tableView viewForHeaderInSection:section 添加一个按钮
         2.点击按钮后，判断指定section的数据是否展开
         3.在返回numberOfRowsInSection数量时，如果发现是收缩的，则返回0，展开时，才给真实数据的行号
         这样就可以达到显示/隐含数据的效果
         */
    }
    return self;
}
//初始化数据
- (void)initDataSource
{
    manger = [NetManger shareInstance];
    //创建一个数组
    _DataArray=[[NSMutableArray alloc] init];
    NSArray *titles = manger.departments;
    NSArray *subTitles = @[@[@"我的设备",@"暂无更多好友"],@[@"无更多好友"],@[@"3232"],@[@" "],@[@" "]];
    for (int i=0;i<titles.count ; i++) {
        NSMutableArray *array=[[NSMutableArray alloc] init];
        for (int j=0; j< [[subTitles objectAtIndex:i] count];j++) {
            NSString *string=[NSString stringWithFormat:@"%@",subTitles[i][j]];
            [array addObject:string];
        }
        
        NSString *string=[NSString stringWithFormat:@"%@",titles[i]];
        
        //创建一个字典 包含数组，分组名，是否展开的标示
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:array,DIC_ARARRY,string,DIC_TITILESTRING,[NSNumber numberWithInt:0],DIC_EXPANDED,nil];
        
        
        //将字典加入数组
        [_DataArray addObject:dic];
    }
}
//初始化表
- (void)initTableView
{
    _tableVIew = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableVIew.dataSource=self;
    _tableVIew.delegate=self;
    [_tableVIew setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableVIew];
    [self registerNib];
}
#pragma mark - 注册Cell
- (void)registerNib{
    NSArray *registerNibs = @[@"FriendCell"];
    for (int i = 0 ; i < registerNibs.count; i++) {
        [_tableVIew registerNib:[UINib nibWithNibName:registerNibs[i] bundle:nil] forCellReuseIdentifier:registerNibs[i]];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 设置导航默认标题的颜色及字体大小
    [super viewDidLoad];
    [self initDataSource];
    [self initTableView];
    
    self.menuArray = @[@{@"imageName":@"seach_icon", @"title":@"扫一扫"},@{@"imageName":@"linkMan_icon", @"title":@"添加好友"}];
    UIButton *rightBut = ({
        UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBut.frame = CGRectMake(0, 0, 20, 20);
        [rightBut addTarget:self action:@selector(menuTap:) forControlEvents:UIControlEventTouchDown];
        [rightBut setImage:[UIImage imageNamed:@"add_icon"]forState:UIControlStateNormal];
        rightBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = rBtn;
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
    
    if (section == 0) {
        //判断是收缩还是展开
        if (![[dic objectForKey:DIC_EXPANDED]intValue]) {
            return array.count;
        }else
        {
            return 0;
        }
    }
    //判断是收缩还是展开
    if ([[dic objectForKey:DIC_EXPANDED]intValue]) {
        return array.count;
    }else
    {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *array=[[_DataArray objectAtIndex:indexPath.section] objectForKey:DIC_ARARRY];
    
        static NSString *acell=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:acell];
        if (cell == nil)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:acell];
    //        [cell.contentView addSubview:nameLab];
    //        [cell.contentView addSubview:stateLab];
    //        [cell.contentView addSubview:friendImg];
    //
        }
        // 对cell 进行简单地数据配置
        cell.textLabel.text = [array objectAtIndex:indexPath.row];;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"[在线] 更新了基地动态"];
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
    
    
    //把节号保存到按钮tag，以便传递到expandButtonClicked方法
    eButton.tag = section;
    
    //设置图标
    //根据是否展开，切换按钮显示图片
    if ([self isExpanded:section])
        [eButton setImage: [ UIImage imageNamed: @"mark_up" ]forState:UIControlStateNormal];
    else
        [eButton setImage: [ UIImage imageNamed: @"mark_down" ]forState:UIControlStateNormal];
    //设置分组标题
    eButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [eButton setTitle:[[_DataArray objectAtIndex:section]  objectForKey:DIC_TITILESTRING]forState:UIControlStateNormal];
    [eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置button的图片和标题的相对位置
    //4个参数是到上边界，左边界，下边界，右边界的距离
    eButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [eButton setTitleEdgeInsets:UIEdgeInsetsMake(5,18, 0,0)];
    [eButton setImageEdgeInsets:UIEdgeInsetsMake(5,ScreenWidth-20, 0,0)];
    
    //上显示线
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, -1, hView.frame.size.width,1)];
    label1.backgroundColor=RGB(172, 172, 172);
    [hView addSubview:label1];
    
    //下显示线
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, hView.frame.size.height-1, hView.frame.size.width,1)];
    label.backgroundColor= RGB(172, 172, 172);
    [hView addSubview:label];
    
    [hView addSubview: eButton];
    
    return hView;
    
}
//单元行内容递进
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 3;
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

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    manger = [NetManger shareInstance];
//    [self setTableView];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//#pragma mark -
//- (void)setTableView
//{
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStyleGrouped];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
//    self.tableView.estimatedRowHeight = 200;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
//    [self.view addSubview:_tableView];
//}
//#pragma mark - UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return manger.departments.count;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *allCell = @"cell";
//    UITableViewCell *cell = nil;
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
//        cell.selectionStyle = UITableViewCellAccessoryNone;
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",manger.departments[indexPath.row]];
//    return cell;
//}

@end
