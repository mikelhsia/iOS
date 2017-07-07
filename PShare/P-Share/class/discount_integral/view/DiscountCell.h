//
//  DiscountCell.h
//  P-Share
//
//  Created by VinceLee on 15/12/7.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *disTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *disDetailLabel1;
@property (weak, nonatomic) IBOutlet UILabel *disDetailLabel2;
@property (weak, nonatomic) IBOutlet UILabel *disDetailLabel3;
@property (weak, nonatomic) IBOutlet UILabel *disNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *disNameLabel;

@end
