//
//  ScanResultViewController.h
//  P-Share
//
//  Created by VinceLee on 15/12/9.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic, copy) NSString* strScan;

- (IBAction)backBtnClick:(id)sender;

@end







