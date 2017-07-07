//
//  ResetPswViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "ResetPswViewController.h"
#import "ConfirmPswViewController.h"

@interface ResetPswViewController ()<UITextFieldDelegate>
{
    UIAlertView *_alert;
    
    int _getCodeCount;
    
    NSTimer *_buttonTimer;
    
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
}
@end

@implementation ResetPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _getCodeCount = 60;
    //设置UI界面
    [self setUI];
    
    ALLOC_MBPROGRESSHUD;
}

//隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneNumTextField resignFirstResponder];
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
    
    [self stopButtonTitleRefreshForget];
}


//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNumTextField resignFirstResponder];
    [_textCodeTextField resignFirstResponder];
}

- (void)setUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.headerView.backgroundColor = MAIN_COLOR;
    
    self.forgetBackView.layer.borderWidth = 0.5;
    self.forgetBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.forgetBackView.layer.cornerRadius = 4;
    self.forgetBackView.layer.masksToBounds = YES;
    
    self.makeSureBtn.layer.cornerRadius = 4;
    self.makeSureBtn.layer.masksToBounds = YES;
    self.makeSureBtn.backgroundColor = MAIN_COLOR;
    
    [self.textCodeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
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

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (IBAction)getTextCodeBtnClick:(id)sender {
    if ([MyUtil isMobileNumber:self.phoneNumTextField.text]) {
        BEGIN_MBPROGRESSHUD;
        //----------------------------------
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *paramDic = @{MOBILE_CUSTOMER:self.phoneNumTextField.text};
        MyLog(@"%@",USER_REGIST);
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
                 MyLog(@"%@",dict);
             }
             END_MBPROGRESSHUD;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             MyLog(@"%@",error);
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
    [self.textCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.textCodeBtn.enabled = NO;
    self.textCodeBtn.titleLabel.text = [NSString stringWithFormat:@"重新获取(%d)",_getCodeCount];
    [self.textCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_getCodeCount] forState:UIControlStateNormal];
    if (_getCodeCount == 0) {
        [_buttonTimer invalidate];
        _buttonTimer = nil;
        
        self.textCodeBtn.enabled = YES;
        [self.textCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.textCodeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        
        _getCodeCount = 60;
    }
    _getCodeCount--;
    
}

- (void)stopButtonTitleRefreshForget
{
    [_buttonTimer invalidate];
    _buttonTimer = nil;
    
    self.textCodeBtn.enabled = YES;
    [self.textCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.textCodeBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
}

- (IBAction)makeSureBtnClick:(id)sender {
    if ([MyUtil isMobileNumber:self.phoneNumTextField.text])
    {
        if (self.textCodeTextField.text.length == 4)
        {
            BEGIN_MBPROGRESSHUD;
            
            AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
            tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
            tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSDictionary *paramDic = @{MOBILE_CUSTOMER:self.phoneNumTextField.text,smsCode:self.textCodeTextField.text};
            NSString *urlString = [VERIFY_USER_CODE stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 if ([result isKindOfClass:[NSDictionary class]])
                 {
                     NSDictionary *dict = result;
                     
                     if ([dict[@"code"] isEqualToString:@"000000"])
                     {
                         if ([dict[@"msg"] isEqualToString:@"success"]) {
                             ConfirmPswViewController *confirmCtrl = [[ConfirmPswViewController alloc] init];
                             confirmCtrl.userPhoneNum = self.phoneNumTextField.text;
                             [self.navigationController pushViewController:confirmCtrl animated:YES];
                         }else{
                             ALERT_VIEW(dict[@"msg"]);
                             _alert = nil;
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
        ALERT_VIEW(@"请输入正确手机号");
        _alert = nil;
    }
}

- (void)dealloc
{
    
}
@end






