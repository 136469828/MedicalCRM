//
//  CustlinkmanlistModel.h
//  MedicalCRM
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustlinkmanlistModel : NSObject
@property (nonatomic, copy) NSString *ID; // 联系人ID
@property (nonatomic, copy) NSString *CustNo; // 联系人编码
@property (nonatomic, copy) NSString *CompanyCD; //
@property (nonatomic, copy) NSString *Sex; //
@property (nonatomic, copy) NSString *LinkManName; // 联系人名字
@property (nonatomic, copy) NSString *Important; // 重视程度
@end
