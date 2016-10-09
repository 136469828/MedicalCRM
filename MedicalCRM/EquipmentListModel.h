//
//  EquipmentListModel.h
//  MedicalCRM
//
//  Created by admin on 16/7/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquipmentListModel : NSObject
@property (nonatomic, copy) NSString *ID; //
@property (nonatomic, copy) NSString *UsedStatus; //
@property (nonatomic, copy) NSString *ProductName; //
@property (nonatomic, copy) NSString *Creator; //
@property (nonatomic, copy) NSString *SellPrice; //
//@property (nonatomic, copy) NSString *UsedStatus; //
@property (nonatomic, assign, getter=isChooseBtn) BOOL m_chooseBtn;
@end
