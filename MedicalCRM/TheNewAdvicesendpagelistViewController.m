//
//  TheNewAdvicesendpagelistViewController.m
//  MedicalCRM
//
//  Created by admin on 16/9/1.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "TheNewAdvicesendpagelistViewController.h"

@interface TheNewAdvicesendpagelistViewController ()<UIScrollViewDelegate>


@property (nonatomic, strong) UITableView *tableViewLeft;
@property (nonatomic, strong) UITableView *tableViewRight;
@property(nonatomic,strong) UIScrollView *m_scrollView;
@property (nonatomic, strong) UIView *m_slideView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TheNewAdvicesendpagelistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 20, 20);
        [meassageBut addTarget:self action:@selector(pushBulidCtr) forControlEvents:UIControlEventTouchDown];
        [meassageBut setImage:[UIImage imageNamed:@"addIcon"]forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    self.m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight)];
    //手动滑动的范围
    self.m_scrollView.contentSize = CGSizeMake(ScreenWidth*2, 0);
    // 分页属性
    self.m_scrollView.pagingEnabled = YES;
    self.m_scrollView.delegate = self;
    [self.view addSubview:self.m_scrollView];
    
    //    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHiegth)];
    //    view1.backgroundColor = [UIColor yellowColor];
    //    [self.m_scrollView addSubview:view1];
    //
    //    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHiegth)];
    //    view2.backgroundColor = [UIColor blueColor];
    //    [self.m_scrollView addSubview:view2];
    
    
    [self createTopView];
}



- (void)createTopView
{
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = CGRectMake(0, 20, ScreenWidth, 40);
//    backgroundView.backgroundColor = [UIColor redColor];
    [self.view addSubview:backgroundView];
    
    NSArray *titleArray = @[@"产品意见",@"商务意见",@"技术意见"];
    CGFloat labelW = ScreenWidth / 3;  //数组里面有几个就除以几
    //遍历titleArray数组(从下标0开始) 返回obj(label的内容),idx(从下标0开始)
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(idx * labelW, 0,labelW, 40);
        label.text = obj;
        //设置文本内容居中
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        label.tag = idx;
        [backgroundView addSubview:label];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        [label addGestureRecognizer:tap];
        
    }];
    
    //滑动条
    self.m_slideView = [[UIView alloc] init];
    self.m_slideView.frame = CGRectMake(0, 40-2, labelW, 2);
    self.m_slideView.backgroundColor = [UIColor orangeColor];
    [backgroundView addSubview:self.m_slideView];
}



//单击label的时候scrollView滑动范围
- (void)tapHandler:(UITapGestureRecognizer *)tap
{
    //view(表示当前对应的label)  获取视图对应的Tag值
    NSInteger i = tap.view.tag;
    
    [self.m_scrollView setContentOffset:CGPointMake(i * ScreenWidth, 0) animated:YES];
    
}



#pragma mark - UIScrollViewDelegate
// 手势滑动视图减速完成后调用方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        NSInteger i = self.m_scrollView.contentOffset.x / ScreenWidth;
        
        self.m_slideView.frame = CGRectMake((ScreenWidth/3)*i, 40-2,ScreenWidth/3,2);
    }];
}


//点击手势视图完成后调用方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        NSInteger i = self.m_scrollView.contentOffset.x / ScreenWidth;
        self.m_slideView.frame = CGRectMake((ScreenWidth/3)*i, 40-2,ScreenWidth/3,2);
    }];
}
@end
