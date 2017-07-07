//
//  DetailModel.h
//  P-Share
//
//  Created by VinceLee on 15/12/2.
//  Copyright © 2015年 杨继垒. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

@property (nonatomic,assign) int canUse;//是否可代泊（1：不可代泊 2：可代泊）
@property (nonatomic,strong) NSNumber *chargeType;//收费类型（1、时间  2、按次）
@property (nonatomic,strong) NSArray *chargeNorms;//按时间收费的价格
@property (nonatomic,copy) NSString *parkingName;
@property (nonatomic,copy) NSString *priceTimes;//按次收费的话一次收多少钱
@property (nonatomic,strong) NSNumber *defaultScan;//是否设为首页（0、否   1、是）
@property (nonatomic,strong) NSNumber *isCollection;//是否收藏（0、否    1、是）


@end




