//
//  CarModel.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/29.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CarModel : MAAnnotationView

@property (nonatomic,copy,setter=setCar_number:) NSString *car_Number;
@property (nonatomic,copy,setter=setCar_brand:) NSString *car_Brand;
@property (nonatomic,copy) NSString *car_id;

@end
