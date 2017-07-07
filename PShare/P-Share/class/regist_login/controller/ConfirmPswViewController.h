//
//  ConfirmPswViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/1.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmPswViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *passwordOneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTwoTextField;
@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;
@property (weak, nonatomic) IBOutlet UIView *confirmBackView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic,strong) NSString *userPhoneNum;

- (IBAction)makeSureBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;

@end
