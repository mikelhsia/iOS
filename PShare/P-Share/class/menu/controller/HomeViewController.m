//
//  HomeViewController.m
//  P-Share
//
//  Created by VinceLee on 15/11/18.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "HomeViewController.h"
#import "AllParkingViewController.h"
#import "QuickMarkViewController.h"
#import "ParkAndFavViewController.h"
#import "APService.h"
#import "ParkingDetailViewController.h"
#import "PayHomeViewController.h"
#import "UserViewController.h"
#import <MapKit/MapKit.h>
#import "UIImageView+WebCache.h"

@interface HomeViewController ()<CLLocationManagerDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
{
    UIImageView *_guideImageView;
    UIImageView *_cancelImage;
    UIButton *_guideBtn;
    UIButton *_nilBtn;
    
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    float _myLatitude;
    float _myLongitude;
    CLLocationManager *_cllManager;
    
    UIActionSheet *_shareSheet;
    
    NSInteger current; //当前显示图片
    BOOL isFirst;     //定时器是否是第一次使用
    UIPageControl *pageControl;
}

@property (nonatomic,strong)NSMutableArray *homeArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //添加滚动图片
    self.pictureArray =[[NSMutableArray alloc]initWithArray:@[@"car1.jpg",@"car2.jpg",@"car3.jpg"]];
    [self createScrollView];
    [self createImageViewInPictureScrollView];
    [self createPageControl];
    [self updatePictureScrollView];

    _cllManager = [[CLLocationManager alloc] init];
    _cllManager.distanceFilter = kCLDistanceFilterNone;
    _cllManager.desiredAccuracy = kCLLocationAccuracyBest;
    _cllManager.delegate = self;
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        [_cllManager requestWhenInUseAuthorization];
    }
    [_cllManager startUpdatingLocation];
    
    _shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"苹果自带地图",@"百度地图",@"高德地图", nil];
    
    self.homeArray = [NSMutableArray array];
    ALLOC_MBPROGRESSHUD;
    [self setDufaultUI];
        
    //设置推送标签与别名
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    [APService setTags:[NSSet setWithObject:@"customer"] alias:userId callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    
    [self getMessage];
    [self setGuideImage];
}
#pragma mark - 添加滚动图片效果
- (void)createScrollView{
    self.parkingScrollView.delegate = self;
    self.parkingScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, 0);
    self.parkingScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    self.parkingScrollView.pagingEnabled = YES;
    self.parkingScrollView.bounces = NO;
}
- (void)createImageViewInPictureScrollView{
    current = 0;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH,  220)];
        imageView.tag = 5+i;
        imageView.userInteractionEnabled = YES;
        if (i == 1) {
            imageView.image = [UIImage imageNamed:self.pictureArray[0]];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)]];
        }else if (i == 0){
            imageView.image = [UIImage imageNamed:[self.pictureArray lastObject]];
        }else{
            imageView.image = [UIImage imageNamed:self.pictureArray[1]];
        }
        
        [self.parkingScrollView addSubview:imageView];
    }
}
#pragma mark -- 在轮播图片上面添加了手势方法
- (void)imageViewDidTap {
    if (current == 0) {
        NSLog(@"我是1");
    }else if(current == 1){
        NSLog(@"我是2");
    }else if(current == 2){
         NSLog(@"我是3");
    }
    
}
- (void)createPageControl{
    pageControl = [[UIPageControl alloc] init];
    
    pageControl.center = CGPointMake(_scrollVBgView.frame.size.width/2, 210);
    pageControl.bounds = CGRectMake(0, 0, 200, 80);
    
    pageControl.numberOfPages = self.pictureArray.count;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = MAIN_COLOR;
    pageControl.enabled = NO;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self.scrollVBgView addSubview:pageControl];
}
- (void)updatePictureScrollView{
    isFirst = YES;
    self.myTimer = [[NSTimer alloc]initWithFireDate:[NSDate distantPast] interval:2 target:self selector:@selector(handleShowTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.myTimer forMode:NSDefaultRunLoopMode];
}
-(void)handleShowTimer
{
    if (isFirst == NO) {
        [self.parkingScrollView setContentOffset:CGPointMake(self.parkingScrollView.contentOffset.x + self.view.frame.size.width ,0) animated:YES];
       // NSLog(@"%d",current);
        if (current == 0) {
            
        }else if(current == 1){
            
        }else{
            
        }
    }
    else
    {
        isFirst = NO;
        
    }
   
}

-(void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

#pragma mark --对用户坐标进行定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    _myLatitude = location.coordinate.latitude;
    _myLongitude = location.coordinate.longitude;
    
    [_cllManager stopUpdatingLocation];
}

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
    
    
    self.infoDetailTextView.text = dict[@"datas"][@"message"][@"message"];
    NSString *titleStr = dict[@"datas"][@"message"][@"title"];
    
    NSString *textTitle = @"我是测试 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊语句";
    self.infoTitleLabel.text = textTitle;
    
    
//    self.infoTitleLabel.text = titleStr;

    
    self.infoTitleLabel.marqueeType = MLContinuous;//滚动模式
    self.infoTitleLabel.scrollDuration = 15.0;//滚动时长
    self.infoTitleLabel.animationCurve = UIViewAnimationOptionCurveEaseInOut;//
    self.infoTitleLabel.fadeLength = 30.0f;//首尾间隔
    self.infoTitleLabel.leadingBuffer = 5.0f;//左模糊
    self.infoTitleLabel.trailingBuffer = 5.0f;//右模糊
}

- (void)setDufaultUI
{

    self.infoClearView.hidden = YES;
    UITapGestureRecognizer *tapInfoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearViewTapAction:)];
    [self.infoClearView addGestureRecognizer:tapInfoGesture];
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(clearViewSwipeAction:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.infoClearView addGestureRecognizer:swipeGesture];
    
    self.headerView.backgroundColor = MAIN_COLOR;
    self.infoHeightConstraint.constant = 30;
    self.infoDetailTextView.alpha = 0;
    self.infoDetailTextView.editable = NO;
    self.infoDetailTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.closeInfoBtn.hidden = YES;
    self.upArrowImage.alpha = 0;
    
    self.editingImageView.hidden = YES;
    self.editingBtn.hidden = YES;
    self.parkingNumLabel.text = @"-";
    self.parkingNameLabel.hidden = YES;
    
    //4s以下机型会显示
    self.addLabel.hidden = YES;
    self.nearbyRightImage.hidden = YES;
    self.nearbyOrAddBtn.hidden = YES;
    
    self.imageTopGrayView.alpha = 0;
    UITapGestureRecognizer *tapParkingGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(parkingTapAction:)];
    [self.parkingScrollView addGestureRecognizer:tapParkingGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}

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
         [self loadNoNetUI];
         END_MBPROGRESSHUD;
         ALERT_VIEW(@"网路不可用");
         _alert = nil;
     }];
    //---------------------------网路请求
}
- (void)loadNoNetUI
{
    self.parkingListView.hidden = YES;
    self.grayGrayView.hidden = YES;
    
    self.addBtn.hidden = YES;
    self.editingBtn.hidden = YES;
}
- (void)loadNoDataUI
{
    self.parkingListView.hidden = YES;
    self.grayGrayView.hidden = YES;
    
    self.addLabel.hidden = NO;
    self.addLabel.text = @"请添加停车场";
    self.addBtn.hidden = NO;
    
    self.nearbyLabel.hidden = YES;
    self.nearByParkingView.backgroundColor = BACKGROUND_COLOR;
    self.nearbyRightImage.hidden = YES;
    self.nearbyOrAddBtn.hidden = YES;
    self.nearbyViewConstraint.constant = 40;
    
    self.imageTopGrayView.alpha = 0;
    self.parkingScrollView.userInteractionEnabled = NO;
}

- (void)loadDataForUI
{
    ParkingModel *model = self.homeArray[0];
//    if (model.parking_path.length > 10) {
//        [self.ParkingImageView sd_setImageWithURL:[NSURL URLWithString:model.parking_path] placeholderImage:[UIImage imageNamed:@"homeParkingBackimage"]];
//        self.imageTopGrayView.alpha = 0.45;
//    }else{
//        self.ParkingImageView.image = [UIImage imageNamed:@"homeParkingBackimage"];
//        self.imageTopGrayView.alpha = 0;
//    }
    
    self.nearbyViewConstraint.constant = 30;
    self.parkingScrollView.userInteractionEnabled = YES;
    self.nearbyLabel.hidden = NO;
    self.addLabel.hidden = YES;
    self.nearByParkingView.backgroundColor = [UIColor whiteColor];
    self.editingBtn.hidden = NO;
    self.editingImageView.hidden = NO;
    
    // 70
    NSString *numString = [NSString stringWithFormat:@"%d",model.parking_can_use];
    CGRect numSize = [numString boundingRectWithSize:CGSizeMake(MAXFLOAT, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:_parkingNumLabel.font forKey:NSFontAttributeName] context:nil];
    if (numSize.size.width < SCREEN_WIDTH - 80) {
        self.numLabelWidth.constant = numSize.size.width + 10;
    }else{
        self.numLabelWidth.constant = 100;
    }
    self.parkingNumLabel.text = numString;
    self.addImageView.hidden = YES;
    self.addParkingLabel.hidden = YES;
    self.parkingNameLabel.hidden = NO;
    self.parkingNameLabel.text = model.parking_Name;
    self.addBtn.hidden = YES;
    
    if (SCREEN_HEIGHT < 500) {
        
        self.parkingListView.hidden = YES;
        self.grayGrayView.hidden = YES;
        
        self.addLabel.hidden = NO;
        self.addLabel.text = @"点击查看更多附近停车场";
        self.nearbyLabel.hidden = YES;
        self.nearByParkingView.backgroundColor = BACKGROUND_COLOR;
        self.nearbyViewConstraint.constant = 40;
        self.nearbyRightImage.hidden = NO;
        self.nearbyOrAddBtn.hidden = NO;
        
        return;
    }
    
    if (self.homeArray.count == 1) {
        
        self.parkingListView.hidden = YES;
        self.grayGrayView.hidden = YES;
        
        self.addLabel.hidden = NO;
        self.addLabel.text = @"周边尚无合作停车场,敬请期待!";
        
        self.nearbyLabel.hidden = YES;
        self.nearByParkingView.backgroundColor = BACKGROUND_COLOR;
        
    }else if (self.homeArray.count >= 2) {
        self.grayGrayView.hidden = NO;
        self.parkingListView.hidden = NO;
        
        ParkingModel *listModel = self.homeArray[1];
        if (listModel.parking_path.length > 10) {
            [self.listParkingImage sd_setImageWithURL:[NSURL URLWithString:listModel.parking_path] placeholderImage:[UIImage imageNamed:@"homeParkingBackimage"]];
        }
        self.listParkingTitleLabel.text = listModel.parking_Name;
        
        if ([listModel.chargeType isEqualToString:@"1"]) {
            self.listParkingPriceLabel.text = [NSString stringWithFormat:@"价格:%.1f元/小时起",listModel.chargeNormMin];
        }else if ([listModel.chargeType isEqualToString:@"2"]){
            self.listParkingPriceLabel.text = [NSString stringWithFormat:@"价格:%@元/次",listModel.priceTimes];
        }else{
            self.listParkingPriceLabel.text = @"价格未知";
        }
        
#pragma mark-----计算距离
        //1.将两个经纬度点转成投影点_mapView.userLocation.coordinate
        MKMapPoint point1 = MKMapPointForCoordinate(CLLocationCoordinate2DMake([model.parking_Latitude floatValue], [model.parking_Longitude floatValue]));
        MKMapPoint point2 = MKMapPointForCoordinate(CLLocationCoordinate2DMake([listModel.parking_Latitude floatValue], [listModel.parking_Longitude floatValue]));
#pragma mark--point3 用于计算用户到目标停车场的距离
//        MKMapPoint point3 = MKMapPointForCoordinate(CLLocationCoordinate2DMake(_myLatitude, _myLongitude));
//        CLLocationDistance distance = MKMetersBetweenMapPoints(point2, point3);
        
        //2.计算首页停车场到目标车场的距离
        CLLocationDistance distance = MKMetersBetweenMapPoints(point1, point2);
        

        if (distance < 1000) {
            self.listdistanceLabel.text = [NSString stringWithFormat:@"%.1f米",distance];
        }else{
            distance = distance/1000;
            self.listdistanceLabel.text = [NSString stringWithFormat:@"%.1f千米",distance];
        }
        
        if (listModel.canUse == 2) {
            self.listBoolParkingLabel.hidden = NO;
        }else{
            self.listBoolParkingLabel.hidden = YES;
        }
    }
}

#pragma mark --在clearView上面添加点击的手势 点击跑马灯 clearView发生偏移  在此点击clearView触发本方法  使clearView复原
- (void)clearViewTapAction:(UITapGestureRecognizer *)sender
{
    self.infoHeightConstraint.constant = 30;
    [UIView animateWithDuration:0.3 animations:^{
        self.infoDetailTextView.alpha = 0;
        self.upArrowImage.alpha = 0;
        self.downArrowImage.alpha = 1;
        [self.view layoutIfNeeded];
    }];
    
    self.infoClearView.hidden = YES;
    self.closeInfoBtn.hidden = YES;
}
#pragma mark --在clearView上面添加向上滑动的手势  效果和上面一样
- (void)clearViewSwipeAction:(UISwipeGestureRecognizer *)sender
{
    self.infoHeightConstraint.constant = 30;
    [UIView animateWithDuration:0.3 animations:^{
        self.infoDetailTextView.alpha = 0;
        self.upArrowImage.alpha = 0;
        self.downArrowImage.alpha = 1;
        [self.view layoutIfNeeded];
    }];
    
    self.infoClearView.hidden = YES;
    self.closeInfoBtn.hidden = YES;
}
#pragma mark --点击首页停车场 触发本方法  查看停车场详情
- (void)parkingTapAction:(UITapGestureRecognizer *)sender
{
    if (self.homeArray.count >= 1 ) {
        ParkingDetailViewController *parkingDetailCtl = [[ParkingDetailViewController alloc] init];
        parkingDetailCtl.parkingModel = self.homeArray[0];
        parkingDetailCtl.nowLatitude = _myLatitude;
        parkingDetailCtl.nowongitude = _myLongitude;
        [self.navigationController pushViewController:parkingDetailCtl animated:YES];
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

- (IBAction)nearbyOrAddBtnClick:(id)sender {
    //4s以下机型会用到
    AllParkingViewController *allParkingCtrl = [[AllParkingViewController alloc] init];
    allParkingCtrl.nowLatitude = _myLatitude;
    allParkingCtrl.nowLongitude = _myLongitude;
    if (self.homeArray.count ==2) {
        allParkingCtrl.homeLatitude = [self.homeArray[0] parking_Latitude];
        allParkingCtrl.homeLongitude = [self.homeArray[0] parking_Longitude];
    }
    [self.navigationController pushViewController:allParkingCtrl animated:YES];
}

#pragma mark --查看附近停车场详情
- (IBAction)parkingDetailBtnClick:(id)sender {
    if (self.homeArray.count >= 2) {
        ParkingDetailViewController *parkingDetailCtl = [[ParkingDetailViewController alloc] init];
        parkingDetailCtl.parkingModel = self.homeArray[1];
        parkingDetailCtl.nowLatitude = _myLatitude;
        parkingDetailCtl.nowongitude = _myLongitude;
        [self.navigationController pushViewController:parkingDetailCtl animated:YES];
    }
}

#pragma mark - 首页点击导航时 触发的方法 显示地图选择ActionSheet
- (IBAction)navBtnClick:(id)sender {
    
    if (self.homeArray.count >= 2) {
        [_shareSheet showInView:self.view];
    }
}

#pragma mark -UIActionSheet代理方法(跳转到对应的地图app)
//地图的坐标都是采取高德地图  造成的结果  使用百度 和 苹果 自带的地图 导致线路不精准
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ParkingModel *model = self.homeArray[1];
    
    switch (buttonIndex) {
        case 0:{
            //自带地图导航
            CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(_myLatitude , _myLongitude);
            
            CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake([model.parking_Latitude floatValue], [model.parking_Longitude floatValue]);
            
            MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coord1 addressDictionary:nil]];
            
            currentLocation.name = @"当前位置";
            
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coord2 addressDictionary:nil]];
            
            toLocation.name = model.parking_Name;
            
            NSArray *items = [NSArray arrayWithObjects:currentLocation,toLocation, nil];
            
            NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
            [MKMapItem openMapsWithItems:items launchOptions:options];
        }
            break;
        case 1:{
            //百度地图导航
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
            {
                NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:自己的位置&destination=latlng:%f,%f|name:%@&mode=driving",_myLatitude , _myLongitude,[model.parking_Latitude floatValue], [model.parking_Longitude floatValue], model.parking_Name];
                
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
                NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=wx0112a93a0974d61b&poiname=%@&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=0",@"口袋停",model.parking_Name, [model.parking_Latitude floatValue], [model.parking_Longitude floatValue]];
                
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

#pragma mark --点击查看更多停车场
- (IBAction)moreParkingBtnClick:(id)sender {
    AllParkingViewController *allParkingCtrl = [[AllParkingViewController alloc] init];
    allParkingCtrl.nowLatitude = _myLatitude;
    allParkingCtrl.nowLongitude = _myLongitude;
    
    if (self.homeArray.count ==2) {
//        保存的是首页停车场的坐标
        allParkingCtrl.homeLatitude = [self.homeArray[0] parking_Latitude];
        allParkingCtrl.homeLongitude = [self.homeArray[0] parking_Longitude];
    }
    
    [self.navigationController pushViewController:allParkingCtrl animated:YES];
}

#pragma mark -- 进入个人中心
- (IBAction)mineBtnClick:(id)sender {
    UserViewController *userCtrl = [[UserViewController alloc] init];
    [self.navigationController pushViewController:userCtrl animated:YES];
}

#pragma mark --二维码生成
- (IBAction)homeRightBtnClick:(id)sender {
    QuickMarkViewController *quickMarkCtrl = [[QuickMarkViewController alloc] init];
    [self.navigationController pushViewController:quickMarkCtrl animated:YES];
}

#pragma mark --消息下拉
- (IBAction)getInfoBtnClick:(id)sender {
    
    self.infoClearView.hidden = NO;
    self.closeInfoBtn.hidden = NO;
    
    self.infoHeightConstraint.constant = 96;
    [UIView animateWithDuration:0.3 animations:^{
        self.infoDetailTextView.alpha = 1;
        self.upArrowImage.alpha = 1;
        self.downArrowImage.alpha = 0;
        [self.view layoutIfNeeded];
    }];
}
#pragma mark --消息上拉

- (IBAction)closeInfoBtnClick:(id)sender {
    
    self.infoHeightConstraint.constant = 30;
    [UIView animateWithDuration:0.3 animations:^{
        self.infoDetailTextView.alpha = 0;
        self.upArrowImage.alpha = 0;
        self.downArrowImage.alpha = 1;
        [self.view layoutIfNeeded];
    }];
    
    self.infoClearView.hidden = YES;
    self.closeInfoBtn.hidden = YES;
    
}

#pragma mark --首页停车场设置
- (IBAction)editingBtnClick:(id)sender {
    
    ParkAndFavViewController *parkAndFavCtrl = [[ParkAndFavViewController alloc] init];
    parkAndFavCtrl.nowLatitude = _myLatitude;
    parkAndFavCtrl.nowLongitude =_myLongitude;
    [self.navigationController pushViewController:parkAndFavCtrl animated:YES];
}

#pragma mark --首次登陆添加停车场
- (IBAction)addBtnClick:(id)sender {
    ParkAndFavViewController *parkAndFavCtrl = [[ParkAndFavViewController alloc] init];
    parkAndFavCtrl.nowLatitude = _myLatitude;
    parkAndFavCtrl.nowLongitude =_myLongitude;
    [self.navigationController pushViewController:parkAndFavCtrl animated:YES];
}

#pragma mark --跳转支付界面
- (IBAction)quickPayBtnClick:(id)sender {
    PayHomeViewController *payHomeCtrl = [[PayHomeViewController alloc] init];
    [self.navigationController pushViewController:payHomeCtrl animated:YES];
}

//设置引导页
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

- (void)dealloc
{
    
}
#pragma mark - ParkingScrollView的代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.myTimer invalidate];
    self.myTimer = nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self updatePictureScrollView];
}
//定时器要走的方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    if(self.parkingScrollView.contentOffset.x > self.view.frame.size.width){
        
        if (current == self.pictureArray.count - 1) {
            current = 0;
        }
        else
        {
            current ++;
        }
        
    }
    
    else if (self.parkingScrollView.contentOffset.x < self.view.frame.size.width)
    {
        if(current == 0)
        {
            current = self.pictureArray.count - 1;
        }
        else
        {
            current --;
        }
    }
    
    [scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:NO];
    [self scrollImageView:current];
    pageControl.currentPage = current;
    
    
}
//手动拖拽的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x > self.view.frame.size.width){
        
        if (current == self.pictureArray.count - 1) {
            current = 0;
        }
        else
        {
            current ++;
        }
        
    }
    
    else if (scrollView.contentOffset.x < self.view.frame.size.width)
    {
        if(current == 0)
        {
            current = self.pictureArray.count - 1;
        }
        else
        {
            current --;
        }
    }
    
    [scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:NO];
    [self scrollImageView:current];
    pageControl.currentPage = current;
    
}

-(void)scrollImageView:(NSInteger )index
{
    //提取imageView
    UIImageView *imageView1 = (UIImageView *)[self.parkingScrollView viewWithTag:5];
    UIImageView *imageView2 = (UIImageView *)[self.parkingScrollView viewWithTag:6];
    UIImageView *imageView3 = (UIImageView *)[self.parkingScrollView viewWithTag:7];
    
    
    if (index == self.pictureArray.count - 1) {
        
        imageView2.image = [UIImage imageNamed:self.pictureArray[current]];
        imageView3.image = [UIImage imageNamed:self.pictureArray[0]];
        imageView1.image = [UIImage imageNamed:self.pictureArray[current-1]];
    }
    else if (index == 0)
    {
        
        imageView2.image = [UIImage imageNamed:self.pictureArray[current]];
        imageView3.image = [UIImage imageNamed:self.pictureArray[1+current]];
        imageView1.image = [UIImage imageNamed:self.pictureArray.lastObject];
        
    }
    else {
        
        
        imageView2.image = [UIImage imageNamed:self.pictureArray[current]];
        imageView3.image = [UIImage imageNamed:self.pictureArray[current+1]];
        imageView1.image = [UIImage imageNamed:self.pictureArray [current-1]];
    }
    
    
    
}
@end





