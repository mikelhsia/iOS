//
//  AddressViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/18.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingModel.h"

@protocol SelectedParking <NSObject>

@optional
- (void)selectedParkingAtHome:(ParkingModel *)model;
- (void)selectedParkingAtMonthlyRent:(ParkingModel *)model;

@end

@interface AddressViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UITableView *mySearchTableView;

@property (nonatomic,copy) NSString *homeAddress;
@property (nonatomic,copy) NSString *monthlyRentAddress;
@property (nonatomic,copy) NSString *homeOrMonthlyRent;

@property (nonatomic,weak) id<SelectedParking> delegate;

- (IBAction)backBtnClick:(id)sender;
- (IBAction)searchBtnClick:(id)sender;
@end


