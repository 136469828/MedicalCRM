//
//  FeedbackProductController.m
//  MedicalCRM
//
//  Created by admin on 16/9/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "FeedbackProductController.h"
#import "NetManger.h"
#import "KeyboardToolBar.h"
#import "EquipmentListViewController.h"
@interface FeedbackProductController ()<UITextViewDelegate>
{
    NetManger *manger;
}

@end

@implementation FeedbackProductController
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
    self.productBtn.layer.cornerRadius = 3;
    self.productBtn.layer.borderWidth = 0.5;
    self.productBtn.layer.borderColor = RGB(234, 234, 234).CGColor;
    [self.productBtn addTarget:self action:@selector(clooseProdeuct:) forControlEvents:UIControlEventTouchDown];
    
    [self.btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchDown];
    
    self.textView.font = [UIFont systemFontOfSize:13];
    self.textView.text = @"请输入提交的内容...";
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.delegate = self;
    [KeyboardToolBar registerKeyboardToolBar: self.titleTextField];

    
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
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:@"请输入提交的内容..."] || self.titleTextField.text.length == 0)
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
        manger.title = self.titleTextField.text;
        manger.context = self.textView.text;
        manger.sType = self.stpy;
        [manger loadData:RequestOfPersonaladvicesendsave];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
- (void)clooseProdeuct:(UIButton *)btn
{
    EquipmentListViewController *sub = [[EquipmentListViewController alloc] init];
    sub.title = @"选择样机名";
    sub.block = ^(NSArray *demoName,NSArray *demoIDs)
    {
        NSString *ns=[demoName componentsJoinedByString:@","];
//        model.demoMachiNames = ns;
        [btn setTitle:[NSString stringWithFormat:@"\t%@",ns] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        model.demoMachiIDs = demoIDs;
        //                    UILabel *lb = (UILabel *)[_tableView viewWithTag:4001];
        //                    model.demoMachiName = ns;
        //                    lb.text = model.demoMachiName;
        //                    //            model.demoMachiId = ID;
//        [_tableViewLeft reloadData];
    };
    [self.navigationController pushViewController:sub animated:YES];
}
//手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.textView endEditing:YES];

}
@end
