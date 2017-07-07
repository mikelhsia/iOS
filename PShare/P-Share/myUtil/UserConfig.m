//
//  UserConfig.m
//  WisdomOperating
//
//  Created by john on 15/3/6.
//  Copyright (c) 2015年 john. All rights reserved.
//

#import "UserConfig.h"

static UserConfig* g_userConfig = nil;

@implementation UserConfig
{
    NSMutableDictionary *_lastSign;
}
@synthesize userConfigDic;

+ (UserConfig*)sharingUserConfig{
    if (!g_userConfig) {
        g_userConfig = [[UserConfig alloc] init];
    }
    return g_userConfig;
}

- (NSString*)getConfigFile {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/userConfig.plist", documentsDirectory];
}

- (id)init {
    self = [super init];
    if (self) {
        self.userConfigDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getConfigFile]];
        _lastSign=[[NSMutableDictionary alloc]init];
        if (!self.userConfigDic) {
//            最多只能设置用户10个属性
            self.userConfigDic = [[NSMutableDictionary alloc] initWithCapacity:10];
            [self saveConfigerData];
        }
        _ads=[[NSMutableArray alloc]init];
    }
    return self;
}
- (void)saveConfigerData {
    [self.userConfigDic writeToFile:[self getConfigFile] atomically:YES];
}

- (void)clearConfigerData {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self getConfigFile] error:nil];
    
}

//设置判断是否是第一次使用参数
-(void)setIfFirstTime:(NSString *)firstTime
{
    [self.userConfigDic setValue:firstTime forKey:_FIRST_TIME_];
    [self saveConfigerData];
}
//得到是否是第一次使用
-(NSString *)getIfFirstTime
{
    return (NSString *)[self.userConfigDic objectForKey:_FIRST_TIME_];
}

//设置判断是否已登录
- (void)setHaveLogin:(NSString *)login {
    [self.userConfigDic setValue:login forKey:_HAVE_Login_];
    [self saveConfigerData];

}
//得到登陆状态
- (NSString *)getHaveLogin {
    return (NSString *)[self.userConfigDic objectForKey:_HAVE_Login_];
}

//设置判断是否记住密码
- (void)setIfRememberPassWord:(NSString *)remember {
    [self.userConfigDic setValue:remember forKey:_REMEMBER_PASSWORD_];
    [self saveConfigerData];
}
//得到是否记住密码
- (NSString *)getIfRememberPassWord {
    return (NSString *)[self.userConfigDic objectForKey:_REMEMBER_PASSWORD_];
}

//设置用户名
- (void)setCurrentUserName:(NSString*)userName {
    [self.userConfigDic setValue:userName forKey:_USER_NAME_];
    [self saveConfigerData];
}

//得到当前登录用户名
- (NSString*)getCurrentUserName {
    return (NSString*)[self.userConfigDic objectForKey:_USER_NAME_];
}

//设置当前用户ID
- (void)setCurrentUserID:(NSString*)ID {
    [self.userConfigDic setValue:ID forKey:_USER_ID_];
    [self saveConfigerData];
}

//得到当前登录用户ID
- (NSString*)getCurrentuserID {
    return (NSString*)[self.userConfigDic objectForKey:_USER_ID_];
}

//设置当前用户的trueName
-(void)setCurrentTrueName:(NSString *)trueName
{
    [self.userConfigDic setValue:trueName forKey:_USER_TRUENAME_];
    [self saveConfigerData];
}
//得到当前用户的trueName
-(NSString *)getCurrentTrueName
{
    return (NSString *)[self.userConfigDic objectForKey:_USER_TRUENAME_];
}

//设置当前用户的昵称
-(void)setCurrentNickName:(NSString *)nickName
{
    [self.userConfigDic setValue:nickName forKey:_USER_NICKNAME_];
    [self saveConfigerData];
}
//得到当前用户的昵称
-(NSString *)getCurrentNickName
{
    return (NSString *)[self.userConfigDic objectForKey:_USER_NICKNAME_];
}

//设置当前用户的性别
-(void)setCurrentuserGender:(NSString *)gender
{
    [self.userConfigDic setValue:gender forKey:_USER_GENDER_];
    [self saveConfigerData];
}
//得到当前用户的性别
-(NSString *)getCurrentUserGender
{
    return (NSString *)[self.userConfigDic objectForKey:_USER_GENDER_];
}

//设置当前用户的年龄
-(void)setCurrentAge:(NSString *)age {
    [self.userConfigDic setValue:age forKey:_USER_AGE_];
    [self saveConfigerData];
}
//得到当前用户的年龄
-(NSString *)getCurrentAge {
    return (NSString *)[self.userConfigDic objectForKey:_USER_AGE_];
}


//设置当前用户的手机号码
-(void)setCurrentPhoneNum:(NSString *)phoneNum
{
    [self.userConfigDic setValue:phoneNum forKey:_USER_PHONENUM_];
    [self saveConfigerData];
}
//得到当前用户的手机号码
-(NSString *)getCurrentPhoneNum
{
    return (NSString *)[self.userConfigDic objectForKey:_USER_PHONENUM_];
}

//设置当前用户的地区
-(void)setCurrentPlace:(NSString *)place {
    [self.userConfigDic setValue:place forKey:_USER_PLACE_];
    [self saveConfigerData];
}
//得到当前用户的地区
-(NSString *)getCurrentPlace {
    return (NSString *)[self.userConfigDic objectForKey:_USER_PLACE_];
}

//设置当前侧边栏状态
- (void)setCurrentMenu:(NSString *)menu {
    [self.userConfigDic setValue:menu forKey:_LIST_MENU_];
    [self saveConfigerData];
}
//得到当前侧边栏状态
- (NSString *)getcurrentMenu {
    return (NSString *)[self.userConfigDic objectForKey:_LIST_MENU_];
}

//设置当前用户的密码
- (void)setCurrentUserPsd:(NSString*)userPsd {
    [self.userConfigDic setValue:userPsd forKey:_USER_PASSWORD_];
    [self saveConfigerData];
}

//得到当前用户的密码
- (NSString*)getCurrentUserPsd {
    return (NSString*)[self.userConfigDic objectForKey:_USER_PASSWORD_];
}

//设置头像图片
-(void)setcurrentHeadImage:(NSString *)headImage
{
    [self.userConfigDic setValue:headImage forKey:_USER_HEADIMAGE_];
    [self saveConfigerData];
}
//得到当前用户头像
-(NSString *)getCurrentHeadImage
{
    return (NSString *)[self.userConfigDic objectForKey:_USER_HEADIMAGE_];
}

//设置当前登陆用户的头像
- (void)setCurrentUserHeadImage:(NSData *)headImageData
{
    [self.userConfigDic setValue:headImageData forKey:_USER_HEADIMAGEDATA_];
    [self saveConfigerData];
}
//得到当前登陆用户的头像
- (NSData *)getCurrentUserHeadImage
{
    return (NSData *)[self.userConfigDic objectForKey:_USER_HEADIMAGEDATA_];
}


//设置当前用户的token
-(void)setcurrentUserToken:(NSString *)UserToken {
    [self.userConfigDic setValue:UserToken forKey:_USER_TOKEN_];
    [self saveConfigerData];
}
//得到当前用户token
-(NSString *)getCurrentUserToken {
    return (NSString *)[self.userConfigDic objectForKey:_USER_TOKEN_];
}
//设置当前用户的描述
- (void)setCurrentUserDesb:(NSString *)userDesb {
    [self.userConfigDic setValue:userDesb forKey:_USER_DESB_];
    [self saveConfigerData];
}
//得到当前用户的描述
- (NSString *)getCurrentUserDesb {
    return (NSString *)[self.userConfigDic objectForKey:_USER_DESB_];
}

//设置当前用户的职称
- (void)setCurrentUserTechnology:(NSString *)userTech {
    [self.userConfigDic setValue:userTech forKey:_USER_TECH_];
    [self saveConfigerData];
}
//得到当前用户的职称
- (NSString *)getCurrentUserTechnology {
    return (NSString *)[self.userConfigDic objectForKey:_USER_TECH_];
}

//设置当前用户的账号
- (void)setCurrentUserAccount:(NSString *)userAccount {
    [self.userConfigDic setValue:userAccount forKey:_USER_ACCOUNT_NUM_];
    [self saveConfigerData];
}
//得到当前用户的账号
- (NSString *)getCurrentUserAccount {
    return (NSString *)[self.userConfigDic objectForKey:_USER_ACCOUNT_NUM_];
}

//设置当前用户的认证信息
- (void)setCurrentUserIdentify:(NSString *)userIdentify {
    [self.userConfigDic setValue:userIdentify forKey:_USER_IDENTIFY_];
    [self saveConfigerData];
}
//得到当前用户的认证信息
- (NSString *)getCurrentUserIdentify{
    return (NSString *)[self.userConfigDic objectForKey:_USER_IDENTIFY_];
}

//设置当前用户的职称
- (void)setCurrentUserJobTitle:(NSString *)userJobTitle
{
    [self.userConfigDic setValue:userJobTitle forKey:_USER_JOBTITLE];
    [self saveConfigerData];
}
//得到当前用户的职称
- (NSString *)getCurrentUserJobTitle
{
    return (NSString *)[self.userConfigDic objectForKey:_USER_JOBTITLE];
}



@end
