//
//  SetParkingCell.h
//  P-Share
//
//  Created by VinceLee on 15/11/23.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetParkingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UIImageView *parkingImageView;
@property (weak, nonatomic) IBOutlet UILabel *parkingTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *setHomeParkingBtn;

@property (nonatomic,assign) NSInteger index;
- (IBAction)setHomeParkingBtnClick:(id)sender;

@property (nonatomic,copy) void (^setHomeParkingBlock)(NSInteger index);

@end
