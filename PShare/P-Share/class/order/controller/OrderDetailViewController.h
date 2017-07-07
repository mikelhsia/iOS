//
//  OrderDetailViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/14.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *parkerHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *parkerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkerChargeLabel;//代泊员负责区域
@property (weak, nonatomic) IBOutlet UILabel *parderPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;

@property (nonatomic,strong) OrderModel *parkModel;

@property (weak, nonatomic) IBOutlet UIView *carPictureView;
@property (weak, nonatomic) IBOutlet UIScrollView *carPictureScrollView;
- (IBAction)leftBtnClick:(id)sender;
- (IBAction)rightBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *headerView;

- (IBAction)callBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;

@end
