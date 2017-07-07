//
//  AddRentCell.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/13.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRentCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (nonatomic,copy) void (^transmitNameValue)(void);

@end
