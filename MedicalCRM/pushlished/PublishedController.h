//
//  PublishedController.h
//  PinFan
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishedController : UIViewController
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *address;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *projectFild;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFild;
@property (weak, nonatomic) IBOutlet UITextField *keshiTf;
@property (weak, nonatomic) IBOutlet UIButton *colseCustom;
@property (weak, nonatomic) IBOutlet UITextField *yiyuanTf;
@end
