//
//  MenuViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/5.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *searchResultLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *mapBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UIView *searchBackView;
@property (weak, nonatomic) IBOutlet UIView *searchHeaderView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

//我的家相关
@property (weak, nonatomic) IBOutlet UIView *myHomeView;
@property (weak, nonatomic) IBOutlet UILabel *myHomeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *myHomeDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *myHomeStateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myHomeViewBottom;
@property (weak, nonatomic) IBOutlet UIButton *changeMyHomeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *editingImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
- (IBAction)editingBtnClick:(id)sender;

- (IBAction)gotoSelectParkingBtnClick:(id)sender;
- (IBAction)changeMyHomeBtnClick:(id)sender;
//------------


- (IBAction)cancelSearchBtnClick:(id)sender;
- (IBAction)beginSearchBtnClick:(id)sender;

- (IBAction)leftUserBtnClick:(id)sender;
- (IBAction)midSearchBtnClick:(id)sender;
- (IBAction)rightListBtnClick:(id)sender;

@end
