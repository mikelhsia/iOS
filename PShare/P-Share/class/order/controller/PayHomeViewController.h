//
//  PayHomeViewController.h
//  P-Share
//
//  Created by VinceLee on 15/11/24.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayHomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;

- (IBAction)blueBtnClick:(id)sender;
- (IBAction)greenBtnClick:(id)sender;
- (IBAction)yellowBtnClick:(id)sender;

- (IBAction)backBtnClick:(id)sender;

@end
