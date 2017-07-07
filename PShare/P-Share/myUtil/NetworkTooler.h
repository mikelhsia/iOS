//
//  NetworkTooler.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/25.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>
//139.196.48.108测试
//139.196.12.103正式www.p-share.com

//接口定义
#define SERVER_KEY          @"http://139.196.48.108/ShanganParking/{2}/{1.0.0}/customer"//服务器地址
#define URL_MACRO(p) [NSString stringWithFormat:@"%@%@",SERVER_KEY,p]

//注册
#define USER_REGIST               URL_MACRO(@"/register")

//获取验证码
#define GET_USER_CODE             URL_MACRO(@"/sendSmsCode")

//校验验证码
#define VERIFY_USER_CODE          URL_MACRO(@"/verifySmsCode")

//重置密码
#define RESET_PWD                 URL_MACRO(@"/resetPwd")

//登陆
#define USER_Login                URL_MACRO(@"/login")

//获取基本信息
//#define GET_USER_INFO             URL_MACRO(@"/doctor/getInfo")

//设置基本信息---------post请求
#define SET_USER_INFO             URL_MACRO(@"/setUserInfo")

//注销
#define USER_LOG_OUT              URL_MACRO(@"/logout")

//添加车辆
#define ADD_CAR_URL               URL_MACRO(@"/addCar")

//获取车列表
#define GET_CAR_LIST              URL_MACRO(@"/carList")

//获取车列表
#define DELETE_CAR                URL_MACRO(@"/deleteCar")

//关键词搜索停车场
#define SEARCH_PARK_BY_NAME       URL_MACRO(@"/searchParkListbyName")

//位置搜索车场
#define SEARCH_PARK_BY_LL         URL_MACRO(@"/searchParkListByLL")

//位置搜索附近车场
#define SEARCH_PARK_BY_PAEK       URL_MACRO(@"/searchParkListByParking")

//发起预约
#define CREATE_ORDER              URL_MACRO(@"/createOrder")

//取消预约
#define CANCEL_ORDER              URL_MACRO(@"/cancelOrder")

//取车接口
#define GET_CAR                   URL_MACRO(@"/getCar")

//获取 总价
#define CALCULATE_PAY             URL_MACRO(@"/calculatePay")

//获取 月租单价
#define GET_UNIT_PRICE            URL_MACRO(@"/getunitprice")

//提交月租订单
#define POST_RENT_ORDER           URL_MACRO(@"/postorderinfo")

//请求月租历史列表
#define GET_HISRENT_ORDER            URL_MACRO(@"/searchRentAndPropertyParkingOrderById")

//请求当前月租订单
#define GET_RENT_ORDER            URL_MACRO(@"/getorderinfo")

//删除月租
#define DEL_RENT_ORDER            URL_MACRO(@"/delOrder")

//订单支付
#define PAY_ORDER                 URL_MACRO(@"/payOrder")

//评价订单
#define ORDER_COMMENT             URL_MACRO(@"/comment")

//查看预约中订单状态
#define STATE_FOR_ORDER           URL_MACRO(@"/unfinishedOrder")

//历史订单
#define HISTORY_ORDER             URL_MACRO(@"/searchHelpParkingOrderById")

//临停历史订单
#define TEM_HISTORY_ORDER         URL_MACRO(@"/searchTemptyOrderById")

//收藏停车场
#define SAVE_PARKER               URL_MACRO(@"/saveParking")

//取消收藏停车场
#define CANCLE_PARKER             URL_MACRO(@"/cusCancelCollection")

//停车场详情调用
#define PARKINGDETAIL             URL_MACRO(@"/parkingInfoDetail")

//根据市区搜索车场接口
#define SEARCH_PARKLIST_BY_AREA   URL_MACRO(@"/searchParkListbyArea")

//根据市区搜索车场接口
#define SEARCH_PARKLIST_BY_NAME   URL_MACRO(@"/searchParkListbyName")

//拉停车场收藏清单
#define GET_PARDERLIST            URL_MACRO(@"/searchSaveParkList")

//根据车场ID返回车场详细信息
#define PARK_INFO_PARK_ID         URL_MACRO(@"/searchParkbyId")

//获取首页信息
#define INDEXSHOW                 URL_MACRO(@"/indexShow")

//获取首页消息
#define INDMESSAGE                URL_MACRO(@"/indexMessage")

//设置首页车场
#define SETDEFAULTSCAN            URL_MACRO(@"/setDefaultScan")

//获取所有停车场
#define CUSFINDALLPARKING         URL_MACRO(@"/cusFindAllParking")

//意见反馈
#define COMMITAPP                URL_MACRO(@"/CommitApp")

//获取临停订单
#define GETPARKLOTFEE            URL_MACRO(@"/getParklotFee")

//临停支付调用
#define PSSTTEMPORARY            URL_MACRO(@"/posttemporaryorderinfo")

//获取优惠券列表
#define GETCOUPONLIST            URL_MACRO(@"/getCouponList")

//兑换优惠券
#define RECEIVEBYCDKEY           URL_MACRO(@"/ReceiveCouponByCdkey")

//扫码兑换优惠券
#define REXEIVEBYVOUCHERS        URL_MACRO(@"/ReceiveCouponByVouchers")

//使用优惠券
#define USEXOUPON                URL_MACRO(@"/UseCoupon")

@interface NetworkTooler : NSObject

@end







