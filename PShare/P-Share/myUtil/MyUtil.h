//
//  MyUtil.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/2.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUtil : NSObject

//创建label的方法
+ (UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment numberOfLine:(NSInteger)numberOfLines;

//创建label的另外一个方法
+ (UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font;

//创建按钮的方法
+ (UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title bgImageName:(NSString *)bgImageName target:(id)target action:(SEL)action;

//创建图片视图的方法
+ (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName;

//16进制颜色转换
+ (UIColor *) colorWithHexString: (NSString *)color;

//判断是否是手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;



@end










