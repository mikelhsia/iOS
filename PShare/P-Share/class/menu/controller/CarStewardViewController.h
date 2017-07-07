//
//  CarStewardViewController.h
//  P-Share
//
//  Created by VinceLee on 15/11/25.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarStewardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UIView *xiCheView;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;

- (IBAction)cancleBtnClick:(id)sender;
- (IBAction)callBtnClick:(id)sender;

- (IBAction)monthRentBtnClick:(id)sender;
- (IBAction)jiaYouBtnClick:(id)sender;
- (IBAction)xiCheBtnClick:(id)sender;

- (IBAction)backBtnClick:(id)sender;

@end
