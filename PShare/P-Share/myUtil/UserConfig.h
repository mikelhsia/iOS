//
//  UserConfig.h
//  WisdomOperating
//
//  Created by john on 15/3/6.
//  Copyright (c) 2015年 john. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//用户名
#define _USER_NAME_ @"doctorName"
//
#define _FIRST_TIME_ @"firstTime"
//登陆状态
#define _HAVE_Login_ @"haveLogin"
//记住密码
#define  _REMEMBER_PASSWORD_ @"rememberPassWord"
//用户名ID
#define _USER_ID_ @"doctorId"
//用户tureName
#define _USER_TRUENAME_ @"doctortrueName"
//用户昵称
#define _USER_NICKNAME_ @"doctornickName"
//用户性别
#define _USER_GENDER_ @"doctorSex"
//用户年龄
#define _USER_AGE_ @"doctorAge2"
//用户手机号码
#define _USER_PHONENUM_ @"doctormobile"
//用户地区
#define _USER_PLACE_ @"doctorPlace"
//侧边栏状态
#define _LIST_MENU_ @"menu"
//用户密码
#define _USER_PASSWORD_ @"doctorpassword"
//用户头像
#define _USER_HEADIMAGE_ @"doctorheadUrl"
#define _USER_HEADIMAGEDATA_ (@"doctorHeaderData")
//用户简介
#define _USER_DESB_ @"doctorDesber"
//用户职称
#define _USER_TECH_ @"doctorTech"
//用户账号
#define _USER_ACCOUNT_NUM_ @"doctorAccountNum"
//用户认证信息
#define _USER_IDENTIFY_ @"doctorIdentify"

//用户token
#define  _USER_TOKEN_ @"doctortoken"
//用户职称
#define _USER_JOBTITLE (@"jobTitle")

@interface UserConfig : NSObject{
    //储存在本地的数据
    NSMutableDictionary* userConfigDic;
    NSMutableDictionary *lastSignDate;
}

@property (retain, nonatomic) NSMutableDictionary* userConfigDic;
@property(nonatomic,strong)NSMutableArray *ads;//获取广告跳转页地址
//得到单例
+ (UserConfig*)sharingUserConfig;

//储存数据
- (void)saveConfigerData;
//清空数据
- (void)clearConfigerData;

//设置判断是否是第一次使用参数
-(void)setIfFirstTime:(NSString *)firstTime;
//得到是否是第一次使用
-(NSString *)getIfFirstTime;

//设置判断是否已登录
- (void)setHaveLogin:(NSString *)login;
//得到登陆状态
- (NSString *)getHaveLogin;

//设置判断是否记住密码
- (void)setIfRememberPassWord:(NSString *)remember;
//得到是否记住密码
- (NSString *)getIfRememberPassWord;

//设置用户名
- (void)setCurrentUserName:(NSString*)userName;
//得到当前登录用户名
- (NSString*)getCurrentUserName;

//设置当前登陆用户的头像
- (void)setCurrentUserHeadImage:(NSData *)headImage;
//得到当前登陆用户的头像
- (NSData *)getCurrentUserHeadImage;

//设置当前登录用户id
-(void)setCurrentUserID:(NSString *)ID;
//得到当前用户登录id
-(NSString *)getCurrentuserID;

//设置当前登录用户的truename
-(void)setCurrentTrueName:(NSString *)trueName;
//得到当前登陆用户的truename
-(NSString *)getCurrentTrueName;

//设置当前用户的昵称
-(void)setCurrentNickName:(NSString *)nickName;
//得到当前用户的昵称
-(NSString *)getCurrentNickName;

//设置当前用户的性别
-(void)setCurrentuserGender:(NSString *)gender;
//得到当前用户的性别
-(NSString *)getCurrentUserGender;

//设置当前用户的手机号码
-(void)setCurrentPhoneNum:(NSString *)phoneNum;
//得到当前用户的手机号码
-(NSString *)getCurrentPhoneNum;

//设置当前用户的地区
-(void)setCurrentPlace:(NSString *)place;
//得到当前用户的地区
-(NSString *)getCurrentPlace;

//设置当前侧边栏状态
- (void)setCurrentMenu:(NSString *)menu;
//得到当前侧边栏状态
- (NSString *)getcurrentMenu;

//设置当前用户的年龄
-(void)setCurrentAge:(NSString *)age;
//得到当前用户的地区
-(NSString *)getCurrentAge;

//设置当前用户的密码
- (void)setCurrentUserPsd:(NSString*)userPsd;
//得到当前用户的密码
- (NSString*)getCurrentUserPsd;

//设置头像图片
-(void)setcurrentHeadImage:(NSString *)headImage;
//得到当前用户头像
-(NSString *)getCurrentHeadImage;

//设置当前用户的token
-(void)setcurrentUserToken:(NSString *)UserToken;
//得到当前用户token
-(NSString *)getCurrentUserToken;
//设置当前用户的描述
- (void)setCurrentUserDesb:(NSString *)userDesb;
//得到当前用户的描述
- (NSString *)getCurrentUserDesb;

//设置当前用户的职称
- (void)setCurrentUserTechnology:(NSString *)userTech;
//得到当前用户的职称
- (NSString *)getCurrentUserTechnology;

//设置当前用户的账号
- (void)setCurrentUserAccount:(NSString *)userAccount;
//得到当前用户的账号
- (NSString *)getCurrentUserAccount;

//设置当前用户的认证信息
- (void)setCurrentUserIdentify:(NSString *)userIdentify;
//得到当前用户的认证信息
- (NSString *)getCurrentUserIdentify;

//设置当前用户的职称
- (void)setCurrentUserJobTitle:(NSString *)userJobTitle;
//得到当前用户的职称
- (NSString *)getCurrentUserJobTitle;
@end
