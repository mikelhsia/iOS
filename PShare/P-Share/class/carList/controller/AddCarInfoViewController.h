//
//  AddCarInfoViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/7.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCarInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *carAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *carNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *carTypeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *headerView;

- (IBAction)backBtnClick:(id)sender;
- (IBAction)carAddressBtnClick:(id)sender;
- (IBAction)sureBtnClick:(id)sender;

@end
