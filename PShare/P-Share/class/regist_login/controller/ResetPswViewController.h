//
//  ResetPswViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthcodeView.h"

@interface ResetPswViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *textCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *textCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;
@property (weak, nonatomic) IBOutlet UIView *forgetBackView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *headerView;


- (IBAction)backBtnClick:(id)sender;
- (IBAction)getTextCodeBtnClick:(id)sender;
- (IBAction)makeSureBtnClick:(id)sender;

@end
