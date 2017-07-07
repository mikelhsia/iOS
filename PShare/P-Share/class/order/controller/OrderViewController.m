//
//  OrderViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/7.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderCell.h"
#import "OrderDetailViewController.h"
#import "OrderModel.h"
#import "UIImageView+WebCache.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"
#import "JZAlbumViewController.h"

@interface OrderViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    int _currentState;
    
    NSString *_payTape;
    
    UIAlertView *_alert;
    
    NSInteger _currentSelectIndex;
    
    NSString *_orderID;
    
    NSTimer *_myTimer;
    NSTimer *_timeCountTimer;
    BOOL   _haveCount;
    
    //当前订单——模型
    OrderModel *_currentOrderModel;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
}

@property (nonatomic,strong)NSMutableArray *imageArray;


@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ALLOC_MBPROGRESSHUD;
    
    [self setUI];
    
    _orderID = @"";
    _currentState = -1;//--------------------------------------------
    _currentOrderModel = [[OrderModel alloc] init];
    
    self.imageArray = [NSMutableArray array];
    
    [self cheakOrderState];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

//设置默认界面
- (void)setUI
{
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    
    //-----支付相关
    self.grayBackView.hidden = YES;
    self.payBackView.hidden = YES;
    self.gotoPayBtn.layer.cornerRadius = 3;
    self.gotoPayBtn.layer.masksToBounds = YES;
    self.gotoPayBtn.backgroundColor = MAIN_COLOR;
    _payTape = @"0";
    //---------
    
    self.headerView.backgroundColor = MAIN_COLOR;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.view1SureBtn.layer.cornerRadius = 4;
    self.view1SureBtn.layer.masksToBounds = YES;
    self.view1SureBtn.backgroundColor = MAIN_COLOR;
    self.view1Label1.textColor = MAIN_COLOR;
    self.view1Label2.textColor = MAIN_COLOR;
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"orderManImage1"],[UIImage imageNamed:@"orderManImage2"],[UIImage imageNamed:@"orderManImage3"],[UIImage imageNamed:@"orderManImage4"],nil];
    _aniImageView.animationImages = array; //动画图片数组
    _aniImageView.animationDuration = 2.0; //执行一次完整动画所需的时长
    _aniImageView.animationRepeatCount = 0;  //动画重复次数 0表示无限次，默认为0
//    [_aniImageView startAnimating];
    _aniImageView.hidden = YES;
    
    self.view2SureBtn.layer.cornerRadius = 4;
    self.view2SureBtn.layer.masksToBounds = YES;
    self.view2SureBtn.backgroundColor = MAIN_COLOR;
    self.parkerHeaderImageView.layer.cornerRadius = 47;
    self.parkerHeaderImageView.layer.masksToBounds = YES;
    
    self.view3SureBtn.layer.cornerRadius = 4;
    self.view3SureBtn.layer.masksToBounds = YES;
    self.view3SureBtn.backgroundColor = MAIN_COLOR;
    self.parkerHeaderImageView2.layer.cornerRadius = 47;
    self.parkerHeaderImageView2.layer.masksToBounds = YES;
    
    self.view2View.hidden = YES;
    self.view3View.hidden = YES;
    self.cancelView.hidden = YES;
    self.view1Label2.hidden = YES;
    
    //------评论相关
    self.reasonTextView.delegate = self;
    self.reasonTextView.layer.cornerRadius = 4;
    self.reasonTextView.layer.masksToBounds = YES;
    self.reasonTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.reasonTextView.layer.borderWidth = 1;
    self.commentBackView.hidden = YES;
    self.sureBtn.layer.cornerRadius = 2;
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.backgroundColor = MAIN_COLOR;
    self.commentBackView.layer.cornerRadius = 4;
    self.commentBackView.layer.masksToBounds = YES;
    //------
}

- (void)cheakOrderState
{
    //    没有开始计算停车时长————没有开定时器,让其具备开启的条件
    _haveCount = YES;
    
    _myTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(refreshMyOrder) userInfo:nil repeats:YES];
    
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
                 int state;
                 if ([dict[@"datas"][@"orderInfo"] count] == 0) {
                     state = 0;
                 }else{
                     NSNumber *num = dict[@"datas"][@"orderInfo"][0][@"order_state"];
                     state = [num intValue];
                     _orderID = dict[@"datas"][@"orderInfo"][0][@"order_id"];
                     [_currentOrderModel setValuesForKeysWithDictionary:dict[@"datas"][@"orderInfo"][0]];
                     if (state == 1 || state == 2 || state == 3) {
                         //设置定时器，查看订单状态,被接单后关闭定时器
                         [[NSRunLoop  currentRunLoop] addTimer:_myTimer forMode:NSDefaultRunLoopMode];
                     }
                 }
                 
                 [self changeOrderStateWithState:state];
             }else{
                 MyLog(@"%@",dict[@"msg"]);
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"%@",error);
     }];
    //---------------------------网路请求
}

- (void)dealloc
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_myTimer invalidate];
    _myTimer = nil;
    
    [_timeCountTimer invalidate];
    _timeCountTimer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.payResultType = @"orderGetResult";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"orderGetResult" object:nil];//监听一个通知
}

//获取微信支付结果 通知
- (void)getOrderPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"])
    {
        self.view1View.hidden = NO;
        self.view1Label1.text = @"您未预约";
        self.view1Label2.hidden = YES;
        self.cancelView.hidden = YES;
        _aniImageView.hidden = YES;
        [_aniImageView stopAnimating];
        self.view2View.hidden = YES;
        self.view3View.hidden = YES;
        
        self.payBackView.hidden = YES;
        self.grayBackView.hidden = YES;
        
        [_myTimer invalidate];
        _myTimer = nil;
        
        [_timeCountTimer invalidate];
        _timeCountTimer = nil;
        
        //调用评论
        [self performSelector:@selector(commentComment:) withObject:nil afterDelay:1.0f];
    }
    else
    {
        ALERT_VIEW(@"支付失败");
        _alert = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//定时器刷新，判断订单状态
- (void)refreshMyOrder
{
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
                     [_currentOrderModel setValuesForKeysWithDictionary:dict[@"datas"][@"orderInfo"][0]];
                     [self changeOrderStateWithState:[stateNum intValue]];
                 }else
                 {
                     [self changeOrderStateWithState:0];
                     [_myTimer invalidate];
                     _myTimer = nil;
                 }
             }else{
                 MyLog(@"3333333%@",dict[@"msg"]);
                 [self changeOrderStateWithState:0];
                 [_myTimer invalidate];
                 _myTimer = nil;
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"333333请求失败");
     }];
    //---------------------------网路请求
    MyLog(@"order----2");
}

//查看代泊员上传图片
- (void)setCarImage
{
    self.carPictureScrollView.showsHorizontalScrollIndicator = NO;
    
    NSInteger imageWidth_H = ((SCREEN_WIDTH-45*2)-15*2)/3;
    NSInteger image_Y = (self.carPictureScrollView.frame.size.height - imageWidth_H)/2;
    
    NSArray *subviewsArray = self.carPictureScrollView.subviews;
    for (UIImageView *imageView in subviewsArray){
        [imageView removeFromSuperview];
    }
    
    for (int i=0; i<self.imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((imageWidth_H+15)*i, image_Y, imageWidth_H, imageWidth_H)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[i]]];
        imageView.tag = i + 10;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)];
        [imageView addGestureRecognizer:tapGesture];
        [self.carPictureScrollView addSubview:imageView];
    }
    
    NSInteger content_W = self.imageArray.count * imageWidth_H + (self.imageArray.count-1)*15;
    self.carPictureScrollView.contentSize = CGSizeMake(content_W, self.carPictureScrollView.frame.size.height);
}

//点击图片放大
- (void)tapImageAction:(UITapGestureRecognizer *)sender
{
    JZAlbumViewController *jzAlbumCtrl = [[JZAlbumViewController alloc] init];
    jzAlbumCtrl.imgArr = self.imageArray;
    jzAlbumCtrl.currentIndex = sender.view.tag-10;
    [self presentViewController:jzAlbumCtrl animated:YES completion:nil];
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


//根据订单状态显示调整UI
- (void)changeOrderStateWithState:(int)state
{
    if (state == 3 || state == 4 || state == 8 || state == 9){
        
        if (state == 3) {
            self.view3SureBtn.hidden = YES;
        }else{
            self.view3SureBtn.hidden = NO;
            
            [_myTimer invalidate];
            _myTimer = nil;
        }
        
        if (state == 8 || state == 9) {
            [self.view3SureBtn setTitle:@"支付订单" forState:UIControlStateNormal];
        }else{
            [self.view3SureBtn setTitle:@"我要取车" forState:UIControlStateNormal];
        }
        
        self.view1View.hidden = YES;
        self.view2View.hidden = YES;
        self.view3View.hidden = NO;
        
        if (_currentOrderModel.parking_img_count.length > 5) {
            [self.parkerHeaderImageView2 sd_setImageWithURL:[NSURL URLWithString:_currentOrderModel.parking_img_count]];
        }
        self.parkerNameLabel2.text = _currentOrderModel.parker_name;
        self.parkerTitleLabel2.text = [NSString stringWithFormat:@"职务:%@",_currentOrderModel.parker_level];
        self.parkerChargeLabel2.text = [NSString stringWithFormat:@"负责区域:%@",_currentOrderModel.parking_Name];//待调整
        self.parkerPhoneNumLabel2.text = _currentOrderModel.parker_mobile;
        self.orderTimeLabel2.text = _currentOrderModel.order_Plan_begin;
        self.getCarTimeLabel.text = _currentOrderModel.order_plan_end;
        self.carNumLabel.text = _currentOrderModel.car_Number;
        
        if (_haveCount) {
            _timeCountTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCountRefresh) userInfo:nil repeats:YES];
            //不重复开启定时器
            _haveCount = NO;
        }
        
        [self.imageArray removeAllObjects];
        NSArray *modelImages = [_currentOrderModel.order_path componentsSeparatedByString:@","];
        [self.imageArray addObjectsFromArray:modelImages];
        [self.imageArray removeObject:@""];
        if (_currentOrderModel.parking_path.length > 5) {
            NSString *imageString = [_currentOrderModel.parking_path substringToIndex:[_currentOrderModel.parking_path length]-1];
            [self.imageArray addObject:imageString];
        }
        [self setCarImage];
    }else
    {
        [_timeCountTimer invalidate];
        _timeCountTimer = nil;
        _haveCount = YES;//关闭定时器，并让其具备开启的条件
        
        if (state == 0) {
            self.view1View.hidden = NO;
            self.view1Label1.text = @"您未预约";
            self.view1Label2.hidden = YES;
            self.cancelView.hidden = YES;
            _aniImageView.hidden = YES;
            [_aniImageView stopAnimating];
            self.view2View.hidden = YES;
            self.view3View.hidden = YES;
            
        }else if (state == 1){
            self.view1View.hidden = NO;
            self.view1Label1.text = @"请您稍等片刻";
            self.view1Label2.hidden = NO;
            self.cancelView.hidden = NO;
            _aniImageView.hidden = NO;
            [_aniImageView startAnimating];
            self.view2View.hidden = YES;
            self.view3View.hidden = YES;
            
        }else if (state == 2){
            self.view1View.hidden = YES;
            self.view2View.hidden = NO;
            self.view3View.hidden = YES;
            
            if (_currentOrderModel.parking_img_count.length > 5) {
                [self.parkerHeaderImageView sd_setImageWithURL:[NSURL URLWithString:_currentOrderModel.parking_img_count]];
            }
            self.parkerNameLabel.text = _currentOrderModel.parker_name;
            self.parkerTitleLabel.text = [NSString stringWithFormat:@"职务:%@",_currentOrderModel.parker_level];
            self.parkerChargeLabel.text = [NSString stringWithFormat:@"负责区域:%@",_currentOrderModel.parking_Name];//待调整
            self.parkerPhoneNumLabel.text = _currentOrderModel.parker_mobile;
            self.orderTimeLabel.text = _currentOrderModel.order_Plan_begin;
            
        }
    }
    
    if (state != 1) {
        [_aniImageView stopAnimating];
    }
}
#pragma mark -停车计时刷新
- (void)timeCountRefresh
{
    NSDate *nowdate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *orderBeginDate = [formatter dateFromString:_currentOrderModel.order_actual_begin_start];
    NSInteger nowInterval = (NSInteger)[nowdate timeIntervalSinceDate:orderBeginDate];
    
    self.parkingCarTimeLabel.text = [NSString stringWithFormat:@"%ld小时%ld分钟%ld秒",nowInterval/3600,(nowInterval%3600)/60,nowInterval%60];
    
    MyLog(@"order---1");
}

//取消预约
- (IBAction)view1SureBtnClick:(id)sender {
    MyLog(@"取消预约1");
    if (_orderID.length != 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认取消" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        alertView = nil;
    }
}
//取消预约
- (IBAction)view2SureBtnClick:(id)sender {
    MyLog(@"取消预约2");
    if (_orderID.length != 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认取消" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        alertView = nil;
    }
}

#pragma mark -UIAlertViewd代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self cancelOrder];
    }
}

//取消订单
- (void)cancelOrder
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
                 self.view1View.hidden = NO;
                 self.view1Label1.text = @"您未预约";
                 self.view1Label2.hidden = YES;
                 self.cancelView.hidden = YES;
                 _aniImageView.hidden = YES;
                 [_aniImageView stopAnimating];
                 self.view2View.hidden = YES;
                 self.view3View.hidden = YES;
                 MyLog(@"取消成功1111111");
                 
                 [_myTimer invalidate];
                 _myTimer = nil;
             }else{
                 MyLog(@"%@",dict[@"msg"]);
             }
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"1111111%@",error);
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
}

//拨打电话
- (IBAction)view2CallBtnClick:(id)sender {
    MyLog(@"拨打电话");
    if (self.parkerPhoneNumLabel.text.length != 0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.parkerPhoneNumLabel.text];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}
//拨打电话
- (IBAction)view3callBtnClick:(id)sender {
    if (self.parkerPhoneNumLabel2.text.length != 0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.parkerPhoneNumLabel2.text];
        //            NSLog(@"str======%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark -取车/付款
- (IBAction)view3SureBtnClick:(UIButton *)sender {
    if ([_view3SureBtn.titleLabel.text isEqualToString:@"我要取车"]) {

        BEGIN_MBPROGRESSHUD;
        //---------------------------网路
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *paramDic = @{order_id:_orderID,parking_id:_currentOrderModel.parking_Id};
        
        NSString *urlString = [GET_CAR stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if ([result isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = result;
                 
                 if ([dict[@"code"] isEqualToString:@"000000"])
                 {
                     [_view3SureBtn setTitle:@"支付订单" forState:UIControlStateNormal];
                     ALERT_VIEW(@"已为您告知代泊员");
                     _alert = nil;
                 }else{
                     MyLog(@"%@",dict[@"msg"]);
                 }
             }
             END_MBPROGRESSHUD;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             MyLog(@"1111111%@",error);
             END_MBPROGRESSHUD;
         }];
        //---------------------------网路请求

    }else{
        BEGIN_MBPROGRESSHUD;
        //---------------------------网路
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *paramDic = @{order_id:_orderID,parking_id:_currentOrderModel.parking_Id};
        
        NSString *urlString = [CALCULATE_PAY stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if ([result isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = result;
                 
                 if ([dict[@"code"] isEqualToString:@"000000"])
                 {
                     self.payMoneyCountLabel.text = dict[@"datas"][@"totalPay"];
                     
                     self.grayBackView.hidden = NO;
                     self.payBackView.hidden = NO;
                     _payTape = @"0";
                     self.zhiFuBaoImageView.image = [UIImage imageNamed:@"shape-18-copy"];
                     self.weiXinImageView.image = [UIImage imageNamed:@"shape-18-copy"];
                 }else{
                     MyLog(@"%@",dict[@"msg"]);
                 }
             }
             END_MBPROGRESSHUD;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             MyLog(@"1111111%@",error);
             END_MBPROGRESSHUD;
         }];
        //---------------------------网路请求
    }
}


//左右切换查看图片
- (IBAction)leftBtnClick:(id)sender {
    NSInteger imageWidth_H = ((SCREEN_WIDTH-45*2)-15*2)/3;
    
    CGPoint pictureContentSet = self.carPictureScrollView.contentOffset;
    if (self.carPictureScrollView.contentOffset.x < imageWidth_H+15) {
        pictureContentSet.x = 0;
    }else{
        pictureContentSet.x -= imageWidth_H+15;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.carPictureScrollView.contentOffset = pictureContentSet;
    }];
}
//左右切换查看图片
- (IBAction)rightBtnClick:(id)sender {
    NSInteger imageWidth_H = ((SCREEN_WIDTH-45*2)-15*2)/3;
    
    CGPoint pictureContentSet = self.carPictureScrollView.contentOffset;
    if (self.imageArray.count >= 4) {
        if (self.carPictureScrollView.contentOffset.x > (imageWidth_H+15)*(self.imageArray.count-4)) {
            pictureContentSet.x = (imageWidth_H+15)*(self.imageArray.count-3);
        }else{
            pictureContentSet.x += imageWidth_H+15;
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.carPictureScrollView.contentOffset = pictureContentSet;
    }];
}

//取消订单支付
- (IBAction)cancelPayBtnClick:(id)sender {
    self.grayBackView.hidden = YES;
    self.payBackView.hidden = YES;
}

//使用支付宝支付
- (IBAction)selectZhiFuBaoBtnClick:(id)sender {
    _payTape = @"1";
    self.zhiFuBaoImageView.image = [UIImage imageNamed:@"shape-18-copy_s"];
    self.weiXinImageView.image = [UIImage imageNamed:@"shape-18-copy"];
}
//使用微信支付
- (IBAction)selectWeiXinBtnClick:(id)sender {
    _payTape = @"2";
    self.zhiFuBaoImageView.image = [UIImage imageNamed:@"shape-18-copy"];
    self.weiXinImageView.image = [UIImage imageNamed:@"shape-18-copy_s"];
}

//支付宝支付
- (void)payOrderWithZhiFuBao
{
    NSURL *url = [NSURL URLWithString:[@"alipay://" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        ALERT_VIEW(@"您未安装支付宝或版本不支持");
        _alert = nil;
        return;
    }
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    /*=======================需要填写商户app申请的===================================*/
    NSString *partner = @"2088021550883080";
    NSString *seller = @"zhifu@forwell-parking.com";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKMLgUUYUTqwDOWaEg3ZqZ9A5UBjP8KO+xdpTmc1zv1c5EpMXVdXD7P6OuKHHNUAhu4gICEiB7+bLDSkro9gLcl99vyzblbTXBI1iSlPSq3mKfP8SVh1ZGZh1FDIMDX7KCju8jEKU1oUtiZkIJaGKlH+fYigQhPf+yPaOGEOm17vAgMBAAECgYBIZBFPRk66ifQP9WpSr/O5+6xN/EMQ9T7S1DS1apSutZG+000WPFeCh3Whom/Qut0t2SGq1FswXYsxDHVcv01UVYNrsmOf/bszI04cG3LVVoxPdF6g+oNMvNLBlYznpo4VLmMUDnN63YsgH1QRg8FIB01pU+KGa/knnUB1yEMEsQJBANSICl5IxpsspRb0xUYKDVQErfpeOK5dC0A1UddQvkhuNg7J5nWhuKjucGd3vYpzZFVt0lLZ69ScYhfu7rJluQ0CQQDEZGVpBKxy20Ig8bA6vaxLiX+lIrJ2fZ+T21z4PcCemWYkF5bPQahPPW3brvsn2u5b7TyQV50fNEjR7cgUhIDrAkEAndbq3FrwJQ5jDUl7uSh9/Yf8LZUMQ3KWiHkQ7vfoWaKAQztvDK2ulsd+c1laSxiny0pkiWOO4bfCokOwwo0JgQJBALX4IE6yWecCab+Esbl7zY0gFfm4sItB0v55HyeUcEmD8TQ39zCKsZzaWlRXSbegD4N1ycwkoh0roN2C6QS50YkCQBIFFvVQeEy9tUfvX6eG+d+xhjUIaUOY/E4Oo3vi4fy0Vsbtx2AAJlgk8RhWEyS2fsXZ8h/HD0yAIjs5EDDlLnc=";
    /*============================================================================*/
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = _currentOrderModel.order_Id;
    order.productName = @"口袋停-停车支付"; //商品标题
    order.productDescription = @"停车缴费"; //商品描述
    order.amount = [NSString stringWithFormat:@"%@",self.payMoneyCountLabel.text]; //商品价格
    order.notifyURL =  @"http://www.p-share.com/ShanganParking/notify_url.jsp"; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"wx0112a93a0974d61b";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                MyLog(@"--支付宝-支付失败--%@",resultDic[@"memo"]);
                ALERT_VIEW(@"支付取消");
                _alert = nil;
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]){
                
                NSArray *resultStringArray =[resultDic[@"result"]componentsSeparatedByString:@"&"];
                for (NSString *str in resultStringArray)
                {//             success=\"true\"
                    NSString *newstring = nil;
                    newstring = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    NSArray *strArray = [newstring componentsSeparatedByString:NSLocalizedString(@"=", nil)];
                    for (int i = 0 ; i < [strArray count] ; i++)
                    {
                        NSString *st = [strArray objectAtIndex:i];
                        if ([st isEqualToString:@"success"])
                        {
                            if ([[strArray objectAtIndex:1] isEqualToString:@"true"]) {
                                MyLog(@"----支付宝支付成功-");
                                
                                self.view1View.hidden = NO;
                                self.view1Label1.text = @"您未预约";
                                self.view1Label2.hidden = YES;
                                self.cancelView.hidden = YES;
                                _aniImageView.hidden = YES;
                                [_aniImageView stopAnimating];
                                self.view2View.hidden = YES;
                                self.view3View.hidden = YES;
                                
                                self.payBackView.hidden = YES;
                                self.grayBackView.hidden = YES;
                                
                                [_myTimer invalidate];
                                _myTimer = nil;
                                
                                [_timeCountTimer invalidate];
                                _timeCountTimer = nil;
                                
                                //调用评论
                                [self performSelector:@selector(commentComment:) withObject:nil afterDelay:1.0f];
                            }
                        }
                    }
                }
            }
        }];
    }
}

//微信支付
- (void)payOrderWithWeiXin
{
    if ([WXApi isWXAppInstalled]) {
        //创建支付签名对象
        payRequsestHandler *req = [payRequsestHandler alloc];
        //初始化支付签名对象
        [req init:APP_ID mch_id:MCH_ID];
        //设置密钥
        [req setKey:PARTNER_ID];
        
        //配置微信回调URL
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        app.weiXinNotify_url = @"http://www.p-share.com/ShanganParking/{client_type}/{version}/customer/payOrder";
        //    1445159356  1445159567  1445159595  1445159612
        //获取到实际调起微信支付的参数后，在app端调起支付
        //    NSMutableDictionary *dict = [req sendPay_dict];
        NSString *priceStr = [NSString stringWithFormat:@"%.0f",[self.payMoneyCountLabel.text floatValue]*100];
        NSMutableDictionary *dict = [req sendPay_dictWithOrder_name:@"口袋停-停车支付" order_price:priceStr order_ID:_currentOrderModel.order_Id];
        
        if(dict == nil){
            //错误提示
            ALERT_VIEW(@"下单失败");
            _alert = nil;
        }else{            
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            
            [WXApi sendReq:req];
        }
    }else{
        ALERT_VIEW(@"您未安装微信或版本不支持");
        _alert = nil;
    }
}

//点击订单支付按钮
- (IBAction)gotoPayBtnClick:(id)sender {
    
    if ([_payTape isEqualToString:@"0"]) {
        ALERT_VIEW(@"请选择支付方式");
        _alert = nil;
        return;
    }else if ([_payTape isEqualToString:@"1"]){
        MyLog(@"支付宝付款");
        [self payOrderWithZhiFuBao];
        
    }else if ([_payTape isEqualToString:@"2"]){
        MyLog(@"微信付款");
        [self payOrderWithWeiXin];
    }
}

//点击评论按钮
- (void)commentComment:(id)sender
{
    //进行评论
    self.grayBackView.hidden = NO;
    self.commentBackView.hidden = NO;
    self.reasonTextView.text = @" 说说你的理由吧";
}

//评价选图片点击
- (IBAction)commentBtnClick:(UIButton *)sender {
    if (_currentSelectIndex == sender.tag - 2000) {
        return;
    }else{
        UIImageView *selectImageView = (UIImageView *)[self.view viewWithTag:sender.tag - 1000];
        selectImageView.image = [UIImage imageNamed:@"patients_evaluationchoose_hg"];
        
        UIImageView *lastImageView = (UIImageView *)[self.view viewWithTag:_currentSelectIndex + 1000];
        lastImageView.image = [UIImage imageNamed:@"patients_evaluationchoose"];
    }
    
    _currentSelectIndex = sender.tag - 2000;
}

//评论确定按钮点击
- (IBAction)sureBtnClick:(id)sender {
    [self.reasonTextView resignFirstResponder];
    
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路----订单评价
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSString *levelStr = [NSString stringWithFormat:@"%ld",_currentSelectIndex];
    NSDictionary *paramDic = @{order_id:_orderID,comment_level:levelStr,comment_content:self.reasonTextView.text,customer_id:userId};
    
    NSString *urlString = [ORDER_COMMENT stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 ALERT_VIEW(@"评论成功");
                 _alert = nil;
             }else{
                 MyLog(@"%@",dict[@"msg"]);
             }
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"1111111%@",error);
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
    
    self.grayBackView.hidden = YES;
    self.commentBackView.hidden = YES;
}

#pragma mark --UITextView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@" 说说你的理由吧"]) {
        textView.text = @"";
    }
    self.reasonTextView.textColor = [UIColor blackColor];
    
    self.commentCenterY.constant = 50;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @" 说说你的理由吧";
        self.reasonTextView.textColor = [UIColor lightGrayColor];
    }
    self.commentCenterY.constant = 0;
}


@end




