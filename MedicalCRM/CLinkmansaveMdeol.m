//
//  CLinkmansaveMdeol.m
//  MedicalCRM
//
//  Created by admin on 16/7/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "CLinkmansaveMdeol.h"
static CLinkmansaveMdeol *model = nil;
@implementation CLinkmansaveMdeol
// 单例
+ (instancetype)shareInstance{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        if (!model) {
            model = [[[self class] alloc] init];
//            model.comName = @"";
//            model.cicy = @"";
//            model.adress = @"";
//            model.tel = @"";
//            model.phone = @"";
//            model.eMail = @"";
//            model.aress = @"";
//            model.remark = @"";
        }
    });
    return model;
}

@end
