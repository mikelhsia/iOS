//
//  NewHomeViewController.m
//  P-Share
//
//  Created by fay on 15/12/29.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "NewHomeViewController.h"
#import "UserViewController.h"
#import "LBXScanViewStyle.h"
#import "LBXScanViewController.h"
#import "ParkingModel.h"
#import "ParkingDetailViewController.h"
#import "ParkAndFavViewController.h"
#import "PayHomeViewController.h"
#import "MenuViewController.h"
#import "APService.h"
#import "CarStewardViewController.h"
#import <MapKit/MapKit.h>
#import "NewMapViewController.h"


@interface NewHomeViewController ()<CLLocationManagerDelegate,UIScrollViewDelegate>
{
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    UIAlertView *_alert;

    
    
    UIImageView *_guideImageView;
    UIImageView *_cancelImage;
    UIButton *_guideBtn;
    UIButton *_nilBtn;
    
//  用来记录公司／家庭 哪一个btn被选中
    UIButton *_temBtn;
    
    float _myLatitude;
    float _myLongitude;
    CLLocationManager *_cllManager;
}
@property (nonatomic,retain)NSMutableArray *homeArray;


@end

@implementation NewHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homeArray = [NSMutableArray array];
    
    [self LoadUI];
    _cllManager = [[CLLocationManager alloc] init];
    _cllManager.distanceFilter = kCLDistanceFilterNone;
    _cllManager.desiredAccuracy = kCLLocationAccuracyBest;
    _cllManager.delegate = self;
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        [_cllManager requestWhenInUseAuthorization];
    }
    [_cllManager startUpdatingLocation];
    
    //设置推送标签与别名
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    [APService setTags:[NSSet setWithObject:@"customer"] alias:userId callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    
//    初始化MBProgressHUD
    ALLOC_MBPROGRESSHUD;
    
    [self getMessage];
    [self setGuideImage];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
    
}


- (void)loadDataForUI
{
    _AddParkView.hidden = YES;
    _showParkView.hidden = NO;
    [self changeParkViewWithParkingModel:[_homeArray objectAtIndex:_temBtn.tag]];
    
}
- (void)loadNoDataUI
{
    _AddParkView.hidden = NO;
    _showParkView.hidden = YES;
}

- (void)LoadUI
{
    _gongSiBtn.layer.borderColor = MAIN_COLOR.CGColor;
    _gongSiBtn.layer.borderWidth = 1;
    _homeBtn.layer.borderColor = MAIN_COLOR.CGColor;
    _homeBtn.layer.borderWidth = 1;
    _showParkView.hidden = YES;
    
    _parkBgImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPark:)];
    [_parkBgImage addGestureRecognizer:tapGesture];
    
    NSArray *imageArray = [NSArray arrayWithObjects:@"home",@"office", nil];
    _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 250);
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.bounces = NO;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.delegate  =self;
    
    for (int i=0; i<2; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, 250)];
        imgView.userInteractionEnabled = YES;
        imgView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPark:)];
        [imgView addGestureRecognizer:tapGesture];

        [_bgScrollView addSubview:imgView];
        
    }
    
    
    CGRect rect = [_shengYuCheWeiNum.text boundingRectWithSize:CGSizeMake(1000, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:75]} context:nil];
    _shengYuCheWeiWidth.constant = rect.size.width;
    
}

#pragma mark  -- scrollView代理事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger num = scrollView.contentOffset.x/SCREEN_WIDTH;
    NSLog(@"%ld",num);
    if (num == 0) {
        [self chooseBtnClick:_homeBtn];
    }
    else if (num ==1 ){
        [self chooseBtnClick:_gongSiBtn];
        
    }
    
}

-(void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
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
#pragma mark -- 家庭＊＊公司btnClick
- (IBAction)chooseBtnClick:(UIButton *)sender {
    
    if(sender.tag == 0)
    {
        _temBtn = sender;
//        家庭
        _homeBtn.backgroundColor = MAIN_COLOR;
        [_homeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _gongSiBtn.backgroundColor = [UIColor whiteColor];
        [_gongSiBtn setTitleColor:MAIN_COLOR forState:(UIControlStateNormal)];
        _parkBgImage.image = [UIImage imageNamed:@"home"];
        
        [self changeParkViewWithParkingModel:[_homeArray objectAtIndex:0]];
        

    }
    else
    {
//        公司
        _temBtn = sender;
        _gongSiBtn.backgroundColor = MAIN_COLOR;
        [_gongSiBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _homeBtn.backgroundColor = [UIColor whiteColor];
        [_homeBtn setTitleColor:MAIN_COLOR forState:(UIControlStateNormal)];
        _parkBgImage.image = [UIImage imageNamed:@"office"];
        [self changeParkViewWithParkingModel:[_homeArray objectAtIndex:1]];

    }
    [_bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*sender.tag, 0) animated:YES];
}
#pragma mark --改变停车场界面
- (void)changeParkViewWithParkingModel:(ParkingModel*)ParkingModel
{
    _shengYuCheWeiNum.text = [NSString stringWithFormat:@"%d",ParkingModel.parking_count];
    _parkName.text = ParkingModel.parking_Name;
    
    
}


#pragma mark -- 编辑停车场
- (IBAction)editFirstViewPark:(UIButton *)sender {
    ParkAndFavViewController *parkAndFavCtrl = [[ParkAndFavViewController alloc] init];
    parkAndFavCtrl.nowLatitude = _myLatitude;
    parkAndFavCtrl.nowLongitude =_myLongitude;
    [self.navigationController pushViewController:parkAndFavCtrl animated:YES];
    
}
#pragma mark -- 添加停车场 或者展示停车场详情
- (IBAction)addPark:(UIButton *)sender {
    
    if (_homeArray.count == 0) {
        ParkAndFavViewController *parkAndFavCtrl = [[ParkAndFavViewController alloc] init];
        parkAndFavCtrl.nowLatitude = _myLatitude;
        parkAndFavCtrl.nowLongitude =_myLongitude;
        [self.navigationController pushViewController:parkAndFavCtrl animated:YES];
    }
    else
    {
        ParkingDetailViewController *parkingDetailCtrl = [[ParkingDetailViewController alloc] init];
        parkingDetailCtrl.parkingModel = [_homeArray objectAtIndex:_temBtn.tag];
        parkingDetailCtrl.nowLatitude = _myLatitude;
        parkingDetailCtrl.nowongitude = _myLongitude;
        [self.navigationController pushViewController:parkingDetailCtrl animated:YES];
    }
    
}

#pragma mark --对用户坐标进行定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    _myLatitude = location.coordinate.latitude;
    _myLongitude = location.coordinate.longitude;
    
    [_cllManager stopUpdatingLocation];
}

#pragma mark --二维码扫描
- (IBAction)erWeiMaSearch:(UIButton *)sender {
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
#pragma mark -- 前往个人中心
- (IBAction)goToPersonCenter:(UIButton *)sender {
    UserViewController *userCtrl = [[UserViewController alloc] init];
    [self.navigationController pushViewController:userCtrl animated:YES];
}
#pragma mark -- 前往支付中心
- (IBAction)goToPayViewC:(id)sender {
    PayHomeViewController *payHomeCtrl = [[PayHomeViewController alloc] init];
    [self.navigationController pushViewController:payHomeCtrl animated:YES];
}

#pragma mark -- 下方三个btn点击事件
- (IBAction)chooseServerBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
//            找个车位 NewMapViewController
            MenuViewController *menuCtrl = [[MenuViewController alloc] init];
            [self.navigationController pushViewController:menuCtrl animated:YES];
//            NewMapViewController *menuCtrl = [[NewMapViewController alloc] init];
//            [self.navigationController pushViewController:menuCtrl animated:YES];
        }
            break;
            
        case 1:
        {
//            我要代泊
        }
            break;
            
        case 2:
        {
//            呼个管家
            CarStewardViewController *carStewaardCtrl = [[CarStewardViewController alloc] init];
            [self.navigationController pushViewController:carStewaardCtrl animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark --加载data
- (void)loadData
{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = @{customer_id:userId};
    
    NSString *urlString = [INDEXSHOW stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 NSLog(@"%@",dict);
                 NSArray *dictArray = dict[@"datas"][@"parkingList"];
                 if ([dictArray[0] isKindOfClass:[NSDictionary class]]) {
                     [self.homeArray removeAllObjects];
                     
                     for (NSDictionary *tmpDict in dictArray){
                         ParkingModel *model = [[ParkingModel alloc] init];
                         [model setValuesForKeysWithDictionary:tmpDict];
                         [self.homeArray addObject:model];
                     }
                     [self loadDataForUI];
                 }
             }else{
                 [self loadNoDataUI];
             }
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self loadNoNetUI];
         END_MBPROGRESSHUD;
         ALERT_VIEW(@"网路不可用");
         _alert = nil;
     }];
    //---------------------------网路请求
}


#pragma mark --获取Message
- (void)getMessage
{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *urlString = [INDMESSAGE stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 [self setMessageInfoWith:dict];
             }else{
                 
             }
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"77777777%@",error);
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
}

#pragma mark -- 显示服务器返回的信息
- (void)setMessageInfoWith:(NSDictionary *)dict
{
    
//    NSString *titleStr = dict[@"datas"][@"message"][@"title"];
    
    NSString *textTitle = @"我是测****＊＊＊＊＊＊＊＊＊＊＊＊****试语句";
    self.infoTitleLabel.text = textTitle;
    
    
    //    self.infoTitleLabel.text = titleStr;
    CGRect rect = [self.infoTitleLabel.text boundingRectWithSize:CGSizeMake(500, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    if (rect.size.width > SCREEN_WIDTH - 60) {
        self.infoTitleLabel.marqueeType = MLContinuous;//滚动模式
        self.infoTitleLabel.scrollDuration = 15.0;//滚动时长
        self.infoTitleLabel.animationCurve = UIViewAnimationOptionCurveEaseInOut;//
        self.infoTitleLabel.fadeLength = 30.0f;//首尾间隔
        self.infoTitleLabel.leadingBuffer = 5.0f;//左模糊
        self.infoTitleLabel.trailingBuffer = 5.0f;//右模糊
    }
}

#pragma mark --设置引导页
- (void)setGuideImage
{
    NSFileManager *manager=[NSFileManager defaultManager];
    //判断 我是否创建了文件，如果没创建 就创建这个文件
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    if (![manager fileExistsAtPath:[path stringByAppendingPathComponent:@"b.txt"]]){
        
        _guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _guideImageView.image = [UIImage imageNamed:@"guide_helpImage"];
        [self.view addSubview:_guideImageView];
        
        _cancelImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, SCREEN_HEIGHT-60, 30, 30)];
        _cancelImage.image = [UIImage imageNamed:@"guideImage_cancel"];
        [self.view addSubview:_cancelImage];
        
        _nilBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _nilBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view addSubview:_nilBtn];
        
        _guideBtn = [MyUtil createBtnFrame:CGRectMake(0, 0, 50, 50) title:nil bgImageName:nil target:self action:@selector(cancelGuideImage)];
        _guideBtn.center = _cancelImage.center;
        [self.view addSubview:_guideBtn];
        
        //第一次运行后创建文件，以后就不再运行
        [manager createFileAtPath:[path stringByAppendingPathComponent:@"b.txt"] contents:nil attributes:nil];
    }
}

- (void)cancelGuideImage
{
    _guideImageView.hidden = YES;
    _guideImageView = nil;
    _cancelImage.hidden = YES;
    _cancelImage = nil;
    _guideBtn.hidden = YES;
    _guideBtn = nil;
    _nilBtn.hidden = YES;
    _nilBtn = nil;
}



@end
