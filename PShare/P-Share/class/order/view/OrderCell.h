//
//  OrderCell.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/7.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *parkTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentMonthLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
