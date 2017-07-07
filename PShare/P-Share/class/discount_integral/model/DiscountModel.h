//
//  DiscountModel.h
//  P-Share
//
//  Created by VinceLee on 15/12/9.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscountModel : NSObject

@property (nonatomic,copy) NSString *coupon_id;//优惠券唯一标识
@property (nonatomic,copy) NSString *vouchers_type;//通用券类型
@property (nonatomic,copy) NSString *vouchers_name;//通用券名称vouchers_name
@property (nonatomic,copy) NSString *channel;//发放渠道
@property (nonatomic,assign) int     coupon_type;//优惠券类型
@property (nonatomic,assign) double par_amount;//面值(元)
@property (nonatomic,assign) int    par_discount;//面值(折扣)
@property (nonatomic,assign) double minconsumption;//最低消费
@property (nonatomic,copy) NSString *discount;//实际抵扣金额
@property (nonatomic,assign) double maxdiscount;//最高折扣
@property (nonatomic,copy) NSString *receive_begin;//领取开始时间 
@property (nonatomic,copy) NSString *receive_end;//领取结束时间
@property (nonatomic,copy) NSString *effectivetime;//有效期
@property (nonatomic,copy) NSString *effective_begin;//有效开始时间
@property (nonatomic,copy) NSString *effective_end;//有效结束时间
@property (nonatomic,copy) NSString *exclusion_rule;//互斥规则
@property (nonatomic,copy) NSString *info;//备注说明
@property (nonatomic,copy) NSString *coupon_status;//优惠券类型（是否可用）
@property (nonatomic,copy,setter=setCustomer_id:) NSString *customer_ID;//使用者ID
@property (nonatomic,copy) NSString *use_time;//使用时间
@property (nonatomic,copy) NSString *coupon_parking;//支持使用的停车场
@property (nonatomic,copy) NSString *coupon_order;//使用该优惠券的订单号
@property (nonatomic,copy) NSString *customer_name;//用户姓名

@end





