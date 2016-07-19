//
//  FriendListModel.h
//  MedicalCRM
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendListModel : NSObject
@property (nonatomic, copy) NSString *m_nick;
@property (nonatomic, assign, getter=isChooseBtn) BOOL m_chooseBtn;
@end
