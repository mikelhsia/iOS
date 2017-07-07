//
//  FirstViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/2.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

//引导页相关
@property (weak, nonatomic) IBOutlet UIView *guideBackView;
@property (weak, nonatomic) IBOutlet UIScrollView *guideScrollView;
@property (weak, nonatomic) IBOutlet UIView *guideBottomView;
- (IBAction)guideBtnClick:(id)sender;



- (IBAction)registBtnClick:(id)sender;
- (IBAction)loginBtnClick:(id)sender;
@end
