//
//  ChoiceCarViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/13.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"

@protocol SelectedCar <NSObject>
- (void)selectedCarWithCarModel:(CarModel *)model;
@end


@interface ChoiceCarViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *choiceCarTableView;

@property (nonatomic,weak) id<SelectedCar> delegate;

- (IBAction)backBtnClick:(id)sender;
@end
