//
//  CreditViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "CreditViewController.h"
#import "LXCircleAnimationView.h"
#import "UIView+Extensions.h"
@interface CreditViewController ()
@property (nonatomic, strong) LXCircleAnimationView *circleProgressView;
@end

@implementation CreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.circleProgressView = [[LXCircleAnimationView alloc] initWithFrame:CGRectMake(50.f, 70.f, SCREEN_WIDTH - 100.f, SCREEN_WIDTH - 100.f)];
    self.circleProgressView.bgImage = [UIImage imageNamed:@"backgroundImage"];
    self.circleProgressView.percent = 0.f;
    [self.view addSubview:self.circleProgressView];
    
    UIButton *stareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stareButton.frame = CGRectMake(10.f, self.circleProgressView.bottom + 50.f, SCREEN_WIDTH - 20.f, 38.f);
    [stareButton addTarget:self action:@selector(onStareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [stareButton setTitle:@"开始评价我的信用" forState:UIControlStateNormal];
    [stareButton setBackgroundColor:[UIColor lightGrayColor]];
    stareButton.layer.masksToBounds = YES;
    stareButton.layer.cornerRadius = 4.f;
    [self.view addSubview:stareButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onStareButtonClick {
    
    self.circleProgressView.percent = 40.f;
}

@end
