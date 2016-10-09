//
//  DayPlanImportantViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "DayPlanImportantViewController.h"

@interface DayPlanImportantViewController ()
{
    NSArray *titles;
}
@end

@implementation DayPlanImportantViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    titles = @[@"重要",@"一般"];
    [self setTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setTableView{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma  mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndenfier = @"cell";
    UITableViewCell *cell = nil;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
        
    }
    cell.textLabel.text = titles[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    NSLog(@"%@",cell.textLabel.text);
    // 回调
    if (cell.textLabel.text.length != 0 )
    {
        if (self.block)
        {
            self.block(cell.textLabel.text);
        }
    }
    else
    {
        NSLog(@"nil");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
