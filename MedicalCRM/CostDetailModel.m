//
//  CostDetailModel.m
//  MedicalCRM
//
//  Created by admin on 16/9/28.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "CostDetailModel.h"
static CostDetailModel *model = nil;
static dispatch_once_t oneToken;
@implementation CostDetailModel
// 单例
+ (instancetype)shareInstance
{
    dispatch_once(&oneToken, ^{
        if (!model) {
            model = [[[self class] alloc] init];
        }
    });
    return model;
}
+ (void)tearDown
{
    model=nil;
    oneToken = 0l;
}
@end