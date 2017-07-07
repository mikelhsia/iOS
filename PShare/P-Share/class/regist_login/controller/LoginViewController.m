//
//  LoginViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "ResetPswViewController.h"
#import "HomeViewController.h"
#import "NewHomeViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //设置UI界面
    [self setUI];
    
    ALLOC_MBPROGRESSHUD;
}

//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneNumTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    return YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_phoneNumTextField becomeFirstResponder];
}
//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNumTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)setUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.headerView.backgroundColor = MAIN_COLOR;
    
    self.loginBackView.layer.borderWidth = 0.5;
    self.loginBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.loginBackView.layer.cornerRadius = 4;
    self.loginBackView.layer.masksToBounds = YES;
    
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.backgroundColor = MAIN_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)registBtnClick:(id)sender {
    RegistViewController *registCtrl = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:registCtrl animated:YES];
}

- (IBAction)loginBtnClick:(id)sender {
    
    if ([MyUtil isMobileNumber:self.phoneNumTextField.text]) {
        if (self.passwordTextField.text.length >=8 && self.passwordTextField.text.length <=20)
        {
            BEGIN_MBPROGRESSHUD;
            
            AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
            tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
            tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSDictionary *paramDic = @{@"customer_mobile":self.phoneNumTextField.text,@"customer_password":self.passwordTextField.text};
            NSString *urlString = [USER_Login stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([result isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = result;
                    
                    if ([dict[@"code"] isEqualToString:@"000000"]) {
                        
                        //存储用户信息的字典
                        NSDictionary *infoDict = dict[@"datas"][@"customerInfo"];
                        
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setBool:YES forKey:had_Login];
                        [userDefaults setObject:infoDict[@"customer_id"] forKey:customer_id];
                        [userDefaults setObject:infoDict[@"customer_mobile"] forKey:customer_mobile];
                        [userDefaults setObject:infoDict[@"customer_email"] forKey:customer_email];
                        [userDefaults setObject:infoDict[@"customer_region"] forKey:customer_region];
                        [userDefaults setObject:infoDict[@"customer_nickname"] forKey:customer_nickname];
                        NSNumber *num = infoDict[@"customer_sex"];
                        [userDefaults setObject:num forKey:customer_sex];
                        [userDefaults setObject:infoDict[@"customer_job"] forKey:customer_job];
                        if ([infoDict[@"customer_head"] length] > 5) {
                            NSString *imageString = [infoDict[@"customer_head"] substringToIndex:[infoDict[@"customer_head"] length]-1];
                            [userDefaults setObject:imageString forKey:customer_head];
                        }
                        [userDefaults synchronize];
                        MyLog(@"%@",infoDict[@"customer_sex"]);
                        //        HomeViewController *homeCtrl = [[HomeViewController alloc] init];
                        //        [self.navigationController pushViewController:homeCtrl animated:NO];
                        NewHomeViewController *homeCtrl = [[NewHomeViewController alloc] init];
                        [self.navigationController pushViewController:homeCtrl animated:NO];
                    }else{
                        ALERT_VIEW(dict[@"msg"]);
                        _alert = nil;
                    }
                    
                    MyLog(@"%@",dict);
                }
                END_MBPROGRESSHUD;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                ALERT_VIEW(@"登陆失败!");
                _alert = nil;
                MyLog(@"%@",error);
                END_MBPROGRESSHUD;
            }];
        }else
        {
            ALERT_VIEW(@"密码为8-20位");
            _alert = nil;
        }
    }else
    {
        ALERT_VIEW(@"请输入正确手机号");
        _alert = nil;
    }
}

- (void)dealloc
{
    _alert = nil;
}

- (IBAction)forgetPswBtnClick:(id)sender {
    ResetPswViewController *resetCtrl = [[ResetPswViewController alloc] init];
    [self.navigationController pushViewController:resetCtrl animated:YES];
    
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
