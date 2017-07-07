//
//  SearchModel.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/22.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

@property (nonatomic,copy) NSString *searchTitle;
@property (nonatomic,assign) float searchLatitude;
@property (nonatomic,assign) float searchLongitude;
@property (nonatomic,copy) NSString *searchDistrict;

@end
