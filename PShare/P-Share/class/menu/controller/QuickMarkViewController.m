//
//  QuickMarkViewController.m
//  P-Share
//
//  Created by VinceLee on 15/11/20.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "QuickMarkViewController.h"
#import "QRCodeGenerator.h"

@interface QuickMarkViewController ()

@end

@implementation QuickMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headerView.backgroundColor = MAIN_COLOR;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *phoneNume = [userDefault objectForKey:customer_mobile];
    NSString *userId = [userDefault objectForKey:customer_id];
    NSString *codeString = [NSString stringWithFormat:@"customer:%@ %@",userId,phoneNume];
    /*字符转二维码
     导入 libqrencode文件
     引入头文件#import "QRCodeGenerator.h" 即可使用
     */

    self.quickMarkImageView.image = [QRCodeGenerator qrImageForString:codeString imageSize:self.quickMarkImageView.bounds.size.width];
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

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
