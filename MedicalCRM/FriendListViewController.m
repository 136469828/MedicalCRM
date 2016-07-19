//
//  FriendListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendListModel.h"
#import "FriendListRightCell.h"
#import "AddFriendViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "FriendViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
@interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate,CNContactPickerDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong) NSMutableArray *m_fansListsArray;
@property (nonatomic, strong) NSMutableArray *m_dateArray;
@property (nonatomic, strong) UITableView *tableViewRight;

@end

@implementation FriendListViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _tableViewRight = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableViewRight.tag = 6002;
    _tableViewRight.delegate = self;
    _tableViewRight.dataSource = self;
    [_tableViewRight setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableViewRight];
    if (!self.isAdd)
    {
        [self setHearView];
    }
    else
    {
#pragma mark - 设置navigationItem右侧按钮
        UIButton *meassageBut = ({
            UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
            meassageBut.frame = CGRectMake(0, 0, 35, 20);
            meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
            [meassageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [meassageBut addTarget:self action:@selector(popCtr) forControlEvents:UIControlEventTouchDown];
            [meassageBut setTitle:@"确认"  forState:UIControlStateNormal];
            meassageBut;
        });
        
        UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
        self.navigationItem.rightBarButtonItem = rBtn;
    }
}

- (void)setHearView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    bgView.backgroundColor = RGB(225, 225, 225);
    [topView addSubview:bgView];
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seachBtn.frame = CGRectMake(8,8,ScreenWidth-16,30);
    seachBtn.backgroundColor = [UIColor whiteColor];
    seachBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    seachBtn.layer.cornerRadius = 5;
    seachBtn.layer.masksToBounds = YES;
    [seachBtn setTitle:@"找人" forState:UIControlStateNormal];
    [seachBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [seachBtn addTarget:self action:@selector(seachBtnAction) forControlEvents:UIControlEventTouchDown];
    [bgView addSubview:seachBtn];
    NSArray *imgs = @[@"contact_friends_icon_normal",@"contact_group_icon_normal",@"contact_icon_attention"];
    NSArray *titles = @[@"新好友",@"群组",@"通讯录"];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*ScreenWidth/3, 40, ScreenWidth/3, 60);
        //        btn.backgroundColor = arr[i];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(btn.bounds.size.width/2 - 14, 10, 32, 28)];
        if (i == 2)
        {
            imgV.frame = CGRectMake(btn.bounds.size.width/2 - 14, 10, 28, 28);
        }
        imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgs[i]]];
        [btn addSubview:imgV];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0,  btn.bounds.size.height-20, btn.bounds.size.width, 20)];
        lab.text = [NSString stringWithFormat:@"%@",titles[i]];
        lab.font = [UIFont systemFontOfSize:13];
        lab.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:lab];
        btn.tag = 7000+i;
        [topView addSubview:btn];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchDown];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 105, ScreenWidth, 15)];
    line.backgroundColor = RGB(245, 245, 245);
    [topView addSubview:line];
    self.tableViewRight.tableHeaderView = topView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendListRightCell *cell = [FriendListRightCell selectedCell:tableView];
    if (!self.isAdd) {
        cell.selectedBtn.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isAdd)
    {
        RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
        conversationVC.conversationType =ConversationType_PRIVATE;
        conversationVC.targetId = @"10011"; //这里模拟自己给自己发消息，您可以替换成其他登录的用户的UserId 110
        conversationVC.title = @"安卓测试小王";
        conversationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
    else
    {
        [self.tableViewRight deselectRowAtIndexPath:indexPath animated:YES];
        
        FriendListRightCell *cell = (FriendListRightCell *)[self.tableViewRight cellForRowAtIndexPath:indexPath];
        FriendListModel *model = self.m_dateArray[indexPath.row];
        model.m_chooseBtn = !model.isChooseBtn;
        if (model.m_chooseBtn)
        { //选择了
            [self.m_fansListsArray addObject:model];
            
        }
        else
        { //取消
            [self.m_fansListsArray removeObject:model];
            
        }
        [cell rowSelected];
    }

}
#pragma mark - BtnAction
- (void)btnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 7000:
        {
            AddFriendViewController *sub = [[AddFriendViewController alloc] init];
            sub.title = @"添加好友";
            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
            break;
        case 7001:
        {

        }
            break;
        case 7002:
        {
            // 1.创建选择联系人的控制器
            CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
            // 2.设置代理
            contactVc.delegate = self;
            // 3.弹出控制器
            [self presentViewController:contactVc animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}
- (void)seachBtnAction
{
    FriendViewController *sub = [[FriendViewController alloc] init];
    sub.title = @"查找好友";
    [self.navigationController pushViewController:sub animated:YES];

}
- (void)popCtr
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入群组名"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认", nil];
    // 基本输入框，显示实际输入的内容
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    //设置输入框的键盘类型
    UITextField *tf = [alert textFieldAtIndex:0];
    
    UITextField *tf2 = [alert textFieldAtIndex:1];
    if (alert.alertViewStyle == UIAlertViewStylePlainTextInput) {
        // 对于用户名密码类型的弹出框，还可以取另一个输入框
        tf2 = [alert textFieldAtIndex:1];
        tf2.keyboardType = UIKeyboardTypeASCIICapable;
        NSString* text2 = tf2.text;
        NSLog(@"INPUT1:%@", text2);
    }
    
    // 取得输入的值
    NSString* text = tf.text;
    NSLog(@"INPUT:%@", text);
    if (alert.alertViewStyle == UIAlertViewStylePlainTextInput) {
        // 对于两个输入框的
        NSString* text2 = tf2.text;
        NSLog(@"INPUT2:%@", text2);
    }
    
    [alert show];

}
#pragma mark - contactVcDelegate
// ④实现代理方法
// 1.点击取消按钮调用的方法
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    NSLog(@"取消选择联系人");
}
// 2.当选中某一个联系人时会执行该方法
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
//{
//    // 1.获取联系人的姓名
//    NSString *lastname = contact.familyName;
//    NSString *firstname = contact.givenName;
//    NSLog(@"%@ %@", lastname, firstname);
//    
//    // 2.获取联系人的电话号码(此处获取的是该联系人的第一个号码,也可以遍历所有的号码)
//    NSArray *phoneNums = contact.phoneNumbers;
//    CNLabeledValue *labeledValue = phoneNums[0];
//    CNPhoneNumber *phoneNumer = labeledValue.value;
//    NSString *phoneNumber = phoneNumer.stringValue;
//    NSLog(@"%@", phoneNumber);
//}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",buttonIndex);
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        //TODO
        NSLog(@"nameField %@",nameField.text);
        if (buttonIndex == 1)
        {
            // 新建群聊
            NSArray *users = @[@"10011",@"110"];
            [[RCIM sharedRCIM] createDiscussion:nameField.text userIdList:users success:^(RCDiscussion *discussion) {
                NSLog(@"discussionId:%@ discussionName:%@",discussion.discussionId,discussion.discussionName);
                for (NSString *str in discussion.memberIdList) {
                    NSLog(@"memberIdList:%@",str);
                }
            } error:^(RCErrorCode status) {
                NSLog(@"%ld",(long)status);
            }];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}
- (NSMutableArray *)m_fansListsArray
{
    if (_m_fansListsArray == nil)
    {
        _m_fansListsArray = [NSMutableArray array];
    }
    return _m_fansListsArray;
    
}

@end
