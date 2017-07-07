//
//  ParkingCell.m
//  P-Share
//
//  Created by VinceLee on 15/11/19.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "ParkingCell.h"

@implementation ParkingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)navBtnClick:(id)sender {
    if (self.gotoNavBlock) {
        self.gotoNavBlock(self.index);
    }
}
@end
