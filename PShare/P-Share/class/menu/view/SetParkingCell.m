//
//  SetParkingCell.m
//  P-Share
//
//  Created by VinceLee on 15/11/23.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "SetParkingCell.h"

@implementation SetParkingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)setHomeParkingBtnClick:(id)sender {
    if (self.setHomeParkingBlock) {
        self.setHomeParkingBlock(self.index);
    }
}
@end
