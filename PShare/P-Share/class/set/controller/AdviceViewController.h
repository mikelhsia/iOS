//
//  AdviceViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/8.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdviceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextView *adviceTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)backBtnClick:(id)sender;
- (IBAction)submitBtnClick:(id)sender;

@end
