//
//  HistoryOrderModel.h
//  P-Share
//
//  Created by VinceLee on 15/12/16.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryOrderModel : NSObject

@property (nonatomic,copy,setter=setCar_number:) NSString *car_Number;//
@property (nonatomic,copy) NSString *create_at;//
@property (nonatomic,copy) NSString *add_time;//支付时间
@property (nonatomic,copy) NSString *getCarTime;//取车时间
@property (nonatomic,copy) NSString *giveCarTime;//交车时间
@property (nonatomic,copy) NSString *order_discount;//优惠金额
@property (nonatomic,copy,setter=setOrder_id:) NSString *order_Id;//
@property (nonatomic,copy) NSString *order_path;//
@property (nonatomic,assign) int order_state;//
@property (nonatomic,assign) float order_total_fee;//支付金额
@property (nonatomic,copy,setter=setParking_name:) NSString *parking_Name;//
@property (nonatomic,copy) NSString *parker_name;//
@property (nonatomic,copy) NSString *parking_path;//
@property (nonatomic,copy) NSString *pay_type;//支付方式

@end



