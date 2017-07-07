//
//  RequestModel.h
//  P-Share
//
//  Created by fay on 15/12/29.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionModel.h"

@interface RequestModel : NSObject
//获取APPStore上面的版本号
+ (void)requestPShareVersionWithCompletion:(void (^)(VersionModel *versionModel))completion;


@end
