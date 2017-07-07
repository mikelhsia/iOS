//
//  ParkingModel.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/27.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParkingModel : NSObject


@property (nonatomic,copy) NSString *parking_address;
@property (nonatomic,copy,setter=setParking_area:) NSString *parking_Area;
@property (nonatomic,assign) int     parking_can_use;
@property (nonatomic,copy) NSString *parking_city;
@property (nonatomic,assign) int       parking_count;
@property (nonatomic,copy) NSString *parking_country;
@property (nonatomic,copy) NSString *parking_county;
@property (nonatomic,copy,setter=setParking_id:) NSString *parking_Id;
@property (nonatomic,copy) NSString *parking_info;
@property (nonatomic,copy,setter=setParking_latitude:) NSString *parking_Latitude;
@property (nonatomic,copy,setter=setParking_longitude:) NSString *parking_Longitude;
@property (nonatomic,copy,setter=setParking_name:) NSString *parking_Name;
@property (nonatomic,copy) NSString *parking_path;
@property (nonatomic,copy) NSString *parking_province;
@property (nonatomic,copy) NSString *parking_status;
@property (nonatomic,assign) float   parking_charging_standard;
//@property (nonatomic,strong) NSArray *chargeNorms;

@property (nonatomic,assign) int canUse;//是否可代泊（1：不可代泊 2：可代泊）
@property (nonatomic,copy) NSString *chargeType;//收费类型（1、时间  2、按次）
@property (nonatomic,strong) NSNumber *isIn;//是否入场（1：待入场 2：已入场）
@property (nonatomic,copy) NSString *priceTimes;//按次收费的话一次收多少钱
@property (nonatomic,strong) NSNumber *ln;
@property (nonatomic,assign) float chargeNormMin;//时间收费，最低价格

@end




