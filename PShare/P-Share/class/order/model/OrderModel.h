//
//  OrderModel.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/30.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (nonatomic,copy,setter=setCar_brand:) NSString *car_Brand;//
@property (nonatomic,copy,setter=setCar_color:) NSString *car_Color;//
@property (nonatomic,copy,setter=setCar_number:) NSString *car_Number;//
@property (nonatomic,copy,setter=setOrder_id:) NSString *order_Id;//
@property (nonatomic,copy,setter=setOrder_plan_begin:) NSString *order_Plan_begin;//
@property (nonatomic,copy,setter=setParking_area:) NSString *parking_Area;//
@property (nonatomic,copy,setter=setParking_name:) NSString *parking_Name;//

@property (nonatomic,copy,setter=setParking_id:) NSString *parking_Id;//
@property (nonatomic,copy,setter=setParking_latitude:) NSString *parking_Latitude;//
@property (nonatomic,copy,setter=setParking_longitude:) NSString *parking_Longitude;//
@property (nonatomic,copy,setter=setOrder_img_count:) NSString *order_Img_count;//

@property (nonatomic,copy) NSString *car_buy_date;//
@property (nonatomic,copy) NSString *create_at;//
@property (nonatomic,copy) NSString *order_actual_begin_start;//
@property (nonatomic,copy) NSString *order_actual_end_stop;//
@property (nonatomic,assign) int order_duration;//
@property (nonatomic,copy) NSString *order_path;//
@property (nonatomic,copy) NSString *order_plan_end;//
@property (nonatomic,assign) int order_state;//
@property (nonatomic,assign) float order_total_fee;//
@property (nonatomic,assign) float order_unit_fee;//
@property (nonatomic,copy) NSString *parker_cardid;//
@property (nonatomic,copy) NSString *parker_id;//
@property (nonatomic,copy) NSString *parker_mobile;//
@property (nonatomic,copy) NSString *parker_name;//
@property (nonatomic,copy) NSString *parker_level;//
@property (nonatomic,copy) NSString *parker_head;
@property (nonatomic,copy) NSString *parking_img_count;//
@property (nonatomic,copy) NSString *parking_path;//
@property (nonatomic,copy) NSString *parking_address;//
@property (nonatomic,copy) NSString *updated_at;//

@end







