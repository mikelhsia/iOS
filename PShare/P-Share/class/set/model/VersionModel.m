//
//  VersionModel.m
//  P-Share
//
//  Created by fay on 15/12/29.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "VersionModel.h"

@implementation VersionModel
+ (VersionModel *)shareVersionModelWithDic:(NSDictionary*)dic
{
    return [[self alloc]initWithDic:dic];
}
- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
