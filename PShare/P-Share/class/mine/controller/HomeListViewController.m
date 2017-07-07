//
//  HomeListViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/16.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "HomeListViewController.h"
#import "ParkingCell.h"
#import "MJRefresh.h"
#import "ParkingModel.h"
#import "ParkingDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "UIImageView+WebCache.h"

@interface HomeListViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate,CLLocationManagerDelegate,UIActionSheetDelegate>
{
    UIAlertView *_alert;
    
    NSInteger _selectIndexNow;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
    
    float _myLatitude;
    float _myLongitude;
    CLLocationManager *_cllManager;
    
    UIActionSheet *_shareSheet;
    NSInteger _navigationIndex;
}


@property (nonatomic,strong)NSMutableArray *homeDataArray;

@end

@implementation HomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _cllManager = [[CLLocationManager alloc] init];
    _cllManager.distanceFilter = kCLDistanceFilterNone;
    _cllManager.desiredAccuracy = kCLLocationAccuracyBest;
    _cllManager.delegate = self;
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        [_cllManager requestWhenInUseAuthorization];
    }
    [_cllManager startUpdatingLocation];
    
    _shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"苹果自带地图",@"百度地图",@"高德地图", nil];
    
    self.headerView.backgroundColor = MAIN_COLOR;
    self.homeListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    _selectIndexNow = [userDefaultes integerForKey:customer_selectPark];
    
    self.homeDataArray = [NSMutableArray array];
    [self setRefresh];
    
    ALLOC_MBPROGRESSHUD;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [_cllManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    _myLatitude = location.coordinate.latitude;
    _myLongitude = location.coordinate.longitude;
    
    [_cllManager stopUpdatingLocation];
    
    [self.homeListTableView reloadData];
}

- (void)setRefresh
{
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    _mjHeaderView.scrollView = self.homeListTableView;
    _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
    _mjFooterView.scrollView = self.homeListTableView;
    _mjFooterView.delegate = self;
    
    [self downloadDataWithBeginIndex:_curIndex];
}

- (void)dealloc
{
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
    [_mjFooterView free];
    [_mjHeaderView free];
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_isLoading) {
        return;
    }
    if (_mjHeaderView == refreshView) {
        _curIndex = 1;
    }
    if (refreshView == _mjFooterView) {
        _curIndex += 1;
    }
    [self downloadDataWithBeginIndex:_curIndex];
}

- (void)downloadDataWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSString *indexStr = [NSString stringWithFormat:@"%ld",beginIndex];
    NSDictionary *paramDic = @{customer_id:userId,@"pageindex":indexStr,@"index":@1};
    
    NSString *urlString = [GET_PARDERLIST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 if (beginIndex == 1) {
                     [self.homeDataArray removeAllObjects];
                 }
                 NSArray *dictArray = dict[@"datas"][@"parkingList"];
                 if ([dictArray[0] isKindOfClass:[NSDictionary class]]) {
                     for (NSDictionary *tmpDict in dictArray){
                         ParkingModel *model = [[ParkingModel alloc] init];
                         [model setValuesForKeysWithDictionary:tmpDict];
                         [self.homeDataArray addObject:model];
                     }
                 }
                 [self.homeListTableView reloadData];
             }else{
                 if (beginIndex != 1) {
                     ALERT_VIEW(@"已加载完毕");
                     _alert = nil;
                 }
             }
         }
         _isLoading = NO;
         [_mjHeaderView endRefreshing];
         [_mjFooterView endRefreshing];
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"77777777%@",error);
         _isLoading = NO;
         [_mjHeaderView endRefreshing];
         [_mjFooterView endRefreshing];
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
}


#pragma mark --   UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.homeDataArray.count;
  
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"parkingCellId";
    ParkingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ParkingCell" owner:self options:nil]lastObject];
    }
    if (indexPath.row%4 == 0) {
        cell.colorView.backgroundColor = [MyUtil colorWithHexString:@"8957a1"];
    }else if (indexPath.row%4 == 1){
        cell.colorView.backgroundColor = [MyUtil colorWithHexString:@"00b7ee"];
    }else if (indexPath.row%4 == 2){
        cell.colorView.backgroundColor = [MyUtil colorWithHexString:@"1cd8aa"];
    }else if (indexPath.row%4 == 3){
        cell.colorView.backgroundColor = [MyUtil colorWithHexString:@"fac539"];
    }
    
    ParkingModel *model = self.homeDataArray[indexPath.row];
    if (model.canUse == 1) {
        cell.parkIsParkLabel.hidden = YES;
    }else{
        cell.parkIsParkLabel.hidden = NO;
    }
    cell.parkingTitleLabel.text = model.parking_Name;
    if (model.parking_path.length > 10) {
        [cell.parkingImageVIew sd_setImageWithURL:[NSURL URLWithString:model.parking_path] placeholderImage:[UIImage imageNamed:@"parkingDefaultImage"]];
    }
    cell.index = indexPath.row;
    //-----计算距离
    //1.将两个经纬度点转成投影点_mapView.userLocation.coordinate
    MKMapPoint point1 = MKMapPointForCoordinate(CLLocationCoordinate2DMake(_myLatitude, _myLongitude));
    MKMapPoint point2 = MKMapPointForCoordinate(CLLocationCoordinate2DMake([model.parking_Latitude floatValue], [model.parking_Longitude floatValue]));
    //2.计算距离
    CLLocationDistance distance = MKMetersBetweenMapPoints(point1, point2);
    if (distance < 1000) {
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f米",distance];
    }else{
        distance = distance/1000;
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f千米",distance];
    }
    
    if ([model.chargeType isEqualToString:@"1"]) {
        cell.priceLabel.text = [NSString stringWithFormat:@"价格:%.1f元/小时起",model.chargeNormMin];
    }else if([model.chargeType isEqualToString:@"2"]){
        cell.priceLabel.text = [NSString stringWithFormat:@"价格:%@元/次",model.priceTimes];
    }else{
        cell.priceLabel.text = @"价格未知";
    }
    
    cell.gotoNavBlock = ^(NSInteger index){
        _navigationIndex = index;
        [_shareSheet showInView:self.view];
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkingModel *model = self.homeDataArray[indexPath.row];
    ParkingDetailViewController *parkingDetailCtrl = [[ParkingDetailViewController alloc] init];
    parkingDetailCtrl.parkingModel = model;
    parkingDetailCtrl.nowLatitude = _myLatitude;
    parkingDetailCtrl.nowongitude = _myLongitude;
    [self.navigationController pushViewController:parkingDetailCtrl animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求-----删除车辆
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    ParkingModel *model = self.homeDataArray[indexPath.row];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = @{customer_id:userId,parking_id:model.parking_Id};
    
    NSString *urlString = [CANCLE_PARKER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 [self.homeDataArray removeObjectAtIndex:indexPath.row];
                 [self.homeListTableView reloadData];
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
}


#pragma mark -UIActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ParkingModel *model = self.homeDataArray[_navigationIndex];
    
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







