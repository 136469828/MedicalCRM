//
//  HistoryInfoModel.h
//  MedicalCRM
//
//  Created by admin on 16/9/8.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryInfoModel : NSObject
@property (nonatomic, strong) NSDictionary *feeapply;
@property (nonatomic, strong) NSMutableArray *Amount;
//@property (nonatomic, strong) NSArray *Projects;
//
@property (nonatomic, copy) NSString *Contents;
@property (nonatomic, copy) NSString *ModifiedDate;
@property (nonatomic, copy) NSString *LocationAddress;
@property (nonatomic,copy) NSString *FeeApplyTravelCount;
@property (nonatomic,copy) NSString *FeeApplyAccommodationCount;
@property (nonatomic,copy) NSString *FeeApplyGiftCount;
@property (nonatomic,copy) NSString *FeeApplyOtherCount;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *TotalAmount;
@end
