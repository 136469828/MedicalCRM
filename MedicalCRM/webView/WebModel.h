//
//  NextModel.h
//  协议传值Deom
//
//  Created by JCong on 15/11/7.
//  Copyright © 2015年 梁健聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebModel : NSObject
@property (nonatomic, copy) NSString *url;

- (id)initWithUrl:(NSString *)urlString;
@end
