//
//  ParkingDetailViewController.m
//  P-Share
//
//  Created by VinceLee on 15/11/23.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "ParkingDetailViewController.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "CarStewardViewController.h"
#import "UIImageView+WebCache.h"
#import <MapKit/MapKit.h>
#import "DetailModel.h"

@interface ParkingDetailViewController ()<UIActionSheetDelegate>
{
    NSString *_orderID;
    
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    BOOL _haveOrder;
    
    NSTimer *_myTimer;
    NSTimer *_timeCountTimer;
    NSInteger _timeCount;
    
    UIActionSheet *_shareSheet;
    
    BOOL _haveFavorite;
}
@end

@implementation ParkingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"苹果自带地图",@"百度地图",@"高德地图", nil];
    _haveFavorite = NO;
    
    [self setDefaultUI];
    
    [self downloadData];
    
    [self loadData];
}

- (void)downloadData
{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求-----
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = @{customer_id:userId,parking_id:self.parkingModel.parking_Id};
    
    NSString *urlString = [PARKINGDETAIL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 DetailModel *model = [[DetailModel alloc] init];
                 [model setValuesForKeysWithDictionary:dict[@"datas"][@"message"]];
                 
                 [self setDataWithModel:model];
             }else{
                 MyLog(@"%@",dict[@"msg"]);
             }
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"%@",error);
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
}

- (void)setDataWithModel:(DetailModel *)model
{
    if ([model.isCollection intValue] == 1) {
        self.favoriteImageView.image = [UIImage imageNamed:@"favoriteParking_select"];
        self.favoriteLalbel.text = @"已收藏";
        _haveFavorite = YES;
    }else{
        self.favoriteImageView.image = [UIImage imageNamed:@"favoriteParking"];
        self.favoriteLalbel.text = @"收藏";
        _haveFavorite = NO;
    }
    
    if ([model.defaultScan intValue] == 1) {
        self.setHomeLabel.text = @"已设为首页";
    }
    
    if ([self.parkingModel.chargeType isEqualToString:@"1"]) {
        if (model.chargeNorms.count != 0) {
            NSMutableArray *parkingStartTimeArray = [NSMutableArray array];
            NSMutableArray *parkingEndTimeArray = [NSMutableArray array];
            NSMutableArray *priceArray = [NSMutableArray array];
            
            for (NSDictionary *tmpDict in model.chargeNorms){
                [parkingStartTimeArray addObject:tmpDict[@"parkingStartTime"]];
                [parkingEndTimeArray addObject:tmpDict[@"parkingEndTime"]];
                [priceArray addObject:tmpDict[@"priceHour"]];
            }
            NSMutableString *priceStr;
            if (parkingStartTimeArray.count != 0 && priceArray.count != 0) {
                priceStr = [NSMutableString stringWithFormat:@"停车价格:%@-%@时(含):%@元/小时",parkingStartTimeArray[0],parkingEndTimeArray[0],priceArray[0]];
                if (priceArray.count > 1) {
                    for (int i=1; i<priceArray.count; i++) {
                        [priceStr appendFormat:@"  ;  %@-%@时(含):%@元/小时",parkingStartTimeArray[i],parkingEndTimeArray[i],priceArray[i]];
                    }
                }
            }
            self.parkingPriceLabel.text = priceStr;
        }else{
            self.parkingPriceLabel.text = @"价格未知";
        }
    }else if ([self.parkingModel.chargeType isEqualToString:@"2"]){
        self.parkingPriceLabel.text = [NSString stringWithFormat:@"停车价格:%@元/次",self.parkingModel.priceTimes];
    }else{
        self.parkingPriceLabel.text = @"价格未知";
    }
}

- (void)setDefaultUI
{
    ALLOC_MBPROGRESSHUD;
    
    _haveOrder = NO;
    _timeCount = 180;
    
    self.headerView.backgroundColor = MAIN_COLOR;
    
    self.grayView.hidden = YES;
    self.shareView.backgroundColor = [MyUtil colorWithHexString:@"#e2e2e2"];
    self.shareView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerView:)];
    [self.grayView addGestureRecognizer:tap];
    
    self.parkingBtn.layer.cornerRadius = 4;
    self.parkingBtn.layer.masksToBounds = YES;
    
    self.beginOrderLabel.hidden = YES;
    self.myActivityIndicatorView.hidden = YES;
    self.myActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.timeCountLabel.hidden = YES;
}
- (void)hidePickerView:(UITapGestureRecognizer *)sender
{
    self.grayView.hidden = YES;
    self.shareView.hidden = YES;
}

- (void)loadData
{
    //------------显示网络数据
    if (self.parkingModel.parking_path.length > 10) {
        [self.parkingImageView sd_setImageWithURL:[NSURL URLWithString:self.parkingModel.parking_path] placeholderImage:[UIImage imageNamed:@"homeParkingBackimage"]];
    }
    self.parkingImageView.contentMode = UIViewContentModeScaleToFill;
    
    self.parikingNameLabel.text = self.parkingModel.parking_Name;
    self.parkingAdressLabel.text = self.parkingModel.parking_address;
    self.parkingNumLabel.text = [NSString stringWithFormat:@"剩余车位数:%d",self.parkingModel.parking_can_use];
    
    if (self.parkingModel.canUse == 1) {
        self.parkingCanUseLabel.hidden = YES;
        self.parkingBtn.hidden = YES;
        self.lineView.hidden = YES;
        self.daiboLeading.constant = 0;
    }else
    {
        self.parkingDaiBoLabel.text = @"代泊服务每次加收10元服务费";
        self.parkingDaiBoLabel.backgroundColor = [UIColor whiteColor];
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

#pragma mark -- 点击收藏时触发
- (IBAction)favoriteBtnClick:(id)sender {
    
    if (_haveFavorite) {
        BEGIN_MBPROGRESSHUD;
        

        //---------------------------网路请求-----删除收藏
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDefaultes objectForKey:customer_id];
        NSDictionary *paramDic = @{customer_id:userId,parking_id:self.parkingModel.parking_Id};
        
        NSString *urlString = [CANCLE_PARKER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if ([result isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = result;
                 
                 if ([dict[@"code"] isEqualToString:@"000000"])
                 {
                     self.favoriteImageView.image = [UIImage imageNamed:@"favoriteParking"];
                     self.favoriteLalbel.text = @"收藏";
                     _haveFavorite = NO;
                 }else{
                     MyLog(@"%@",dict[@"msg"]);
                 }
                 MyLog(@"%@",dict);
             }
             END_MBPROGRESSHUD;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             MyLog(@"%@",error);
             END_MBPROGRESSHUD;
         }];
        //---------------------------网路请求
    }else{
        BEGIN_MBPROGRESSHUD;
        //---------------------------网路请求-----
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDefaultes objectForKey:customer_id];
        NSDictionary *paramDic = @{customer_id:userId,parking_id:self.parkingModel.parking_Id};
        
        NSString *urlString = [SAVE_PARKER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if ([result isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = result;
                 
                 if ([dict[@"code"] isEqualToString:@"000000"])
                 {
                     self.favoriteImageView.image = [UIImage imageNamed:@"favoriteParking_select"];
                     self.favoriteLalbel.text = @"已收藏";
                     _haveFavorite = YES;
                 }else{
//                     ALERT_VIEW(dict[@"msg"]);
//                     _alert = nil;
                 }
             }
             END_MBPROGRESSHUD;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             MyLog(@"%@",error);
             END_MBPROGRESSHUD;
         }];
        //---------------------------网路请求
    }
}

#pragma mark -- 点击导航时触发
- (IBAction)navBtnClick:(id)sender {
    [_shareSheet showInView:self.view];
}

#pragma mark -UIActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            //自带地图导航
            CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(self.nowLatitude , self.nowongitude);
            
            CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake([self.parkingModel.parking_Latitude floatValue], [self.parkingModel.parking_Longitude floatValue]);
            
            MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coord1 addressDictionary:nil]];
            
            currentLocation.name = @"当前位置";
            
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coord2 addressDictionary:nil]];
            
            toLocation.name = self.parkingModel.parking_Name;
            
            NSArray *items = [NSArray arrayWithObjects:currentLocation,toLocation, nil];
            
            NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
            [MKMapItem openMapsWithItems:items launchOptions:options];
        }
            break;
        case 1:{
            //百度地图导航
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
            {
                NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:自己的位置&destination=latlng:%f,%f|name:%@&mode=driving",self.nowLatitude , self.nowongitude,[self.parkingModel.parking_Latitude floatValue], [self.parkingModel.parking_Longitude floatValue], self.parkingModel.parking_Name];
                
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }else{
                ALERT_VIEW( @"您未安装百度地图或版本不支持");
                _alert = nil;
            }
        }
            break;
        case 2:{
            //高德地图导航  067c1d2281fc7f9141e3725058c9e240
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
                NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=wx0112a93a0974d61b&poiname=%@&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=0",@"口袋停",self.parkingModel.parking_Name, [self.parkingModel.parking_Latitude floatValue], [self.parkingModel.parking_Longitude floatValue]];
                
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }else{
                ALERT_VIEW( @"您未安装高德地图或版本不支持");
                _alert = nil;
            }
        }
            break;
        default:
            break;
    }
    
}

- (IBAction)shareBtnClick:(id)sender {
    
    self.grayView.hidden = NO;
    self.shareView.hidden = NO;
}


#pragma mark -- 设为首页停车场
- (IBAction)setHomeBtnClick:(id)sender {
    
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = @{customer_id:userId,parking_id:self.parkingModel.parking_Id};
    
    NSString *urlString = [SETDEFAULTSCAN stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 self.setHomeLabel.text = @"已设为首页";
             }else{
                 ALERT_VIEW(dict[@"msg"]);
                 _alert = nil;
             }
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"77777777%@",error);
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
}

#pragma mark -- 点击车管家
- (IBAction)carStewardBtnClick:(id)sender {
    CarStewardViewController *carStewaardCtrl = [[CarStewardViewController alloc] init];
    [self.navigationController pushViewController:carStewaardCtrl animated:YES];
}

#pragma mark -- 代泊时触发
- (IBAction)parkingBtnClick:(id)sender {
    
    if (_haveOrder) {
        [self cancelOrderBtnClick];
    }else{
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *timeString= [dateFormatter stringFromDate:date];
        
        BEGIN_MBPROGRESSHUD;
        //---------------------------网路请求---查看订单状态
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
                         [self createOrderWithTime:timeString];
                         MyLog(@"开始下单---------");
                     }else{
                         ALERT_VIEW(@"您有未完成订单，请及时处理!");
                         _alert = nil;
                         END_MBPROGRESSHUD;
                     }
                 }else{
                     MyLog(@"3333333%@",dict[@"msg"]);
                     END_MBPROGRESSHUD;
                 }
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             MyLog(@"333333请求失败");
             END_MBPROGRESSHUD;
         }];
        //---------------------------网路请求
    }
}

//发起预约
- (void)createOrderWithTime:(NSString *)timeStr
{
    _myTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(refreshOrder) userInfo:nil repeats:YES];
    _timeCountTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(refreshTimeCount) userInfo:nil repeats:YES];
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求-----发起预约
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    
    NSDictionary *paramDic = @{parking_id:self.parkingModel.parking_Id,customer_id:userId,order_plan_begin:timeStr,order_img_count:@"0"};
    
    NSString *urlString = [CREATE_ORDER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 self.beginOrderLabel.hidden = NO;
                 self.myActivityIndicatorView.hidden = NO;
                 [self.myActivityIndicatorView startAnimating];
                 
                 _haveOrder = YES;
                 [self.parkingBtn setTitle:@"取 消 代 泊" forState:UIControlStateNormal];
                 
                 _orderID = dict[@"datas"][@"orderInfo"][@"order_id"];
                 MyLog(@"下单成功---------");
                 
                 //设置定时器，查看订单状态,被接单后关闭定时器
                 NSRunLoop *loop = [NSRunLoop currentRunLoop];
                 [loop addTimer:_myTimer forMode:NSDefaultRunLoopMode];
                 [loop addTimer:_timeCountTimer forMode:NSDefaultRunLoopMode];
             }else{
                 ALERT_VIEW(@"代泊失败");
                 _alert = nil;
             }
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"222222请求失败");
         ALERT_VIEW(@"代泊失败");
         _alert = nil;
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
}

#pragma mark -停车等待倒计时
- (void)refreshTimeCount
{
    self.timeCountLabel.hidden = NO;
    if (_timeCount%60 < 10) {
        self.timeCountLabel.text = [NSString stringWithFormat:@"等待倒计时0%ld:0%ld",_timeCount/60,_timeCount%60];
    }else{
        self.timeCountLabel.text = [NSString stringWithFormat:@"等待倒计时0%ld:%ld",_timeCount/60,_timeCount%60];
    }
    _timeCount--;
    
    if (_timeCount == 0) {
        self.timeCountLabel.hidden = YES;
        _timeCount = 180;
        [_timeCountTimer invalidate];
        _timeCountTimer = nil;
        [self cancleOrder];
    }
    
    MyLog(@"detail----2");
}

//取消预约
- (void)cancelOrderBtnClick
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认取消" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 12;
    [alertView show];
    alertView = nil;
}

//刷新订单状态
- (void)refreshOrder
{
    __block UIAlertView *orderAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已被接单,可去订单查看详情" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    orderAlertView.tag = 21;
    __block UIAlertView *cancelAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"代泊员繁忙无法接单,请谅解" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    //---------------------------网路请求---查看订单状态
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
                 NSNumber *stateNum;
                 if ([dict[@"datas"][@"orderInfo"] count] != 0) {
                     stateNum = dict[@"datas"][@"orderInfo"][0][@"order_state"];
                     
                     if ([stateNum intValue] != 1) {
                         
                         [orderAlertView show];
                         orderAlertView = nil;
                         
                         self.beginOrderLabel.hidden = YES;
                         self.myActivityIndicatorView.hidden = YES;
                         [self.myActivityIndicatorView stopAnimating];
                         
                         [_myTimer invalidate];
                         _myTimer = nil;
                         self.timeCountLabel.hidden = YES;
                         _timeCount = 180;
                         [_timeCountTimer invalidate];
                         _timeCountTimer = nil;
                     }
                 }else{
                     
                     [cancelAlertView show];
                     cancelAlertView = nil;
                     
                     _haveOrder = NO;
                     [self.parkingBtn setTitle:@"立 即 代 泊" forState:UIControlStateNormal];
                     
                     self.beginOrderLabel.hidden = YES;
                     self.myActivityIndicatorView.hidden = YES;
                     [self.myActivityIndicatorView stopAnimating];
                     
                     [_myTimer invalidate];
                     _myTimer = nil;
                     self.timeCountLabel.hidden = YES;
                     _timeCount = 180;
                     [_timeCountTimer invalidate];
                     _timeCountTimer = nil;
                 }
                 
             }else{
                 MyLog(@"3333333%@",dict[@"msg"]);
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"333333请求失败");
     }];
    //---------------------------网路请求
    
    MyLog(@"detail----1");
}

#pragma mark -UIAlertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 21) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (alertView.tag == 12){
        if (buttonIndex == 1) {
            [self cancleOrder];
        }
    }
}

- (void)cancleOrder
{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求----取消订单
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *paramDic = @{order_id:_orderID};
    
    NSString *urlString = [CANCEL_ORDER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 _haveOrder = NO;
                 [self.parkingBtn setTitle:@"立 即 代 泊" forState:UIControlStateNormal];
                 
                 self.beginOrderLabel.hidden = YES;
                 self.myActivityIndicatorView.hidden = YES;
                 [self.myActivityIndicatorView stopAnimating];
                 
                 [_myTimer invalidate];
                 _myTimer = nil;
                 self.timeCountLabel.hidden = YES;
                 _timeCount = 180;
                 [_timeCountTimer invalidate];
                 _timeCountTimer = nil;
             }else{
                 MyLog(@"111111111%@",dict[@"msg"]);
             }
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"1111111请求失败");
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
}

//微信会话分享
- (IBAction)weiXinShareBtnClick:(id)sender {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = [NSString stringWithFormat:@"%@还有%d个停车位,赶紧下载<口袋停APP https://itunes.apple.com/cn/app/kou-dai-ting/id1049233050?mt=8>预约车位,让你从此停车不烦恼！",self.parkingModel.parking_Name,self.parkingModel.parking_can_use];
        req.bText = YES;
        req.scene = WXSceneSession; //选择发送到朋友圈WXSceneTimeline，默认值为WXSceneSession发送到会话
        [WXApi sendReq:req];
    }else{
        ALERT_VIEW( @"您未安装微信或版本不支持");
        _alert = nil;
    }
}
//微信朋友圈分享
- (IBAction)pengYouShareBtnClick:(id)sender {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = [NSString stringWithFormat:@"%@还有%d个停车位,赶紧下载<口袋停APP https://itunes.apple.com/cn/app/kou-dai-ting/id1049233050?mt=8>预约车位,让你从此停车不烦恼！",self.parkingModel.parking_Name,self.parkingModel.parking_can_use];
        req.bText = YES;
        req.scene = WXSceneTimeline; //选择发送到朋友圈WXSceneTimeline，默认值为WXSceneSession发送到会话
        [WXApi sendReq:req];
    }else{
        ALERT_VIEW( @"您未安装微信或版本不支持");
        _alert = nil;
    }
}
//微博分享
- (IBAction)weiboShareBtnClick:(id)sender {
    if ([WeiboSDK isCanShareInWeiboAPP]) {
        //新浪分享
        WBMessageObject *message = [WBMessageObject message];
        message.text = [NSString stringWithFormat:@"%@还有%d个停车位,赶紧下载<口袋停APP https://itunes.apple.com/cn/app/kou-dai-ting/id1049233050?mt=8>预约车位,让你从此停车不烦恼！",self.parkingModel.parking_Name,self.parkingModel.parking_can_use];
        
        WBSendMessageToWeiboRequest *wbRequest = [WBSendMessageToWeiboRequest requestWithMessage:message];
        wbRequest.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
        [WeiboSDK sendRequest:wbRequest];
    }else{
        ALERT_VIEW( @"您未安装新浪微博或版本不支持");
        _alert = nil;
    }
}

- (IBAction)backBtnClick:(id)sender {
    [_myTimer invalidate];
    _myTimer = nil;
    
    self.timeCountLabel.hidden = YES;
    _timeCount = 180;
    
    [_timeCountTimer invalidate];
    _timeCountTimer = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    
}
@end





