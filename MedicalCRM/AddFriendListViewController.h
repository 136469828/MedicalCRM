//
//  AddFriendListViewController.h
//  MedicalCRM
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^friendBlock)(NSArray *datas,NSArray *IDdatas);
@interface AddFriendListViewController : UIViewController
@property (nonatomic, copy) friendBlock block;
@property (nonatomic, assign) int isNogroup;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *needAddFriendID;
@end
