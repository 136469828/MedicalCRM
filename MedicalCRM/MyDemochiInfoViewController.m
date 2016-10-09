//
//  MyDemochiInfoViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "MyDemochiInfoViewController.h"
#import "NetManger.h"
#import "MJExtension.h"
#import "DemoChiInfoModel.h"
@interface MyDemochiInfoViewController ()

@end

@implementation MyDemochiInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NetManger shareInstance]loadData:RequestOfGetsellsample];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relodatas) name:@"getsellsample" object:nil];
}
- (void)relodatas
{
    for (NSDictionary *dic in [NetManger shareInstance].getsellsamples)
    {
        DemoChiInfoModel *mdoel = [DemoChiInfoModel mj_objectWithKeyValues:dic];
    }
 
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
