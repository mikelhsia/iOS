//
//  NewHomeViewController.h
//  P-Share
//
//  Created by fay on 15/12/29.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

@interface NewHomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *gongSiBtn;
//添加停车场
@property (weak, nonatomic) IBOutlet UIView *AddParkView;

@property (weak, nonatomic) IBOutlet MarqueeLabel *infoTitleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shengYuCheWeiWidth;
//展示停车场相关
@property (weak, nonatomic) IBOutlet UIView *showParkView;
@property (weak, nonatomic) IBOutlet UILabel *shengYuCheWeiNum;
@property (weak, nonatomic) IBOutlet UILabel *parkName;
@property (weak, nonatomic) IBOutlet UIImageView *parkBgImage;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;



@end
