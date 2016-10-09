//
//  ChatViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/21.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatLinkManInfoViewController.h"
#import "JCKConversationViewController.h"
@interface ChatViewController ()

@end

@implementation ChatViewController

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
    }
    else
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

    /*
     - (void)getDiscussion:(NSString *)discussionId
     success:(void (^)(RCDiscussion *discussion))successBlock
     error:(void (^)(RCErrorCode status))errorBlock;
     */

//    [[RCIM sharedRCIM] getDiscussion:@"1" success:^(RCDiscussion *discussion)
//    {
//        JCKLog(@"%@",discussion);
//    } error:^(RCErrorCode status)
//    {
//        JCKLog(@"%ld",(long)status);
//    }];
    self.enableSaveNewPhotoToLocalSystem = YES;// 保存图片到本地
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pushChatLinkManInfoViewController
{
    ChatLinkManInfoViewController *sub = [[ChatLinkManInfoViewController alloc] init];
    sub.title = @"群组成员";
    sub.groupID = self.ID;
    [self.navigationController pushViewController:sub animated:YES];

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
