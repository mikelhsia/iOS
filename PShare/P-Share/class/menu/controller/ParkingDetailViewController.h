//
//  ParkingDetailViewController.h
//  P-Share
//
//  Created by VinceLee on 15/11/23.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingModel.h"

@interface ParkingDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *parkingImageView;
@property (weak, nonatomic) IBOutlet UILabel *parikingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingAdressLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingCanUseLabel;

@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLalbel;
@property (weak, nonatomic) IBOutlet UIImageView *setHomeImageView;
@property (weak, nonatomic) IBOutlet UILabel *setHomeLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *daiboLeading;
@property (weak, nonatomic) IBOutlet UILabel *parkingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingDaiBoLabel;

@property (weak, nonatomic) IBOutlet UIButton *parkingBtn;

@property (weak, nonatomic) IBOutlet UILabel *beginOrderLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myActivityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *timeCountLabel;

//分享相关
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
- (IBAction)weiXinShareBtnClick:(id)sender;
- (IBAction)pengYouShareBtnClick:(id)sender;
- (IBAction)weiboShareBtnClick:(id)sender;

@property (nonatomic,strong) ParkingModel *parkingModel;
@property (nonatomic,assign) float nowLatitude;//当前经度
@property (nonatomic,assign) float nowongitude;//当前纬度

- (IBAction)favoriteBtnClick:(id)sender;
- (IBAction)navBtnClick:(id)sender;
- (IBAction)shareBtnClick:(id)sender;
- (IBAction)setHomeBtnClick:(id)sender;
- (IBAction)carStewardBtnClick:(id)sender;

- (IBAction)parkingBtnClick:(id)sender;

- (IBAction)backBtnClick:(id)sender;

@end





