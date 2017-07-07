//
//  NSString+Encrypt.h
//  B5ESPORT
//
//  Created by TomTang on 15/1/23.
//  Copyright (c) 2015年 xiaomanwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)
- (NSString *) md5;
- (NSString *) sha1;
- (NSString *) sha1_base64;
- (NSString *) md5_base64;
- (NSString *) base64;
@end
