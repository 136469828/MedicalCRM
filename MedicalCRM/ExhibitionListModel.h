//
//  ExhibitionListModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/11.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExhibitionListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *LinkManName;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *ExhibitionStartDate;
@property (nonatomic, copy) NSString *ExhibitionEndDate;
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *CreateDate;

@end
