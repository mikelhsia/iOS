//
//  RequestModel.m
//  P-Share
//
//  Created by fay on 15/12/29.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "RequestModel.h"
#import "AFNetworking.h"
#define APP_URL @"http://itunes.apple.com/lookup?id=1049233050"



@implementation RequestModel
#pragma mark -- 获取AppStore上面的最新版本号
+ (void)requestPShareVersionWithCompletion:(void (^)(VersionModel *versionModel))completion
{
    AFHTTPRequestOperationManager *manage = [[AFHTTPRequestOperationManager alloc]init];
    [manage POST:APP_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        

        VersionModel *versionModel = [VersionModel shareVersionModelWithDic:jsonDic[@"results"][0]];
        if (completion) {
            completion(versionModel);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

@end
