//
//  AddRentViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/13.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *addRenttableView;
@property (weak, nonatomic) IBOutlet UIView *grayBackView;
@property (weak, nonatomic) IBOutlet UIPickerView *addRentPickerView;

- (IBAction)backBtnClick:(id)sender;

@end
