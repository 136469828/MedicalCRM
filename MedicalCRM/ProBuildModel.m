//
//  ProBuildModel.m
//  MedicalCRM
//
//  Created by admin on 16/7/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProBuildModel.h"
static ProBuildModel *model = nil;
@implementation ProBuildModel
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
