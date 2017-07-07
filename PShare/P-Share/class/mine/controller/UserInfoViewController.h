//
//  UserInfoViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/8.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpdataUserInfoDelegate <NSObject>

- (void)updataUserInfo;

@end

@interface UserInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *editingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userID;
@property (weak, nonatomic) IBOutlet UILabel *integralNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *honestyNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *userJobTextField;
@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UILabel *userSexLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPlaceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexRightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeRightImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImageViewWidth;

//pickerView相关
@property (weak, nonatomic) IBOutlet UIView *grayBackView;
@property (weak, nonatomic) IBOutlet UIPickerView *userPickerView;

@property (nonatomic,weak) id<UpdataUserInfoDelegate>delegate;

- (IBAction)backBtnClick:(id)sender;
- (IBAction)editingBtnClick:(id)sender;
- (IBAction)sexBtnClick:(id)sender;
- (IBAction)placeBtnClick:(id)sender;
- (IBAction)tapHeaderImageView:(id)sender;

@end
