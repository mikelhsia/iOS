//
//  CarListViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/9.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *carListTableView;
@property (weak, nonatomic) IBOutlet UIImageView *editingImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

- (IBAction)backBtnClick:(id)sender;
- (IBAction)editingBtnClick:(id)sender;

@end
