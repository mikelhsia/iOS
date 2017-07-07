//
//  HomeModel.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/30.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject

@property (nonatomic,copy,setter=setParking_name:) NSString *parking_Name;
@property (nonatomic,copy) NSString *parking_address;
@property (nonatomic,copy,setter=setParking_id:) NSString *parking_Id;

@end
