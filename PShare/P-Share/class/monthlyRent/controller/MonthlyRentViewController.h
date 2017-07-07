//
//  MonthlyRentViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/11.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthlyRentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *choiceView;
@property (weak, nonatomic) IBOutlet UIButton *rentBtn;
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;
@property (weak, nonatomic) IBOutlet UITableView *rentTableView;

- (IBAction)backBtnClick:(id)sender;

@end
