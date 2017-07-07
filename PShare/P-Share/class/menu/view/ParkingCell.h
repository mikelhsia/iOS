//
//  ParkingCell.h
//  P-Share
//
//  Created by VinceLee on 15/11/19.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UIImageView *parkingImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *parkingTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkIsParkLabel;

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) void (^gotoNavBlock)(NSInteger index);

- (IBAction)navBtnClick:(id)sender;

@end
