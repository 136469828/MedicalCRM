//
//  NextModel.m
//  协议传值Deom
//
//  Created by JCong on 15/11/7.
//  Copyright © 2015年 梁健聪. All rights reserved.
//

#import "WebModel.h"

@implementation WebModel
- (id)initWithUrl:(NSString *)urlString{
    if (self = [super init]) {
        _url = urlString;
        
    }
    return self;
}
@end
