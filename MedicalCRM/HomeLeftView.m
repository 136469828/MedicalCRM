//
//  HomeLeftView.m
//  MedicalCRM
//
//  Created by admin on 16/9/7.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "HomeLeftView.h"
#import "HomeLeftCell.h"
@implementation HomeLeftView
{
    NSArray *titles;
    NSArray *imgs;
     NSArray *selectImgs;
    NSArray *sectionTitles;
}
- (id)initWithFrame:(CGRect)frame{
    titles = @[@[@"我的人生导航"],@[@"我的拜访",@"我的重要工作",@"我领导的团队"],@[@"我的业绩表现",@"我的行为表现",@"我的团队精神"]];
    imgs = @[@[@"daohang_home"],@[@"baifang_home",@"shixiang_home",@"tuandui_home"],@[@"yeji_home",@"xingwei_home",@"jingshen_home"]];
    selectImgs = @[@[@"daohang_select_home"],@[@"baifang_select_home",@"shixiang_select_home",@"tuandui_select_home"],@[@"yeji_select_home",@"xingwei_select_home",@"jingshen_select_home"]];
    
    sectionTitles = @[@"★人生导航",@"★我的奋斗历程",@"★我实现的结果"];
    self.backgroundColor = RGBColor(239, 238, 244);
    self = [super initWithFrame:frame ];
    if (self) {
        [self _initTableView];
    }
    return self;
}
- (void)_initTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _selIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:_selIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
    [_tableView registerNib:[UINib nibWithNibName:@"HomeLeftCell" bundle:nil] forCellReuseIdentifier:@"HomeLeftCell"];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.showsVerticalScrollIndicator = NO;

    [self addSubview:_tableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titles[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  // 返回组的头宽
{
    return 29;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section // 返回组的尾宽
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  // 返回一个UIView作为头视图
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.25, 30)];
    bgView.layer.shadowColor = [[UIColor blackColor] CGColor];
    bgView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f); // [水平偏移, 垂直偏移]
    bgView.layer.shadowOpacity = 0.2; // 0.0 ~ 1.0 的值
    bgView.layer.shadowRadius = 2.0f; // 陰影發散的程度
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, ScreenWidth*0.25, 30-2)];
    lb.text = sectionTitles[section];
    lb.backgroundColor = RGB(242, 242, 242);
    lb.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    lb.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:lb];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 9, 10, 10)];
    imgV.image = [UIImage imageNamed:@"Artboard 26"];
    imgV.backgroundColor = RGB(242, 242, 242);
//    [bgView addSubview:imgV];
    return bgView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ScreenHeight*0.08+3);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeLeftCell"];
//    cell.selectView.hidden = YES;
//    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12,(ScreenHeight*0.08+3), ScreenWidth*0.25 - 24, 1)];
    line.backgroundColor = RGB(222, 222, 222);
    [cell.contentView addSubview:line];
    cell.titleLab.text = [NSString stringWithFormat:@"%@",titles[indexPath.section][indexPath.row]];
    cell.imgV.image = [UIImage imageNamed:imgs[indexPath.section][indexPath.row]];

    //当上下拉动的时候，因为cell的复用性，我们需要重新判断一下哪一行是打勾的
    if (_selIndex == indexPath)
    {
        cell.JCKJTImg.hidden = NO;
//        cell.selectLine.hidden = YES;
//        cell.backgroundColor = [UIColor whiteColor];
        cell.testBGImgView.image = [UIImage imageNamed:selectImgs[indexPath.section][indexPath.row]];
    }else {
        cell.JCKJTImg.hidden = YES;
//        cell.selectLine.hidden = NO;
//        cell.backgroundColor = RGBColor(238, 238, 238);
        cell.testBGImgView.image = [UIImage imageNamed:imgs[indexPath.section][indexPath.row]];

    }
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    HomeLeftCell *cell = (HomeLeftCell*)[tableView cellForRowAtIndexPath:indexPath];
//    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
//    cell.JCKJTImg.hidden = NO;
    //之前选中的，取消选择
    HomeLeftCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
    celled.JCKJTImg.hidden = YES;
//    celled.selectLine.hidden = NO;
//    celled.backgroundColor = RGBColor(238, 238, 238);
    celled.testBGImgView.image = [UIImage imageNamed:imgs[_selIndex.section][_selIndex.row]];
    //记录当前选中的位置索引
    _selIndex = indexPath;
    //当前选择的打勾
    HomeLeftCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.JCKJTImg.hidden = NO;
//    cell.selectLine.hidden = YES;
//    cell.backgroundColor = [UIColor whiteColor];
    cell.testBGImgView.image = [UIImage imageNamed:selectImgs[indexPath.section][indexPath.row]];
    NSInteger idex = indexPath.section *10 +indexPath.row;
    _blk(idex);
}
@end
