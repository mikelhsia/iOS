//
//  ParkAndFavViewController.h
//  P-Share
//
//  Created by VinceLee on 15/11/20.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkAndFavViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UIButton *historyOrderBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyOrderLabel;
@property (weak, nonatomic) IBOutlet UIView *ord_hisView;

@property (weak, nonatomic) IBOutlet UITableView *parkAndFavTableView;
@property (nonatomic,assign) float nowLatitude;//当前经度
@property (nonatomic,assign) float nowLongitude;//当前纬度

- (IBAction)backBtnClick:(id)sender;
- (IBAction)gotoMapBtnClick:(id)sender;

- (IBAction)allParkBtnClick:(id)sender;
- (IBAction)favoriteBtnClick:(id)sender;


@end




