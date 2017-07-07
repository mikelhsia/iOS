//
//  HavePayViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/16.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "HavePayViewController.h"
#import "AddRentCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"

@interface HavePayViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *footerView;
    
    UILabel *_payCountLabel;

    NSString *_payTape;
    
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
}
@end

@implementation HavePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.havePayTableView.backgroundColor = BACKGROUND_COLOR;
    self.headerView.backgroundColor = MAIN_COLOR;
    self.havePayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //-----支付相关
    self.grayBackView.hidden = YES;
    self.payBackView.hidden = YES;
    self.gotoPayBtn.layer.cornerRadius = 3;
    self.gotoPayBtn.layer.masksToBounds = YES;
    self.gotoPayBtn.backgroundColor = MAIN_COLOR;
    //---------
    
    if ([self.comeType isEqualToString:@"pay"]) {
        [self createTableViewFooterView_pay];
    }else if ([self.comeType isEqualToString:@"havePay"]){
        [self createTableViewFooterView];
    }
    
    ALLOC_MBPROGRESSHUD;
}

//支付的 footerView
- (void)createTableViewFooterView_pay
{
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
    footerView.backgroundColor = BACKGROUND_COLOR;
    
    //支付金额
    _payCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 10, 80, 20)];
    _payCountLabel.text = [NSString stringWithFormat:@"%@元",self.addRentModel.amount];;
    _payCountLabel.textColor = [UIColor redColor];
    _payCountLabel.font = [UIFont systemFontOfSize:15];
    [footerView addSubview:_payCountLabel];
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 10, 40, 20)];
    moneyLabel.text = @"金额:";
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.font = [UIFont systemFontOfSize:15];
    [footerView addSubview:moneyLabel];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake(15, 50, SCREEN_WIDTH - 30, 43);
    [sureBtn setTitle:@"支 付" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:MAIN_COLOR];
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    [footerView addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteBtn.frame = CGRectMake(15, 113, SCREEN_WIDTH - 30, 43);
    [deleteBtn setTitle:@"删除此条" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn setBackgroundColor:[MyUtil colorWithHexString:@"#fa524e"]];
    deleteBtn.layer.cornerRadius = 4;
    deleteBtn.layer.masksToBounds = YES;
    [footerView addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.havePayTableView.tableFooterView = footerView;
}

- (void)createTableViewFooterView
{
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    footerView.backgroundColor = BACKGROUND_COLOR;
    
    //支付金额
    _payCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 10, 80, 20)];
    _payCountLabel.text = [NSString stringWithFormat:@"%@元",self.addRentModel.amount];;
    _payCountLabel.textColor = [UIColor redColor];
    _payCountLabel.font = [UIFont systemFontOfSize:15];
    [footerView addSubview:_payCountLabel];
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 10, 40, 20)];
    moneyLabel.text = @"金额:";
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.font = [UIFont systemFontOfSize:15];
    [footerView addSubview:moneyLabel];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake(15, 50, SCREEN_WIDTH - 30, 43);
    [sureBtn setTitle:@"已支付" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:[UIColor lightGrayColor]];
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    [footerView addSubview:sureBtn];
    
    self.havePayTableView.tableFooterView = footerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.payResultType = @"havePayGetResult";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRentPayResult:) name:@"havePayGetResult" object:nil];//监听一个通知
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

//支付按钮点击
- (void)payBtnClick:(UIButton *)btn
{
    self.grayBackView.hidden = NO;
    self.payBackView.hidden = NO;
    _payTape = @"0";
    self.payMoneyCountLabel.text = [NSString stringWithFormat:@"%@元",self.addRentModel.amount];
    self.zhiFuBaoImageView.image = [UIImage imageNamed:@"shape-18-copy"];
    self.weiXinImageView.image = [UIImage imageNamed:@"shape-18-copy"];
}

//删除按钮点击
- (void)deleteBtnClick:(UIButton *)btn
{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *paramDic = @{@"id":self.addRentModel.ID};
    
    NSString *urlString = [DEL_RENT_ORDER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)cancelPayBtnClick:(id)sender {
    self.grayBackView.hidden = YES;
    self.payBackView.hidden = YES;
}

- (IBAction)selectZhiFuBaoBtnClick:(id)sender {
    _payTape = @"1";
    self.zhiFuBaoImageView.image = [UIImage imageNamed:@"shape-18-copy_s"];
    self.weiXinImageView.image = [UIImage imageNamed:@"shape-18-copy"];
}

- (IBAction)selectWeiXinBtnClick:(id)sender {
    _payTape = @"2";
    self.zhiFuBaoImageView.image = [UIImage imageNamed:@"shape-18-copy"];
    self.weiXinImageView.image = [UIImage imageNamed:@"shape-18-copy_s"];
}

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
    order.tradeNO = self.addRentModel.ID; //订单ID（由商家自行制定）
    order.productName = @"口袋停-产权/月租支付"; //商品标题
    order.productDescription = @"口袋停缴费"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[self.addRentModel.amount floatValue]]; //商品价格
    order.notifyURL =  @"http://www.p-share.com/ShanganParking/payBackOrder.jsp"; //回调URL
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
        app.weiXinNotify_url = @"http://www.p-share.com/ShanganParking/{client_type}/{version}/customer/payAmount";
        
        //    1445159356  1445159567  1445159595  1445159612
        //获取到实际调起微信支付的参数后，在app端调起支付
        //    NSMutableDictionary *dict = [req sendPay_dict];
        NSString *priceStr = [NSString stringWithFormat:@"%.0f",[self.addRentModel.amount floatValue]*100];
        NSMutableDictionary *dict = [req sendPay_dictWithOrder_name:@"口袋停-产权/月租支付" order_price:priceStr order_ID:self.addRentModel.ID];
        
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"addRentCellId";
    AddRentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddRentCell" owner:self options:nil]lastObject];
    }
    switch (indexPath.row) {
            case 0:
            cell.leftLabel.text = @"缴费类型:";
            if ([self.addRentModel.orderType isEqualToString:@"0"]) {
                cell.rightTextField.text = @"产权";
            }else if ([self.addRentModel.orderType isEqualToString:@"1"]){
                cell.rightTextField.text = @"月租";
            }
            break;
        case 1:
            cell.leftLabel.text = @"小区:";
            cell.rightTextField.text = self.addRentModel.villageName;
            break;
        case 2:
            cell.leftLabel.text = @"车牌:";
            cell.rightTextField.text = self.addRentModel.carNumber;
            break;
        case 3:{
            cell.leftLabel.text = @"缴费月份:";
            //时间数据源   @"yyyy-MM-dd HH:mm:ss"
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy/MM/dd";
            NSDate *date = [formatter dateFromString:self.addRentModel.validityStartTime];
            
            //获取当前年份
            formatter.dateFormat = @"yyyy";
            NSString *yearStr= [formatter stringFromDate:date];
            formatter.dateFormat = @"MM";
            NSString *monStr = [formatter stringFromDate:date];
            cell.rightTextField.text = [NSString stringWithFormat:@"%@年 %@月",yearStr,monStr];
        }
            break;
        case 4:
            cell.leftLabel.text = @"姓名:";
            cell.rightTextField.text = self.addRentModel.customerName;
            break;
        case 5:
            cell.leftLabel.text = @"单价:";
            cell.rightTextField.text = [NSString stringWithFormat:@"%@元",self.addRentModel.price];
            break;
            
        default:
            break;
    }
    cell.rightImageView.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
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
