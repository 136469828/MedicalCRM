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
@interface PublishedController ()<UITextViewDelegate>
{
    ZLPhotoActionSheet *actionSheet;
    UIButton *btn;
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
        [meassageBut setTitle:@"发送" forState:UIControlStateNormal];
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
    [self.bgView addSubview:btn];
    
    [KeyboardToolBar registerKeyboardToolBar:self.nameTextFild];
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
    NetManger *manger = [NetManger shareInstance];
    manger.sigins = @[self.m_cutomArray[0],self.m_cutomArray[1],self.m_cutomArray[2],self.textView.text,self.lat,self.lon];
    NSLog(@"%@",manger.sigins);
    [manger loadData:RequestOfCustcontactsave];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)colseCutom
{
    CustomerListViewController *sub = [[CustomerListViewController alloc] init];
    sub.title = @"客户列表";
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)reloadDatas:(NSNotification *)obj
{
    NSLog(@"userInfo - %@",obj.object);
    [_m_cutomArray removeAllObjects];
    for (NSString *str in obj.object)
    {
        if (_m_cutomArray == nil)
        {
            _m_cutomArray = [NSMutableArray array];
        }
        [_m_cutomArray addObject:str];
    }
    
    [self.colseCustom setTitle:[_m_cutomArray lastObject] forState:UIControlStateNormal];
}

@end
