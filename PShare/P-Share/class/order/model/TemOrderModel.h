//
//  TemOrderModel.h
//  P-Share
//
//  Created by VinceLee on 15/12/16.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemOrderModel : NSObject

@property (nonatomic,copy,setter=setCar_number:) NSString *car_Number;//
@property (nonatomic,copy) NSString *pay_type;//收款平台类型
@property (nonatomic,copy,setter=setOrder_id:) NSString *order_ID;//
@property (nonatomic,copy) NSString *carStoreTime;//
@property (nonatomic,copy) NSString *create_at;//
@property (nonatomic,copy) NSString *order_actual_begin_start;//
@property (nonatomic,copy) NSString *order_actual_end_stop;//支付时间
@property (nonatomic,copy) NSString *order_state;//
@property (nonatomic,copy) NSString *order_total_fee;//
@property (nonatomic,copy,setter=setParking_name:) NSString *parking_Name;//

@property (nonatomic,copy) NSString *order_discount;//优惠金额


@end
