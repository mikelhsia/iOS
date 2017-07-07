//
//  HavePayViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/16.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentModel.h"

@interface HavePayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *havePayTableView;

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

@property (nonatomic,copy) NSString *comeType;
@property (nonatomic,strong) RentModel *addRentModel;

- (IBAction)backBtnClick:(id)sender;
@end
