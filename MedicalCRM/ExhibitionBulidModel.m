//
//  ExhibitionBulidModel.m
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ExhibitionBulidModel.h"
static ExhibitionBulidModel *model = nil;
@implementation ExhibitionBulidModel
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
