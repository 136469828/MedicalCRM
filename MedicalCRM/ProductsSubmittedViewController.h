//
//  ProductsSubmittedViewController.h
//  MedicalCRM
//
//  Created by admin on 16/9/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Productsblock)(NSString *productName,NSString *productID,NSString *productPrice,NSString *productCount,BOOL isAdd);
@interface ProductsSubmittedViewController : UIViewController
@property (nonatomic, copy) Productsblock productsblock;
@end
