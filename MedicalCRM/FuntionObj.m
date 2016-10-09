//
//  FuntionObj.m
//  FuntionObj
//
//  Created by admin on 16/6/2.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "FuntionObj.h"

@implementation FuntionObj
+ (BOOL)isNullDic:(NSDictionary *)dic Key:(NSString *)key
{
    if (![[dic objectForKey:key] isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else
    {
        return NO;
    }

}
@end
