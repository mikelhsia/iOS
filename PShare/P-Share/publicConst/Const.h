//
//  Const.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#ifndef P_Share_Const_h
#define P_Share_Const_h

//屏幕宽、高
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//ios版本(float)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)//用来获取手机的系统，判断系统是多少

//代码适配
#define RATIO (SCREEN_WIDTH/375)

// R G B 颜色
#define COLOR_WITH_RGB(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0])
#define MAIN_COLOR ([MyUtil colorWithHexString:@"#37b69d"])
#define BACKGROUND_COLOR ([MyUtil colorWithHexString:@"#f8f8ff"])
#define GREEN_COLOR ([MyUtil colorWithHexString:@"#079a00"])


//UIAlertView
#define ALERT_VIEW(STR) do{ if([STR isKindOfClass:[NSString class]]) {_alert = [[UIAlertView alloc] initWithTitle:STR message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];[_alert show];}}while(0);

//MBProgressHUD
#define ALLOC_MBPROGRESSHUD  _clearBackView = [[UIView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];  _clearBackView.backgroundColor = [UIColor clearColor];  [self.view addSubview:_clearBackView];  _mbView = [[MBProgressHUD alloc] initWithView:self.view];  _mbView.opacity = 0.6;  _mbView.labelText = @"加载中...";  _mbView.labelFont = [UIFont systemFontOfSize:13];  _mbView.activityIndicatorColor = MAIN_COLOR;  [_clearBackView addSubview:_mbView];_clearBackView.hidden = YES;

#define VERSION_MBPROGRESSHUD  _clearBackView = [[UIView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];  _clearBackView.backgroundColor = [UIColor clearColor];  [self.view addSubview:_clearBackView];  _mbView = [[MBProgressHUD alloc] initWithView:self.view];  _mbView.opacity = 0.6;  _mbView.labelText = @"检测中...";  _mbView.labelFont = [UIFont systemFontOfSize:13];  _mbView.activityIndicatorColor = MAIN_COLOR;  [_clearBackView addSubview:_mbView];_clearBackView.hidden = YES;

#define BEGIN_MBPROGRESSHUD  [_mbView show:YES];_mbView.hidden = NO;_clearBackView.hidden = NO;

#define END_MBPROGRESSHUD    [_mbView show:NO];_mbView.hidden = YES;_clearBackView.hidden = YES;

#define PARAMATER  @"token":[NetworkTool commonParams][@"token"],@"time":[NetworkTool commonParams][@"time"],@"client":[NetworkTool commonParams][@"client"]

#define LOGIN_DOC_SALT @"!qae@jkh#h*lkjds&dsl^kdjas%lkdj)dakjs~12^^$#&(3p2i399098uu"

#define GAODEAPPKEY (@"b3dd200e6f1e3c78c0fdb3dac452ecae")

#define had_Login @"isLogin"

#define  MOBILE_CUSTOMER      @"customer_mobile"     //手机号
#define  PASSWORD_CUSTOMER    @"customer_password"   //密码
#define  smsCode              @"smsCode"             //验证码

#define  selectParkingID      @"selectParkingID"     //选中的车场ID
#define  customer_selectPark  @"customer_selectPark" //用户选中的车场
#define  customer_id          @"customer_id"         //用户唯一标示
#define  customer_nickname    @"customer_nickname"   //用户昵称
#define  customer_head        @"customer_head"       //用户头像
#define  customer_sex         @"customer_sex"        //用户性别
#define  customer_job         @"customer_job"        //用户职业
#define  customer_region      @"customer_region"     //用户地址
#define  customer_mobile      @"customer_mobile"     //用户手机号
#define  customer_email       @"customer_email"      //用户邮箱
#define  customer_age         @"customer_age"        //用户年龄

#define  car_brand            @"car_brand"           //车品牌
#define  car_number           @"car_number"          //车牌号
#define  car_color            @"car_color"           //车颜色
#define  car_location         @"car_location"        //车归属地
#define  car_size             @"car_size"            //车型
#define  owner_id_number      @"owner_id_number"     //省份证号
#define  parking_name         @"name"                //停车场名字-用于搜索

#define  parking_latitude     @"parking_latitude"    //经度
#define  parking_longitude    @"parking_longitude"   //纬度

#define  parking_id           @"parking_id"          //停车场唯一标识
#define  order_plan_begin     @"order_plan_begin"    //计划开始时间
#define  order_img_count      @"order_img_count"     //特殊需求

#define  order_id             @"order_id"            //订单唯一标识

#define  comment_level        @"comment_level"       //评价等级
#define  comment_content      @"comment_content"    //评价内容

#define  parking_area         @"parking_area"       //用于搜索 准确的 小区、停车场
#define  parking_name         @"name"               //用于搜索 准确的 小区、停车场
#define  comment_content      @"comment_content"    //评价内容


//微信支付
#define  SP_URL   @"https://api.mch.weixin.qq.com/pay/unifiedorder"

#endif











