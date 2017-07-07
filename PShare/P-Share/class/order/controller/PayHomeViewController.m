//
//  PayHomeViewController.m
//  P-Share
//
//  Created by VinceLee on 15/11/24.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "PayHomeViewController.h"
#import "OrderViewController.h"
#import "TemParkingViewController.h"

#import "LBXScanViewStyle.h"
#import "LBXScanViewController.h"

@interface PayHomeViewController ()

@end

@implementation PayHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setDefaultUI];
    
}

- (void)setDefaultUI
{
    self.headerView.backgroundColor = MAIN_COLOR;
    
    self.tipImageView.hidden = YES;
    self.tipLabel.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //---------------------------网路请求-----查看订单状态
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = @{customer_id:userId};
    
    NSString *urlString = [STATE_FOR_ORDER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 if ([dict[@"datas"][@"orderInfo"] count] == 0) {
                     //当orderInfo里面不存在订单信息时，tipLabel继续隐藏
                     self.tipLabel.hidden = YES;
                     self.tipImageView.hidden = YES;
                 }else{

                     self.tipLabel.hidden = NO;
                     self.tipImageView.hidden = NO;
                 }
             }else{
                 MyLog(@"%@",dict[@"msg"]);
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"%@",error);
     }];
    //---------------------------网路请求
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

- (IBAction)blueBtnClick:(id)sender {
    OrderViewController *orderCtrl = [[OrderViewController alloc] init];
    [self.navigationController pushViewController:orderCtrl animated:YES];
}

- (IBAction)greenBtnClick:(id)sender {
    TemParkingViewController *temParkingCtrl = [[TemParkingViewController alloc] init];
    [self.navigationController pushViewController:temParkingCtrl animated:YES];
}

- (IBAction)yellowBtnClick:(id)sender {
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    
    style.alpa_notRecoginitonArea = 0.6;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    
    
    style.animationImage = imgFullNet;
    
    LBXScanViewController *vc = [LBXScanViewController new];
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end




