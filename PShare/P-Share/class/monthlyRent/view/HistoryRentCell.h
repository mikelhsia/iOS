//
//  HistoryRentCell.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/11.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryRentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

- (IBAction)payBtnClick:(id)sender;

@end
