//
//  AddMyTeamMenberModel.m
//  MedicalCRM
//
//  Created by admin on 16/8/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "AddMyTeamMenberModel.h"
static AddMyTeamMenberModel *model = nil;
@implementation AddMyTeamMenberModel
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
