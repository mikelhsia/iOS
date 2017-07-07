//
//  DBManager.h
//  Pop Daily
//
//  Created by qianfeng on 15/7/6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchModel.h"

@interface DBManager : NSObject

+ (DBManager *)sharedInstance;

- (void)addSearchtModel:(SearchModel *)model;

- (NSArray *)searchAllModel;

- (void)deleteModel:(SearchModel *)model;

- (BOOL)isModelExists:(SearchModel *)model;

- (void)deleteAllModel;

@end
