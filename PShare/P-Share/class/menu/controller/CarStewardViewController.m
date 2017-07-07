//
//  CarStewardViewController.m
//  P-Share
//
//  Created by VinceLee on 15/11/25.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "CarStewardViewController.h"
#import "MonthlyRentViewController.h"

@interface CarStewardViewController ()
{
    UIAlertView *_alert;
}
@end

@implementation CarStewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headerView.backgroundColor = MAIN_COLOR;
    self.callBtn.layer.cornerRadius = 3;
    self.callBtn.layer.borderColor = MAIN_COLOR.CGColor;
    self.callBtn.layer.borderWidth = 1;
    
    self.grayView.hidden = YES;
    self.xiCheView.hidden = YES;
    
    if (SCREEN_WIDTH >= 375) {
        self.infoTextView.font = [UIFont systemFontOfSize:16];
        self.textViewTopConstraint.constant = 10;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancleBtnClick:(id)sender {
    self.grayView.hidden = YES; 
    self.xiCheView.hidden = YES;
}

- (IBAction)callBtnClick:(id)sender {
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:4000062637"]]];
    [self.view addSubview:callWebview];
    
    self.grayView.hidden = YES;
    self.xiCheView.hidden = YES;
}

- (IBAction)monthRentBtnClick:(id)sender {
    MonthlyRentViewController *monthlyCtrl = [[MonthlyRentViewController alloc] init];
    [self.navigationController pushViewController:monthlyCtrl animated:YES];
}

- (IBAction)jiaYouBtnClick:(id)sender {
    ALERT_VIEW(@"服务开通中,敬请期待");
    _alert = nil;
}

- (IBAction)xiCheBtnClick:(id)sender {
    self.grayView.hidden = NO;
    self.xiCheView.hidden = NO;
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end



