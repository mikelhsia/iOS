//
//  AddRentCell.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/13.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "AddRentCell.h"

@implementation AddRentCell
{
    UILabel *_titleLabel;
}
- (void)awakeFromNib {
    // Initialization code
    
    [self createKeyboardTopView];
    
    self.rightTextField.delegate = self;
    
    [self.rightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)createKeyboardTopView
{
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    myView.backgroundColor = MAIN_COLOR;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 45, 20)];
    nameLabel.text = @"姓名:";
    nameLabel.textColor = [UIColor whiteColor];
    [myView addSubview:nameLabel];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, SCREEN_WIDTH-100, 20)];
    _titleLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.layer.cornerRadius = 3;
    _titleLabel.layer.masksToBounds = YES;
    [myView addSubview:_titleLabel];
    
    UIImageView *tickImageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 14, 17, 12)];
    tickImageVIew.image = [UIImage imageNamed:@"tick"];
    [myView addSubview:tickImageVIew];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(SCREEN_WIDTH-40, 0, 40, 40);
    [btn addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:btn];
    
    self.rightTextField.inputAccessoryView = myView;
}

- (void) textFieldDidChange:(UITextField *) TextField
{
    _titleLabel.text = TextField.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //获取隐藏键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideRentKeyBoard:) name:@"hideAddRentKeyboard" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hideRentKeyBoard:(NSNotification *)sender
{
    [self.rightTextField resignFirstResponder];
}

- (void)hideKeyBoard
{
    [self.rightTextField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.transmitNameValue) {
        self.transmitNameValue();
    }
}

@end




