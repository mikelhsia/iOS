//
//  AgreementViewController.h
//  P-Share
//
//  Created by 杨继垒 on 15/10/24.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreementViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

- (IBAction)backBtnClick:(id)sender;
@end
