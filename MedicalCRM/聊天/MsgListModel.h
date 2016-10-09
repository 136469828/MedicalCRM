//
//  MsgListModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgListModel : NSObject
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *Msg;
@property (nonatomic, copy) NSString *CreateTime;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *UserId;
@property (nonatomic, copy) NSString *BillTypeFlag;
@property (nonatomic, copy) NSString *BillTypeCode;
@property (nonatomic, copy) NSString *BillId;
@property (nonatomic, copy) NSString *Status;
@property (nonatomic, copy) NSString *PowerType;
@end
