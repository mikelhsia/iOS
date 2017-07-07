//
//  NSString+URL.m
//  Kits
//
//  Created by MiaoYe on 15/7/17.
//  Copyright (c) 2015年 Azhuo. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)
//编码  URLEncodedString
- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
}
@end
