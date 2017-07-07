//
//  RegistViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthcodeView.h"

@interface RegistViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *textCodeTextField;
@property (weak, nonatomic) IBOutlet UIView *registBackView;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *getTextCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *headerView;

- (IBAction)agreeBtnClick:(id)sender;

- (IBAction)getTextCodeBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)registBtnClick:(id)sender;
- (IBAction)haveRegistBtnClick:(id)sender;

@end
