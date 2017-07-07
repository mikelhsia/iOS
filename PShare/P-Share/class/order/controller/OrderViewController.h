//
//  OrderViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/7.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;

//----------------- view1
@property (weak, nonatomic) IBOutlet UIView *view1View;

@property (weak, nonatomic) IBOutlet UIView *cancelView;
@property (weak, nonatomic) IBOutlet UILabel *view1Label1;
@property (weak, nonatomic) IBOutlet UILabel *view1Label2;
@property (weak, nonatomic) IBOutlet UIImageView *aniImageView;
@property (weak, nonatomic) IBOutlet UIButton *view1SureBtn;

- (IBAction)view1SureBtnClick:(id)sender;

//----------------- view2
@property (weak, nonatomic) IBOutlet UIView *view2View;

@property (weak, nonatomic) IBOutlet UIImageView *parkerHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *parkerNameLabel;//代泊员姓名
@property (weak, nonatomic) IBOutlet UILabel *parkerTitleLabel;//代泊员职位
@property (weak, nonatomic) IBOutlet UILabel *parkerChargeLabel;//负责区域
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;//预约时间
@property (weak, nonatomic) IBOutlet UIButton *view2SureBtn;
@property (weak, nonatomic) IBOutlet UILabel *parkerPhoneNumLabel;

- (IBAction)view2SureBtnClick:(id)sender;
- (IBAction)view2CallBtnClick:(id)sender;

//----------------- view3
@property (weak, nonatomic) IBOutlet UIView *view3View;

@property (weak, nonatomic) IBOutlet UIImageView *parkerHeaderImageView2;
@property (weak, nonatomic) IBOutlet UILabel *parkerNameLabel2;
@property (weak, nonatomic) IBOutlet UILabel *parkerTitleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *parkerChargeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *getCarTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingCarTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;

@property (weak, nonatomic) IBOutlet UIView *carPictureView;
@property (weak, nonatomic) IBOutlet UIScrollView *carPictureScrollView;
- (IBAction)leftBtnClick:(id)sender;
- (IBAction)rightBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *view3SureBtn;
@property (weak, nonatomic) IBOutlet UILabel *parkerPhoneNumLabel2;

- (IBAction)view3callBtnClick:(id)sender;
- (IBAction)view3SureBtnClick:(UIButton *)sender;
//-----------------

- (IBAction)backBtnClick:(id)sender;


//支付相关
//-----------
@property (weak, nonatomic) IBOutlet UIView *grayBackView;
@property (weak, nonatomic) IBOutlet UIView *payBackView;
@property (weak, nonatomic) IBOutlet UIButton *gotoPayBtn;


@property (weak, nonatomic) IBOutlet UIImageView *zhiFuBaoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *weiXinImageView;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyCountLabel;

- (IBAction)cancelPayBtnClick:(id)sender;
- (IBAction)selectZhiFuBaoBtnClick:(id)sender;
- (IBAction)selectWeiXinBtnClick:(id)sender;
- (IBAction)gotoPayBtnClick:(id)sender;
//-----------

//评价相关
@property (weak, nonatomic) IBOutlet UIImageView *veryGooodImage;
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UIImageView *narmolImage;
@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;
@property (weak, nonatomic) IBOutlet UIView *commentBackView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentCenterY;

- (IBAction)commentBtnClick:(UIButton *)sender;
- (IBAction)sureBtnClick:(id)sender;

@end
