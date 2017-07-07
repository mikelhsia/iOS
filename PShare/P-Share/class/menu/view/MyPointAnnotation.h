//
//  MyPointAnnotation.h
//  P-Share
//
//  Created by 杨继垒 on 15/10/8.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface MyPointAnnotation : MAPointAnnotation

@property (nonatomic,copy) NSString *parkState;
@property (nonatomic,copy) NSString *parkDistance;
@property (nonatomic,copy) NSString *parkID;
@property (nonatomic,copy) NSString *parkColorState;

@end




