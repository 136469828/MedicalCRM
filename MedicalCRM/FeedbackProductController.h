//
//  FeedbackProductController.h
//  MedicalCRM
//
//  Created by admin on 16/9/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackProductController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *productBtn;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (nonatomic, copy) NSString *stpy;
@end
