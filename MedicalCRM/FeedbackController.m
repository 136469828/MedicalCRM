//
//  FeedbackController.m
//  MedicalCRM
//
//  Created by admin on 16/8/2.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "FeedbackController.h"
#import "NetManger.h"
#import "KeyboardToolBar.h"
@interface FeedbackController ()<UITextViewDelegate>
{
    NetManger *manger;
}
@end

@implementation FeedbackController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    manger = [NetManger shareInstance];
    manger.sType = nil;
//    [self.product addSubview:title];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    bg.image = [UIImage imageNamed:@"score_icon_no_select"];
//    bg.tag = 10;
//    [self.product addSubview:bg];
//    [self.product addTarget:self action:@selector(productAction) forControlEvents:UIControlEventTouchDown];
//    for (int i = 0; i<3; i++)
//    {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(20+i*110, 300, 90, 30);
////        btn.backgroundColor = [UIColor redColor];
//        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 60, 30)];
//        title.text = titles[i];
//        title.font = [UIFont systemFontOfSize:11];
//        [btn addSubview:title];
//        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15-9, 18, 18)];
//        bg.image = [UIImage imageNamed:@"score_icon_no_select"];
//        [btn addSubview:bg];
//        btn.tag = 100+i;
//        [btn addTarget:self action:@selector(productAction:) forControlEvents:UIControlEventTouchDown];
//        [self.view addSubview:btn];
//    }
     [self.btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchDown];
    self.textView.font = [UIFont systemFontOfSize:13];
    self.textView.text = @"请输入提交的内容...";
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.delegate = self;
    [KeyboardToolBar registerKeyboardToolBar: self.titleTF];

    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:recognizer];
    
    
    
    UISwipeGestureRecognizer *recognizers;
    
    recognizers = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizers setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizers];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - textViewdelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@"请输入提交的内容..."])
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
        self.textView.text=@"请输入提交的内容...";
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
- (void)btnAction
{
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:@"请输入提交的内容..."] || self.titleTF.text.length == 0)
    {
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"部分信息为空,请补全" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    else
    {
        JCKLog(@"%@",manger.sType);
        manger.title = self.titleTF.text;
        manger.context = self.textView.text;
        manger.sType = self.stpy;
        [manger loadData:RequestOfPersonaladvicesendsave];
        [self.navigationController popViewControllerAnimated:YES];
    }


}
- (void)productAction:(UIButton *)btn
{
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:100];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:101];
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:102];
    switch (btn.tag) {
        case 100:
        {
            btn2.selected = NO;
            btn3.selected = NO;
            
            UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15-9, 18, 18)];
            bg.image = [UIImage imageNamed:@"score_icon_select.png"];

            [btn1 addSubview:bg];
            
            UIImageView *bg2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15-9, 18, 18)];
            bg2.image = [UIImage imageNamed:@"score_icon_no_select"];

            [btn2 addSubview:bg2];
            
            UIImageView *bg3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15-9, 18, 18)];
            bg3.image = [UIImage imageNamed:@"score_icon_no_select"];

            [btn3 addSubview:bg3];
            
            manger.sType = @"1";
        }
            break;
        case 101:
        {
            btn1.selected = NO;
            btn3.selected = NO;
            
            UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15-9, 18, 18)];
            bg.image = [UIImage imageNamed:@"score_icon_select.png"];

            [btn2 addSubview:bg];
            
            UIImageView *bg2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15-9, 18, 18)];
            bg2.image = [UIImage imageNamed:@"score_icon_no_select"];

            [btn1 addSubview:bg2];
            
            UIImageView *bg3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15-9, 18, 18)];
            bg3.image = [UIImage imageNamed:@"score_icon_no_select"];

            [btn3 addSubview:bg3];
            manger.sType = @"2";
        }
            break;
        case 102:
        {
            btn2.selected = NO;
            btn1.selected = NO;
            
            UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15-9, 18, 18)];
            bg.image = [UIImage imageNamed:@"score_icon_select.png"];

            [btn3 addSubview:bg];
            
            UIImageView *bg2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15-9, 18, 18)];
            bg2.image = [UIImage imageNamed:@"score_icon_no_select"];

            [btn2 addSubview:bg2];
            
            UIImageView *bg3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15-9, 18, 18)];
            bg3.image = [UIImage imageNamed:@"score_icon_no_select"];

            [btn1 addSubview:bg3];
            manger.sType = @"3";
        }
            break;
            
        default:
            break;
    }
//    if (btn.selected)
//    {
//        
//        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15-9, 18, 18)];
//        bg.image = [UIImage imageNamed:@"score_icon_no_select"];
//        bg.tag = 10;
//        [btn addSubview:bg];
//        btn.selected = !self.product.isSelected;
//    }
//    else
//    {
//        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15-9, 18, 18)];
//        bg.image = [UIImage imageNamed:@"score_icon_select.png"];
//
//        [btn addSubview:bg];
//        btn.selected = !self.product.isSelected;
//    }
}
//手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.textView endEditing:YES];
    
}
@end
