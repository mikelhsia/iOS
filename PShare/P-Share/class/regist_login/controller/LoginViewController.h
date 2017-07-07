//
//  LoginViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *loginBackView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *headerView;

- (IBAction)registBtnClick:(id)sender;
- (IBAction)loginBtnClick:(id)sender;
- (IBAction)forgetPswBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;

@end
