//
//  SearchParkingViewController.h
//  P-Share
//
//  Created by VinceLee on 15/11/24.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchParkingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (nonatomic,assign) float nowLatitude;//当前经度
@property (nonatomic,assign) float nowLongitude;//当前纬度

- (IBAction)backBtnClick:(id)sender;

@end
