//
//  ExhibitionTextViewController.h
//  MedicalCRM
//
//  Created by admin on 16/8/13.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExhibitionBulidModel;
typedef void (^Exhblock)(NSString *str);
@interface ExhibitionTextViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, assign) NSInteger stpy;
@property (nonatomic, strong) ExhibitionBulidModel *model;
@property (nonatomic, copy) Exhblock block;
@end
