//
//  FeeapplysaveModel.m
//  MedicalCRM
//
//  Created by admin on 16/7/30.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "FeeapplysaveModel.h"
static FeeapplysaveModel *model = nil;
@implementation FeeapplysaveModel
// 单例
+ (instancetype)shareInstance{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        if (!model) {
            model = [[[self class] alloc] init];
        }
    });
    return model;
}
@end
