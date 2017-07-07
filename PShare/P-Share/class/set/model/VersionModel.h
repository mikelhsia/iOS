//
//  VersionModel.h
//  P-Share
//
//  Created by fay on 15/12/29.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionModel : NSObject

@property(nonatomic,copy)NSString *trackCensoredName,*trackViewUrl,*version;
+ (VersionModel *)shareVersionModelWithDic:(NSDictionary*)dic;
- (id)initWithDic:(NSDictionary *)dic;


@end
