//
//  ImportantItemsListModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImportantItemsListModel : NSObject
@property (nonatomic, copy) NSString *CreateDateStr;
@property (nonatomic, copy) NSString *IsRead;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *ArrangeTItle;
@property (nonatomic, copy) NSString *Content;

@end
