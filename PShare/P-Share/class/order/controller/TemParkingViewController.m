//
//  TemParkingViewController.m
//  P-Share
//
//  Created by VinceLee on 15/12/7.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "TemParkingViewController.h"
#import "ChooseFreeViewController.h"
#import "AddressViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"

@interface TemParkingViewController ()<SelectedParking,UIScrollViewDelegate,ChooseFreeDelegate>
{
    NSString *_payType;
    
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    NSString *_actulOrderPay;
}

@property (nonatomic,strong)NSDictionary *parkInfoDict;

@end

@implementation TemParkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setDefaultUI];
    
    
}

- (void)setDefaultUI
{
    self.headerView.backgroundColor = MAIN_COLOR;
    self.detailView.hidden = YES;
    
    self.searchView1.layer.borderColor = [MyUtil colorWithHexString:@"cccccc"].CGColor;
    self.searchView1.layer.borderWidth = 0.5;
    self.searchView2.layer.borderColor = [MyUtil colorWithHexString:@"cccccc"].CGColor;
    self.searchView2.layer.borderWidth = 0.5;
    self.detailView1.layer.borderColor = [MyUtil colorWithHexString:@"cccccc"].CGColor;
    self.detailView1.layer.borderWidth = 0.5;
    self.detailView2.layer.borderColor = [MyUtil colorWithHexString:@"cccccc"].CGColor;
    self.detailView2.layer.borderWidth = 0.5;
    self.detailView3.layer.borderColor = [MyUtil colorWithHexString:@"cccccc"].CGColor;
    self.detailView3.layer.borderWidth = 0.5;
    
    self.searchBtn.layer.cornerRadius = 2;
    self.surePayBtn.layer.cornerRadius = 4;
    
    _payType = @"0";
    
    self.carNumTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    ALLOC_MBPROGRESSHUD;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.payResultType = @"tempParkGetResult";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRentPayResult:) name:@"tempParkGetResult" object:nil];//监听一个通知
}

- (void)getRentPayResult:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"success"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        ALERT_VIEW(@"支付失败");
        _alert = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getParkBtnClick:(id)sender {
    AddressViewController *addressCtrl = [[AddressViewController alloc] init];
    addressCtrl.homeAddress = @"";
    addressCtrl.homeOrMonthlyRent = @"temPark";
    addressCtrl.delegate = self;
    [self.navigationController pushViewController:addressCtrl animated:YES];
}
- (void)selectedParkingAtHome:(ParkingModel *)model
{
    self.parkingTextField.text = model.parking_Name;
}


- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.carNumTextField resignFirstResponder];
}

- (IBAction)searchBtnClick:(id)sender {
    [self.carNumTextField resignFirstResponder];
    if (self.carNumTextField.text.length >= 6) {
        BEGIN_MBPROGRESSHUD;
        //---------------------------网路请求
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDefaultes objectForKey:customer_id];
        NSDictionary *paramDic = @{customer_id:userId,@"car_number":self.carNumTextField.text};
        
        NSString *urlString = [GETPARKLOTFEE stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if ([result isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = result;
                 
                 if ([dict[@"code"] isEqualToString:@"000000"])
                 {
                     [self setParkInfoWithDict:dict[@"datas"]];
                 }else{
                     ALERT_VIEW(@"该车牌无订单");
                     _alert = nil;
                 }
             }
             END_MBPROGRESSHUD;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             END_MBPROGRESSHUD;
             ALERT_VIEW(@"网络不可用");
             _alert = nil;
         }];
        //---------------------------网路请求
    }else{
        ALERT_VIEW(@"请输入有效车牌号");
        _alert = nil;
    }
}

- (void)setParkInfoWithDict:(NSDictionary *)dict
{
    self.parkInfoDict = dict;
    
    self.detailView.hidden = NO;
    
    self.parkBeginLabel.text = [NSString stringWithFormat:@"进场时间:%@",dict[@"inTime"]];
    self.parkTimeLabel.text = [NSString stringWithFormat:@"结算时间:%@",dict[@"getTimes"]];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计:%@",dict[@"amountPayable"]];
    self.lastPriceLabel.text = [NSString stringWithFormat:@"实付金额:%@",dict[@"amountPayable"]];
    _actulOrderPay = dict[@"amountPayable"];
}

- (IBAction)freePriceBtnClick:(id)sender {
    ChooseFreeViewController *chooseCtrl = [[ChooseFreeViewController alloc] init];
    chooseCtrl.delegate = self;
    chooseCtrl.orderTotalPay = [self.parkInfoDict[@"amountPayable"] intValue];
    [self.navigationController pushViewController:chooseCtrl animated:YES];
}

#pragma mark --使用优惠券时发送网络请求
- (void)selectedFreeWithModel:(DiscountModel *)model
{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求--使用优惠券
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = @{customer_id:userId,@"cdkey":model.coupon_id,@"orderid":self.parkInfoDict[@"order_id"]};
    
    NSString *urlString = [USEXOUPON stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 _actulOrderPay = dict[@"datas"][@"order_total_fee"];
                 self.lastPriceLabel.text = [NSString stringWithFormat:@"实付金额:%@",_actulOrderPay];
                 self.freePriceLabel.text = [NSString stringWithFormat:@"优惠金额:%@",dict[@"datas"][@"coupon_dicount"]];
             }else{
                 
             }
             MyLog(@"------%@",dict);
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         END_MBPROGRESSHUD;
         ALERT_VIEW(@"网络不可用");
         _alert = nil;
     }];
    //---------------------------网路请求
}

- (IBAction)selectWechatBtnClick:(id)sender {
    self.selectWechatImageView.image = [UIImage imageNamed:@"pay_selected"];
    self.selectAlipayImageView.image = [UIImage imageNamed:@"pay_selected_no"];
    _payType = @"wechat";
}

- (IBAction)selectAlipayBtnClick:(id)sender {
    self.selectWechatImageView.image = [UIImage imageNamed:@"pay_selected_no"];
    self.selectAlipayImageView.image = [UIImage imageNamed:@"pay_selected"];
    _payType = @"alipay";
}

- (IBAction)surePayBtnClick:(id)sender {
    
    if ([_payType isEqualToString:@"0"]){
        ALERT_VIEW(@"请选择支付方式");
        _alert = nil;
    }else{
        if ([_payType isEqualToString:@"wechat"]) {
            MyLog(@"微信支付");
            [self payOrderWithWeiXin];
        }else if ([_payType isEqualToString:@"alipay"]){
            MyLog(@"支付宝支付");
            [self payOrderWithZhiFuBao];
        }
        
        BEGIN_MBPROGRESSHUD;
        //---------------------------网路请求
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *paramDic = @{@"order_id":self.parkInfoDict[@"order_id"],@"blueCardOrderId":self.parkInfoDict[@"blueCardOrderId"],@"blueCardParkId":self.parkInfoDict[@"blueCardParkId"]};
        
        NSString *urlString = [PSSTTEMPORARY stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if ([result isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = result;
                 
                 if ([dict[@"code"] isEqualToString:@"000000"])
                 {
                     
                 }else{
                     
                 }
                 MyLog(@"支付调用---不需要查看返回----%@",dict);
             }
             END_MBPROGRESSHUD;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             END_MBPROGRESSHUD;
             ALERT_VIEW(@"网络不可用");
             _alert = nil;
         }];
        //---------------------------网路请求
    }
}

- (void)payOrderWithZhiFuBao
{
    NSURL *url = [NSURL URLWithString:[@"alipay://" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        ALERT_VIEW(@"您未安装支付宝或版本不支持");
        _alert = nil;
        return;
    }
    
    AlipaySDK *alipay = [AlipaySDK defaultService];
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
    order.tradeNO = self.parkInfoDict[@"order_id"]; //订单ID（由商家自行制定）
    order.productName = @"口袋停临停支付"; //商品标题
    order.productDescription = @"口袋停缴费"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[_actulOrderPay floatValue]]; //商品价格
    order.notifyURL =  @"http://www.p-share.com/ShanganParking/payBackTempoOrder.jsp"; //回调URL
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
        
        [alipay payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
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
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }
                    }
                }
            }
        }];
    }
}

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
        app.weiXinNotify_url = @"http://www.p-share.com/ShanganParking/{client_type}/{version}/customer/posttemporaryorderinfoafterpay";
        
        //    1445159356  1445159567  1445159595  1445159612
        //获取到实际调起微信支付的参数后，在app端调起支付
        //    NSMutableDictionary *dict = [req sendPay_dict];
        NSString *priceStr = [NSString stringWithFormat:@"%.0f",[_actulOrderPay floatValue]*100];
        NSMutableDictionary *dict = [req sendPay_dictWithOrder_name:@"口袋停临停支付" order_price:priceStr order_ID:self.parkInfoDict[@"order_id"]];
        
        if(dict == nil){
            //错误提示
            
#pragma mark -- 考虑订单为0元的情况  不可以一直提示订单重复
            ALERT_VIEW(@"订单号重复");
            
            _alert = nil;
        }else{
            //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
            
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


@end








