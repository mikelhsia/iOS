//
//  DiscountViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/6.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *discountTextField;
@property (weak, nonatomic) IBOutlet UIButton *discountBtn;
@property (weak, nonatomic) IBOutlet UITableView *discountTableView;
@property (weak, nonatomic) IBOutlet UIView *noDiscountView;

@property (nonatomic, copy) NSString* strScan;

- (IBAction)backBtnClick:(id)sender;
- (IBAction)discountBtnClick:(id)sender;

@end
