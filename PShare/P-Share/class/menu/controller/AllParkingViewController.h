//
//  AllParkingViewController.h
//  P-Share
//
//  Created by VinceLee on 15/11/20.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllParkingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *allTableView;

@property (nonatomic,assign) float nowLatitude;//当前经度（从HomeViewConteoller传过来的值）
@property (nonatomic,assign) float nowLongitude;//当前纬度（从HomeViewConteoller传过来的值）

@property (nonatomic,copy) NSString *homeLatitude;//从HomeViewConteoller传过来的值，保存的是首页停车场的坐标
@property (nonatomic,copy) NSString *homeLongitude;//从HomeViewConteoller传过来的值，保存的是首页停车场的坐标

- (IBAction)backBtnClick:(id)sender;
- (IBAction)mapBtnClick:(id)sender;

@end
