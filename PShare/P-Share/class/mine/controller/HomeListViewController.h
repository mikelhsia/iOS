//
//  HomeListViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/16.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *homeListTableView;

- (IBAction)backBtnClick:(id)sender;
@end
