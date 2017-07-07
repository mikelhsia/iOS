//
//  RentModel.h
//  P-Share
//
//  Created by 杨继垒 on 15/10/22.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RentModel : NSObject

@property (nonatomic,copy) NSString *customerId;//
@property (nonatomic,copy) NSString *carNumber;//
@property (nonatomic,copy,setter=setId:) NSString *ID;//

@property (nonatomic,copy) NSString *receivablesPlatformType;//收款平台类型
@property (nonatomic,copy) NSString *customerName;//
@property (nonatomic,copy) NSString *villageId;//
@property (nonatomic,copy) NSString *villageName;//
@property (nonatomic,copy) NSString *orderSerialNumber;//
@property (nonatomic,copy) NSString *price;//
@property (nonatomic,copy) NSString *amount;//
@property (nonatomic,copy) NSString *timeQuantum;//
@property (nonatomic,copy) NSString *validityStartTime;//
@property (nonatomic,copy) NSString *validityEndTime;//
@property (nonatomic,copy) NSString *orderStatus;//
@property (nonatomic,copy) NSString *orderType;//
@property (nonatomic,copy) NSString *area;//
@property (nonatomic,copy) NSString *county;//
@property (nonatomic,copy) NSString *buyerEmail;//

@property (nonatomic,copy) NSString *address;//月租地址
@property (nonatomic,copy) NSString *parking_number;//产权车位号
@property (nonatomic,copy) NSString *discount_pay;//优惠金额
@property (nonatomic,copy) NSString *pay_time;//支付时间


@end


