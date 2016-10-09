//
//  PublishedController.m
//  PinFan
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "PublishedController.h"
#import "ZLPhotoActionSheet.h"
#import "ZLShowBigImage.h"
#import "KeyboardToolBar.h"
#import "CustomerListViewController.h"
#import "NetManger.h"
#import "TheNewCustomerViewController.h"
#import "TheProjectListViewController.h"
@interface PublishedController ()<UITextViewDelegate>
{
    ZLPhotoActionSheet *actionSheet;
    UIButton *btn;
    NSString *phoneNum;
    NSString *coustomerId;
    NSString *proId;
}
@property (nonatomic ,strong) NSMutableArray *m_cutomArray;
@end

@implementation PublishedController
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas:) name:@"cuNameStr" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 5;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 20;
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 30, 25);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut addTarget:self action:@selector(disCtr) forControlEvents:UIControlEventTouchDown];
        [meassageBut setTitle:@"确认" forState:UIControlStateNormal];
        [meassageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    
    self.textView.font = [UIFont systemFontOfSize:13];
    self.textView.text = @"请输入发布的内容...";
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.delegate = self;
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(8,5,[UIScreen mainScreen].bounds.size.width/4-20,[UIScreen mainScreen].bounds.size.width/4-20);
//    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchDown];
//    [self.bgView addSubview:btn];
    [KeyboardToolBar registerKeyboardToolBar:self.projectFild];
    [KeyboardToolBar registerKeyboardToolBar:self.yiyuanTf];
    [KeyboardToolBar registerKeyboardToolBar:self.phoneTextFild];
    
    self.colseCustom.layer.cornerRadius = 5;
    self.colseCustom.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.colseCustom.layer.borderWidth = 0.5;
    [self.colseCustom addTarget:self action:@selector(colseCutom) forControlEvents:UIControlEventTouchDown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
- (void)test
{
    __weak typeof(self) weakSelf = self;
    
    [actionSheet showWithSender:self animate:YES completion:^(NSArray<UIImage *> * _Nonnull selectPhotos) {
        [weakSelf.self.bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width/4-20;
        for (int i = 0; i < selectPhotos.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i%4*(width+2), i/4*(width+2), width, width)];
            imgView.image = selectPhotos[i];
            [weakSelf.self.bgView addSubview:imgView];
            btn.frame = CGRectMake((i+1)%4*(width+2),0, width, width);
            [self.bgView addSubview:btn];
        }
    }];
}

#pragma mark -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    for (UIView *view in self.bgView.subviews) {
        CGRect convertRect = [self.bgView convertRect:view.frame toView:self.view];
        if ([view isKindOfClass:[UIImageView class]] &&
            CGRectContainsPoint(convertRect, point)) {
            [ZLShowBigImage showBigImage:(UIImageView *)view];
            break;
        }
    }
    [self.view endEditing:YES];
}
#pragma mark - textViewdelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@"请输入发布的内容..."])
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
        self.textView.text=@"请输入发布的内容...";
        self.textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}
- (void)disCtr
{
    if (coustomerId.length == 0 || [self.textView.text isEqualToString:@"请输入发布的内容..."])
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整相关信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }
    else
    {
        if (self.phoneTextFild.text.length == 0)
        {
            self.phoneTextFild.text = @"无";
        }
        JCKLog(@"%@",[self valiMobile:self.phoneTextFild.text]);
        NSString *str = [self valiMobile:self.phoneTextFild.text];
//        if (str.length > 1)
//        {
//            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [al show];
//        }
//        else
        {
            if (!proId)
            {
                proId = @"";
            }
            if (!coustomerId)
            {
                coustomerId = @"";
            }
            NetManger *manger = [NetManger shareInstance];
            manger.sigins = @[coustomerId,
                              coustomerId,
                              self.textView.text,
                              self.textView.text,
                              self.lat,
                              self.lon,
                              self.phoneTextFild.text,
                              self.address,
                              proId];
            NSLog(@"%@",manger.sigins);
            [manger loadData:RequestOfCustcontactsave];
            [self.navigationController popViewControllerAnimated:YES];
        }

    }

}
- (IBAction)projectBtn:(UIButton *)sender
{
    TheProjectListViewController *sub = [[TheProjectListViewController alloc] init];
    sub.title = @"请选择项目";
    sub.block = ^(NSString *str,NSString *ID){
        JCKLog(@"%@",str);
        self.projectFild.text = [str substringFromIndex:4];
        proId = ID;
    };
    [self.navigationController pushViewController:sub animated:YES];
    
}
- (void)colseCutom
{
    TheNewCustomerViewController *sub = [[TheNewCustomerViewController alloc] init];
    sub.title = @"客户列表";
    sub.block = ^(NSString *str, NSString *ID, NSString *phone,NSString *CompanyName,NSString *linkId)
    {
        coustomerId = ID;
        self.phoneTextFild.text = phone;
        self.keshiTf.text = @"科长";
        [self.colseCustom setTitle:str forState:UIControlStateNormal];
        self.yiyuanTf.text = CompanyName;
    };
    [self.navigationController pushViewController:sub animated:YES];

}
#pragma mark - Tool
- (NSString *)valiMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
        return @"手机号少于11位";
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return nil;
        }else{
            return @"请输入正确手机号";
        }
    }
    return nil;
}

//- (void)reloadDatas:(NSNotification *)obj
//{
//    NSLog(@"userInfo - %@",obj.object);
//    [_m_cutomArray removeAllObjects];
//    for (NSString *str in obj.object)
//    {
//        if (_m_cutomArray == nil)
//        {
//            _m_cutomArray = [NSMutableArray array];
//        }
//        [_m_cutomArray addObject:str];
//    }
//    self.phoneTextFild.text = [NSString stringWithFormat:@"%@",[_m_cutomArray objectAtIndex:2]];
//    [self.colseCustom setTitle:[_m_cutomArray lastObject] forState:UIControlStateNormal];
//}

@end
