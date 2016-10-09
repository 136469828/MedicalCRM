//
//  JCKConversationViewController.m
//  MedicalCRM
//
//  Created by admin on 16/8/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "JCKConversationViewController.h"
#import "ChatLinkManInfoViewController.h"
#import "ChatViewController.h"
#import "NetManger.h"
#import "NewFriendInfoModel.h"
#import "AddFriendListViewController.h"
#import "TheFriendListViewController.h"
#import "ChatLinkManMembersViewController.h"
#import "ChatGroupMembersViewController.h"
@interface JCKConversationViewController ()<RCIMGroupMemberDataSource>
{
    BOOL isSelcet;
    NSString *pasteboardStr;
    NSInteger isImg;
    NSString *registerStr;
    id isSame;
    NSInteger messageId;
    RCMessageModel *messageModel;
}
@property (nonatomic, strong) NSMutableArray *contexts;
@property (nonatomic, strong) NSMutableArray *models;
@end

@implementation JCKConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //加号区域增加发送文件功能。
    UIImage *imageFile = [RCKitUtility imageNamed:@"actionbar_file_icon"
                                         ofBundle:@"RongCloud.bundle"];
    [self.pluginBoardView insertItemWithImage:imageFile
                                        title:@"发送文件"
                                      atIndex:3
                                          tag:PLUGIN_BOARD_ITEM_FILE_TAG];
    JCKLog(@"%ld",self.conversationType);
    if (self.conversationType == 2)
    {
#pragma mark - 设置navigationItem右侧按钮
        UIButton *meassageBut = ({
            UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
            meassageBut.frame = CGRectMake(0, 0, 30, 30);
            [meassageBut addTarget:self action:@selector(pushChatLinkManInfoViewController) forControlEvents:UIControlEventTouchDown];
            [meassageBut setImage:[UIImage imageNamed:@"三点hover"]forState:UIControlStateNormal];
            meassageBut;
        });
        
        UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
        self.navigationItem.rightBarButtonItem = rBtn;
        
#pragma - mark 中间按钮
        UIButton *seachButton = ({
            UIButton *seachButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            seachButton.layer.borderWidth = 1.0; // set borderWidth as you want.
//            seachButton.layer.cornerRadius = 3.0f;
//            seachButton.layer.masksToBounds=YES;
//            seachButton.layer.borderColor = RGB(245, 245, 245).CGColor;
            seachButton.backgroundColor = [UIColor clearColor];
            seachButton.frame = CGRectMake(0, 0, ScreenWidth/1.3, 25);
            seachButton.titleLabel.font = [UIFont systemFontOfSize:17];
            [seachButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [seachButton setTitle:self.title  forState:UIControlStateNormal];
            [seachButton addTarget:self action:@selector(changeGroupName) forControlEvents:UIControlEventTouchDown];
            seachButton;
        });
        self.navigationItem.titleView = seachButton;
    }    else
    {
#pragma mark - 设置navigationItem右侧按钮
        UIButton *meassageBut = ({
            UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
            meassageBut.frame = CGRectMake(0, 0, 30, 30);
            [meassageBut addTarget:self action:@selector(pushChatLinkManInfoViewController) forControlEvents:UIControlEventTouchDown];
            [meassageBut setImage:[UIImage imageNamed:@"三点hover"]forState:UIControlStateNormal];
            meassageBut;
        });
        
        UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
        self.navigationItem.rightBarButtonItem = rBtn;
    }
    RCIM *rcim = [RCIM sharedRCIM];
    rcim.enableMessageMentioned = YES;
    rcim.enableMessageRecall = YES;
    
    [_contexts removeAllObjects];
    if (!_contexts) {
        _contexts = [NSMutableArray array];
    }
    [_models removeAllObjects];
    if (!_models) {
        _models = [NSMutableArray array];
    }
    self.enableSaveNewPhotoToLocalSystem = YES;// 保存图片到本地
}
- (void)moreAction
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.frame = CGRectMake(40.0f,0,self.view.frame.size.width-40,self.view.frame.size.height);

    }];
    self.navigationItem.rightBarButtonItem = nil;
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 30, 30);
        [meassageBut addTarget:self action:@selector(forwarding) forControlEvents:UIControlEventTouchDown];
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:13];
        [meassageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [meassageBut setTitle:@"转发" forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
}

- (void)forwarding
{
    
    TheFriendListViewController *sub = [[TheFriendListViewController alloc] init];
    sub.title = @"选择好友";
    sub.contextArr = _contexts;
    sub.hidesBottomBarWhenPushed = YES;
    sub.isImg = 3;
    [self.navigationController pushViewController:sub animated:YES];
    if (self.conversationType == 2)
    {
#pragma mark - 设置navigationItem右侧按钮
        UIButton *meassageBut = ({
            UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
            meassageBut.frame = CGRectMake(0, 0, 30, 30);
            [meassageBut addTarget:self action:@selector(pushChatLinkManInfoViewController) forControlEvents:UIControlEventTouchDown];
            [meassageBut setImage:[UIImage imageNamed:@"三点hover"]forState:UIControlStateNormal];
            meassageBut;
        });
        
        UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
        self.navigationItem.rightBarButtonItem = rBtn;
        
#pragma - mark 中间按钮
        UIButton *seachButton = ({
            UIButton *seachButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //            seachButton.layer.borderWidth = 1.0; // set borderWidth as you want.
            //            seachButton.layer.cornerRadius = 3.0f;
            //            seachButton.layer.masksToBounds=YES;
            //            seachButton.layer.borderColor = RGB(245, 245, 245).CGColor;
            seachButton.backgroundColor = [UIColor clearColor];
            seachButton.frame = CGRectMake(0, 0, ScreenWidth/1.3, 25);
            seachButton.titleLabel.font = [UIFont systemFontOfSize:17];
            [seachButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [seachButton setTitle:self.title  forState:UIControlStateNormal];
            [seachButton addTarget:self action:@selector(changeGroupName) forControlEvents:UIControlEventTouchDown];
            seachButton;
        });
        self.navigationItem.titleView = seachButton;
    }    else
    {
#pragma mark - 设置navigationItem右侧按钮
        UIButton *meassageBut = ({
            UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
            meassageBut.frame = CGRectMake(0, 0, 30, 30);
            [meassageBut addTarget:self action:@selector(pushChatLinkManInfoViewController) forControlEvents:UIControlEventTouchDown];
            [meassageBut setImage:[UIImage imageNamed:@"三点hover"]forState:UIControlStateNormal];
            meassageBut;
        });
        
        UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
        self.navigationItem.rightBarButtonItem = rBtn;
    }
}
//- (void)didTapMessageCell:(RCMessageModel *)model
//{
//    JCKLog(@"%@",model);
//    NSString *modelID = [NSString stringWithFormat:@"%ld",model.messageId];
//    JCKLog(@"%@",_models);
//    if ([_models containsObject:modelID])
//    {
//        [_models removeObject:modelID];
//        RCTextMessage *msg = (RCTextMessage*)model.content;
//        registerStr = msg.content;
//        [_contexts removeObject:registerStr];
//    }
//    else
//    {
//        [_models addObject:modelID];
//        RCTextMessage *msg = (RCTextMessage*)model.content;
//        registerStr = msg.content;
//        [_contexts addObject:registerStr];
//    }
//    JCKLog(@"_contexts %@",_contexts);
//}
- (void)shareClick
{
    TheFriendListViewController *sub = [[TheFriendListViewController alloc] init];
    sub.title = @"选择好友";
    sub.strCopy = pasteboardStr;
    sub.hidesBottomBarWhenPushed = YES;
    sub.isImg = isImg;
    [self.navigationController pushViewController:sub animated:YES];


}
- (void)copyAction
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = pasteboardStr;
}
- (void)dele
{
    [self deleteMessage:messageModel];
}
- (void)getAllMembersOfGroup:(NSString *)groupId
                      result:(void (^)(NSArray<NSString *> *userIdList))resultBlock
{
    JCKLog(@"getAllMembersOfGroup- %@ %@",groupId,resultBlock);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*!
 长按Cell中的消息内容的回调
 
 @param model 消息Cell的数据模型
 @param view  长按区域的View
 
 @discussion SDK在此长按事件中，会默认展示菜单。
 您在重写此回调时，如果想保留SDK原有的功能，需要注意调用super。
 */
- (void)didLongTouchMessageCell:(RCMessageModel *)model
                         inView:(UIView *)view
{
    [super didLongTouchMessageCell:model inView:view];
    JCKLog(@"%@",model);
    //获取消息内容需要强转
    if ([model.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *msg = (RCTextMessage*)model.content;
//        NSLog(@"%@",msg.content);
        messageId =  model.messageId;
        pasteboardStr = msg.content;
        messageModel = model;
        isImg = 1;
        // 获得菜单
        UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyAction)];
        UIMenuItem *dele = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(dele)];
        UIMenuItem *share = [[UIMenuItem alloc] initWithTitle:@"转发"action:@selector(shareClick)];
        UIMenuItem *more = [[UIMenuItem alloc] initWithTitle:@"更多"action:@selector(moreAction)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:copy,dele,share, nil]];
        [menu setMenuVisible:YES animated:YES];
        // 菜单最终显示的位置
        [menu setTargetRect:view.bounds inView:view];
    }
    else if ([model.content isMemberOfClass:[RCFileMessage class]])
    {
        RCFileMessage *msg = (RCFileMessage *)model.content
        ;
        pasteboardStr = msg.localPath;
        messageId =  model.messageId;
        messageModel = model;
        if (pasteboardStr.length == 0)
        {
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前文件未下载,请下载后转发" preferredStyle: UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
            return;
        }
        isImg = 4;
        // 获得菜单
        UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyAction)];
        UIMenuItem *share = [[UIMenuItem alloc] initWithTitle:@"转发"action:@selector(shareClick)];
        UIMenuItem *dele = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(dele)];
        UIMenuItem *more = [[UIMenuItem alloc] initWithTitle:@"更多"action:@selector(moreAction)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:copy,dele,share, nil]];
        [menu setMenuVisible:YES animated:YES];
        
        // 菜单最终显示的位置
        [menu setTargetRect:view.bounds inView:view];
    }
    else if ([model.content isMemberOfClass:[RCImageMessage class]]) {
        RCImageMessage *msg = (RCImageMessage*)model.content;
//        NSLog(@"%@",msg.imageUrl);
        pasteboardStr = msg.imageUrl;
        messageId =  model.messageId;
        messageModel = model;
        isImg = 2;
        // 获得菜单
        UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyAction)];
        UIMenuItem *dele = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(dele)];
        UIMenuItem *share = [[UIMenuItem alloc] initWithTitle:@"转发"action:@selector(shareClick)];
        UIMenuItem *more = [[UIMenuItem alloc] initWithTitle:@"更多"action:@selector(moreAction)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:copy,dele,share, nil]];
        [menu setMenuVisible:YES animated:YES];
        
        // 菜单最终显示的位置
        [menu setTargetRect:view.bounds inView:view];
    }
    else
    {
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂不支持此转发" preferredStyle: UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }

}

- (void)didTapCellPortrait:(NSString *)userId
{
//    JCKLog(@"userId - %@",userId);
//    NetManger *manger = [NetManger shareInstance];
//    manger.ID = userId;
//    [manger loadData:RequestOfGetuser];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushChatCtr) name:@"getuser" object:nil];
//    isSelcet = YES;
}
- (void)pushChatCtr
{
    if (isSelcet)
    {
        NetManger *manger = [NetManger shareInstance];
        NewFriendInfoModel *model = manger.getusers[0];
        ChatViewController   *conversationVC = [[ChatViewController alloc] init];
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.targetId = [NSString stringWithFormat:@"%@",model.UserID];
        conversationVC.ID = [NSString stringWithFormat:@"%@",model.UserID];
        conversationVC.title = model.EmployeeName;
        conversationVC.hidesBottomBarWhenPushed = YES;
        [[RCIM sharedRCIM] clearUserInfoCache];
        [self.navigationController pushViewController:conversationVC animated:YES];
        isSelcet = !isSelcet;
    }

}
- (void)pushChatLinkManInfoViewController
{
    if (self.conversationType == ConversationType_DISCUSSION)
    {
        ChatGroupMembersViewController *sub = [[ChatGroupMembersViewController alloc] init];
//        sub.title = @"群组成员";
        sub.groupID = self.ID;
        [self.navigationController pushViewController:sub animated:YES];
//        AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
//        sub.title = @"选择添加的好友";
//        sub.isNogroup = 2;
//        sub.ID = self.ID;
//        [self.navigationController pushViewController:sub animated:YES];
//        ChatLinkManMembersViewController *sub = [[ChatLinkManMembersViewController alloc] init];
        sub.title = @"群组成员";
//        [self.navigationController pushViewController:sub animated:YES];
    }
    else
    {
        AddFriendListViewController *sub = [[AddFriendListViewController alloc] init];
        sub.title = @"选择好友";
        sub.hidesBottomBarWhenPushed = YES;
        sub.needAddFriendID = self.ID;
        [self.navigationController pushViewController:sub animated:YES];
//        ChatLinkManMembersViewController *sub = [[ChatLinkManMembersViewController alloc] init];
//        sub.title = @"选择添加好友";
//        [self.navigationController pushViewController:sub animated:YES];
    }

    
}
- (void)changeGroupName
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入新的群组名"
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
        tf2.placeholder = self.title;
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
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex)
    {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        //TODO
        NSLog(@"nameField %@",nameField.text);
        if (buttonIndex == 1)
        {
            [[RCIM sharedRCIM] setDiscussionName:self.ID name:nameField.text success:^{
                
            } error:^(RCErrorCode status) {
                
            }];
            [self.navigationController popViewControllerAnimated:YES];
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
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
