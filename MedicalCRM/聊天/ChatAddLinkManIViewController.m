//
//  ChatAddLinkManIViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/17.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ChatAddLinkManIViewController.h"
#import "NetManger.h"
@interface ChatAddLinkManIViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ChatAddLinkManIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
