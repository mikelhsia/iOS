//
//  RegistViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "RegistViewController.h"
#import "LoginViewController.h"
#import "AgreementViewController.h"
#import "HomeViewController.h"

@interface RegistViewController ()<UITextFieldDelegate>
{
    UIAlertView *_alert;
    
    int _getCodeCount;
    
    NSTimer *_buttonTimer;
    
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
}
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    _getCodeCount = 60;
    //设置UI界面
    [self setUI];
    
    ALLOC_MBPROGRESSHUD;
}

//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneNumTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_textCodeTextField resignFirstResponder];
    
    return YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_phoneNumTextField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_buttonTimer invalidate];
    _buttonTimer = nil;
}

//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNumTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_textCodeTextField resignFirstResponder];
}


- (void)setUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.headerView.backgroundColor = MAIN_COLOR;
    self.registBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.registBackView.layer.borderWidth = 0.5;
    self.registBackView.layer.cornerRadius = 4;
    self.registBackView.layer.masksToBounds = YES;
    self.registBtn.layer.cornerRadius = 4;
    self.registBtn.layer.masksToBounds = YES;
    self.registBtn.backgroundColor = MAIN_COLOR;
    
    [self.getTextCodeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


- (IBAction)agreeBtnClick:(id)sender {
    AgreementViewController *agreeCtrl = [[AgreementViewController alloc] init];
    [self.navigationController pushViewController:agreeCtrl animated:YES];
}

- (IBAction)getTextCodeBtnClick:(id)sender {
    if ([MyUtil isMobileNumber:self.phoneNumTextField.text]) {
        BEGIN_MBPROGRESSHUD;   // 开启界面加载视图HUD
        //----------------------------------
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *paramDic = @{MOBILE_CUSTOMER:self.phoneNumTextField.text};
        NSString *urlString = [GET_USER_CODE stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if ([result isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = result;
                 
                 if ([dict[@"code"] isEqualToString:@"000000"])
                 {
                     _buttonTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ButtonTitleRefreshForget) userInfo:nil repeats:YES];
                     [_buttonTimer fire];
                 }
//                 MyLog(@"%@",dict);
             }
             END_MBPROGRESSHUD;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             ALERT_VIEW(@"获取失败");
             _alert = nil;
             END_MBPROGRESSHUD;
         }];
        //----------------------------------
    }else{
        ALERT_VIEW(@"请输入正确手机号");
        _alert = nil;
    }
    
}

- (void)ButtonTitleRefreshForget
{
    [self.getTextCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.getTextCodeBtn.enabled = NO;
    self.getTextCodeBtn.titleLabel.text = [NSString stringWithFormat:@"重新获取(%d)",_getCodeCount];
    [self.getTextCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_getCodeCount] forState:UIControlStateNormal];
    if (_getCodeCount == 0) {
        [_buttonTimer invalidate];
        _buttonTimer = nil;
        
        self.getTextCodeBtn.enabled = YES;
        [self.getTextCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getTextCodeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        
        _getCodeCount = 60;
    }
    _getCodeCount--;
    
}

//- (void)stopButtonTitleRefreshForget
//{
//    [_buttonTimer invalidate];
//    _buttonTimer = nil;
//    
//    self.getTextCodeBtn.enabled = YES;
//    [self.getTextCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [self.getTextCodeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
//}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registBtnClick:(id)sender {
    
    if ([MyUtil isMobileNumber:self.phoneNumTextField.text])
    {
        if (self.passwordTextField.text.length >=8 && self.passwordTextField.text.length <=20)
        {
            if (self.textCodeTextField.text.length == 4)
            {
                BEGIN_MBPROGRESSHUD;
                
                AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
                tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
                tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
                
                NSDictionary *paramDic = @{MOBILE_CUSTOMER:self.phoneNumTextField.text,PASSWORD_CUSTOMER:self.passwordTextField.text,smsCode:self.textCodeTextField.text};
                NSString *urlString = [USER_REGIST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                     
                     id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                     if ([result isKindOfClass:[NSDictionary class]])
                     {
                         NSDictionary *dict = result;
                         
                         if ([dict[@"code"] isEqualToString:@"000000"])
                         {
                             if ([dict[@"msg"] isEqualToString:@"success"]) {
                                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                 [userDefaults setBool:YES forKey:had_Login];
                                 [userDefaults setObject:self.phoneNumTextField.text forKey:customer_mobile];
                                 [userDefaults setObject:dict[@"datas"][@"customer_id"] forKey:customer_id];
                                 [userDefaults synchronize];
                                 [userDefaults setInteger:-1 forKey:customer_selectPark];
                                 HomeViewController *homeCtrl = [[HomeViewController alloc] init];
                                 [self.navigationController pushViewController:homeCtrl animated:YES];
                             }else{
                                 ALERT_VIEW(dict[@"msg"]);
                             }
                         }else
                         {
                             ALERT_VIEW(dict[@"msg"]);
                         }
                         MyLog(@"%@",dict);
                     }
                     END_MBPROGRESSHUD;
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     MyLog(@"%@",error);
                     END_MBPROGRESSHUD;
                 }];
            }else{
                ALERT_VIEW(@"请输入四位验证码");
                _alert = nil;
            }
            
        }else{
            ALERT_VIEW(@"密码为8-20位");
            _alert = nil;
        }
    }else{
        ALERT_VIEW(@"请输入正确手机号");
        _alert = nil;
    }
    
}

- (void)dealloc
{
    _alert = nil;
}

- (IBAction)haveRegistBtnClick:(id)sender {
    LoginViewController *loginCtrl = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginCtrl animated:YES];
}
@end



