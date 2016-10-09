//
//  TeamInfoViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TeamInfoViewController.h"
#import "TeamMenberModel.h"
@interface TeamInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *titles;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TeamInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.model.Sex isEqualToString:@"1"]) {
        self.model.Sex = @"男";
    }
    else if ([self.model.Sex isEqualToString:@"2"])
    {
        self.model.Sex = @"女";
    }
    else
    {
        self.model.Sex = @"未填写";
    }
    if (!self.model.Position) {
        self.model.Position = @"";
    }
    if (!self.model.Position) {
        self.model.Position = @"";
    }
    if (!self.model.Email) {
        self.model.Email = @"";
    }
    if (!self.model.CompanyName) {
        self.model.CompanyName = @"";
    }
    if (!self.model.MobilePhone) {
        self.model.MobilePhone = @"";
    }
    titles = @[[NSString stringWithFormat:@"名字: %@",self.model.LinkmanName],
               [NSString stringWithFormat:@"性别: %@",self.model.Sex],
               [NSString stringWithFormat:@"电话: %@",self.model.MobilePhone],
               [NSString stringWithFormat:@"公司/医院: %@",self.model.CompanyName],
               [NSString stringWithFormat:@"职务: %@",self.model.Position],
               [NSString stringWithFormat:@"E-mail: %@",self.model.Email]];
    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allCell = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCell];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = titles[indexPath.row];
    return cell;
}

@end
