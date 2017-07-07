//
//  TemParkingViewController.h
//  P-Share
//
//  Created by VinceLee on 15/12/7.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemParkingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *searchView1;
@property (weak, nonatomic) IBOutlet UITextField *parkingTextField;
@property (weak, nonatomic) IBOutlet UIView *searchView2;
@property (weak, nonatomic) IBOutlet UITextField *carNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIView *detailView1;
@property (weak, nonatomic) IBOutlet UILabel *parkBeginLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *detailView2;
@property (weak, nonatomic) IBOutlet UILabel *freePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *detailView3;
@property (weak, nonatomic) IBOutlet UIImageView *selectWechatImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectAlipayImageView;
@property (weak, nonatomic) IBOutlet UIButton *surePayBtn;

- (IBAction)getParkBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)searchBtnClick:(id)sender;
- (IBAction)freePriceBtnClick:(id)sender;
- (IBAction)selectWechatBtnClick:(id)sender;
- (IBAction)selectAlipayBtnClick:(id)sender;
- (IBAction)surePayBtnClick:(id)sender;

@end




