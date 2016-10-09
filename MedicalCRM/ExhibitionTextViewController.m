//
//  ExhibitionTextViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/13.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ExhibitionTextViewController.h"
#import "ExhibitionBulidModel.h"
@interface ExhibitionTextViewController ()<UITextViewDelegate>

@end

@implementation ExhibitionTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    JCKLog(@"%ld",self.stpy);
    self.textView.delegate = self;
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 40, 20);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [meassageBut addTarget:self action:@selector(popCtr) forControlEvents:UIControlEventTouchDown];
        [meassageBut setTitle:@"保存" forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];

    self.navigationItem.rightBarButtonItem = rBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - textViewdelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入..."])
    {
        self.textView.text=@"";
    }
    self.textView.textColor = [UIColor blackColor];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ( self.textView.text.length == 0)
    {
        self.textView.text=@"请输入...";
        self.textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}
- (void)commentTableViewTouchInSide{
    [self.textView endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.textView endEditing:YES];
}
- (void)popCtr
{
    if (self.block)
    {
        self.block(_textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
