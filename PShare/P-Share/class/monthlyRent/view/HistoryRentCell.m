//
//  HistoryRentCell.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/11.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "HistoryRentCell.h"

@implementation HistoryRentCell

- (void)awakeFromNib {
    // Initialization code
    
    self.payBtn.layer.cornerRadius = 3;
    self.payBtn.layer.masksToBounds = YES;
    self.payBtn.backgroundColor = MAIN_COLOR;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)payBtnClick:(id)sender {
    
}
@end


