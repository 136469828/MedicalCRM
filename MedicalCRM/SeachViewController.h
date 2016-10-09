//
//  SeachViewController.h
//  MedicalCRM
//
//  Created by admin on 16/7/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    Getprojectpagelist = 0,    // 获取内容列表

}State;
@interface SeachViewController : UIViewController
@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) State theState;
@end
