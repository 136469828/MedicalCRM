//
//  PartnersVisitModel.m
//  MedicalCRM
//
//  Created by admin on 16/9/6.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "PartnersVisitModel.h"
static PartnersVisitModel *model = nil;
static dispatch_once_t oneToken;
@implementation PartnersVisitModel
// 单例
+ (instancetype)shareInstance{
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
