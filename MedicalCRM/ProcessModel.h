//
//  ProcessModel.h
//  MedicalCRM
//
//  Created by admin on 16/8/31.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessModel : NSObject
@property (nonatomic, copy) NSString *ProcessName;
@property (nonatomic, copy) NSString *Msg;
@property (nonatomic, copy) NSString *FKId;
@property (nonatomic, copy) NSString *ProcessTime;
@property (nonatomic, copy) NSString *FileNames;
@property (nonatomic, copy) NSString *FilePaths;
@end
