//
//  ConfirmPswViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "ConfirmPswViewController.h"
#import "LoginViewController.h"
@interface ConfirmPswViewController ()
{
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
}
@end

@implementation ConfirmPswViewController

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
    [_passwordOneTextfield resignFirstResponder];
    [_passwordTwoTextField resignFirstResponder];
    
    return YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_passwordOneTextfield becomeFirstResponder];
}

//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_passwordOneTextfield resignFirstResponder];
    [_passwordTwoTextField resignFirstResponder];
}

- (void)setUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.headerView.backgroundColor = MAIN_COLOR;
    
    self.confirmBackView.layer.borderWidth = 0.5;
    self.confirmBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.confirmBackView.layer.cornerRadius = 4;
    self.confirmBackView.layer.masksToBounds = YES;
    
    self.makeSureBtn.layer.cornerRadius = 4;
    self.makeSureBtn.layer.masksToBounds = YES;
    self.makeSureBtn.backgroundColor = MAIN_COLOR;
    
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

- (IBAction)makeSureBtnClick:(id)sender {
    if (self.passwordOneTextfield.text.length >=8 && self.passwordOneTextfield.text.length <=20) {
        if ([self.passwordOneTextfield.text isEqualToString:self.passwordTwoTextField.text]) {
            BEGIN_MBPROGRESSHUD;
            
            AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
            tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
            tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSDictionary *paramDic = @{MOBILE_CUSTOMER:self.userPhoneNum,PASSWORD_CUSTOMER:self.passwordOneTextfield.text};
            MyLog(@"%@",RESET_PWD);
            NSString *urlString = [RESET_PWD stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([result isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = result;
                    
                    if ([dict[@"code"] isEqualToString:@"000000"]) {
                        
                        LoginViewController *loginCtrl = [[LoginViewController alloc] init];
                        [self.navigationController pushViewController:loginCtrl animated:YES];
                    }else{
                        ALERT_VIEW(@"修改失败!");
                        _alert = nil;
                    }
                    
                    MyLog(@"%@",dict);
                }
                END_MBPROGRESSHUD
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                ALERT_VIEW(@"修改失败!");
                _alert = nil;
                END_MBPROGRESSHUD
            }];
            
        }else{
            ALERT_VIEW(@"两次密码不一致");
        }
    }else{
        ALERT_VIEW(@"密码为8-20位");
    }
}

- (void)dealloc
{
    _alert = nil;
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
