//
//  MenuViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/5.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "MenuViewController.h"
#import "UIView+PSBTransitionAnimation.h"
#import "HomeListViewController.h"
#import "SearchCell.h"
#import "DBManager.h"
#import "SearchModel.h"
#import <MAMapKit/MAMapKit.h>
#import "CustomAnnotationView.h"
#import "ParkingModel.h"
#import "MyPointAnnotation.h"
#import "ParkingDetailViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <MapKit/MapKit.h>

@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate,MAMapViewDelegate,MyAnnotationViewTapDelegate,UITextFieldDelegate,UIScrollViewDelegate,AMapSearchDelegate,UIActionSheetDelegate>
{
    MAMapView *_mapView;
    
    float _nowLatitude;  //当前经度
    float _nowLongitude;   //当前纬度
    
    float _dragLatitude;  //拖动后的经度
    float _dragLongitude;   //拖动后的纬度
    
    int _myParkID;
    
    ParkingModel *_selectModel;
    
    BOOL _isEditing;
    
    UIAlertView *_alert;
    
    AMapSearchAPI *_mapSearch;
    AMapInputTipsSearchRequest *_tipsRequest;
    
    int _navigationIndex;
}

@property (nonatomic,strong) NSMutableArray *searchArray;

@property (nonatomic,strong) NSMutableArray *userLocationArray;
@property (nonatomic,strong) NSMutableArray *dragLocationArray;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _selectModel = [[ParkingModel alloc] init];
    
    //配置用户Key
    [MAMapServices sharedServices].apiKey = GAODEAPPKEY;
    [AMapSearchServices sharedServices].apiKey = GAODEAPPKEY;
    
    //初始化检索对象
    _mapSearch = [[AMapSearchAPI alloc] init];
    _mapSearch.delegate = self;
    
    //构造AMapInputTipsSearchRequest对象，设置请求参数
    _tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    _tipsRequest.city = @"上海";
    
    
    [self setUI];
    _isEditing = NO;
    
    self.userLocationArray = [NSMutableArray array];
    self.dragLocationArray = [NSMutableArray array];
    
    _myParkID = 0;
    _navigationIndex = -1;
    [self createMap];
    
    self.searchArray = [NSMutableArray array];
    
    [self createUserLoctionBtn];
}

- (void)dealloc
{
    
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        return;
    }
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    [self.searchArray removeAllObjects];
    for (AMapTip *p in response.tips) {
        SearchModel *model = [[SearchModel alloc] init];
        model.searchTitle = p.name;
        model.searchLatitude = p.location.latitude;
        model.searchLongitude = p.location.longitude;
        model.searchDistrict = p.district;
        [self.searchArray addObject:model];
    }
    [self.searchTableView reloadData];
}

//创建地图
- (void)createMap
{
    _mapView = [[MAMapView alloc] initWithFrame:self.mapBackView.bounds];
    _mapView.delegate = self;
    [self.mapBackView addSubview:_mapView];
    
    MACoordinateRegion region;
    region.span = MACoordinateSpanMake(0.05, 0.05);
    region.center = _mapView.userLocation.location.coordinate;
    _mapView.region = region;
    _mapView.showsUserLocation = YES;
    _mapView.showsCompass = YES;//是否显示罗盘
//    _mapView.showTraffic = YES;//是否显示交通
    _mapView.showsScale = YES;//是否显示比例尺
    _nowLatitude = _mapView.userLocation.coordinate.latitude;
    _nowLongitude = _mapView.userLocation.coordinate.longitude;
    
    _dragLatitude = _mapView.userLocation.coordinate.latitude;
    _dragLongitude = _mapView.userLocation.coordinate.longitude;
    
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //跟随用户的位置和角度移动
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
#pragma mark --MAMapView代理方法
/*!
 @brief 定位失败后调用此接口
 @param mapView 地图View
 @param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}

//用户地理位置更新调用
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    
    float horizontalSpace = _nowLatitude - userLocation.coordinate.latitude;
    float verticalSpace = _nowLongitude - userLocation.coordinate.longitude;
    if (horizontalSpace >= 0.01 || horizontalSpace <= -0.01 || verticalSpace >= 0.01 || verticalSpace <= -0.01)
    {
        _nowLatitude = userLocation.coordinate.latitude;
        _nowLongitude = userLocation.coordinate.longitude;
        //取出当前位置的坐标
        
        //---------------------------网路请求
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *paramDic = @{parking_latitude:@(_nowLatitude),parking_longitude:@(_nowLongitude)};
        
        NSString *urlString = [SEARCH_PARK_BY_LL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        __weak MenuViewController *weakSelf = self;
        [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if ([result isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = result;
                 if ([dict[@"code"] isEqualToString:@"000000"])
                 {
                     [_mapView removeAnnotations:_mapView.annotations];
                     [weakSelf.userLocationArray removeAllObjects];
                     NSArray *listArray = dict[@"datas"][@"parkingList"];
                     for (NSDictionary *tmpDict in listArray)
                     {
                         ParkingModel *model = [[ParkingModel alloc] init];
                         [model setValuesForKeysWithDictionary:tmpDict];
                         [weakSelf.userLocationArray addObject:model];
                     }
                     [self addMyAnnotationWithArray:self.userLocationArray];
                 }else{
                     MyLog(@"%@",dict[@"msg"]);
                 }
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             MyLog(@"%@",error);
         }];
        //---------------------------网路请求
    }
}

#pragma mark - 点击大头针调用
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        
        CustomAnnotationView *customView = (CustomAnnotationView *)view;
        MyPointAnnotation *myPoint = (MyPointAnnotation *)customView.annotation;
        
        MACoordinateRegion region;
        region.span = _mapView.region.span;
        region.center = myPoint.coordinate;
//        _mapView.region = region;
        [_mapView setRegion:region animated:YES];
    }
} 

/**
 *  单击地图底图调用此接口
 *
 *  @param mapView    地图View
 *  @param coordinate 点击位置经纬度
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    
}

#pragma mark -- 添加大头针
- (void)addMyAnnotationWithArray:(NSArray *)array
{
    NSMutableArray *annotationArray = [NSMutableArray array];
    _myParkID = 0;
    for (int i = 0; i < array.count ;i++){
        ParkingModel *model = array[i];
        
        //1.将两个经纬度点转成投影点_mapView.userLocation.coordinate
        MAMapPoint point1 = MAMapPointForCoordinate(_mapView.userLocation.coordinate);
        
        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([model.parking_Latitude floatValue], [model.parking_Longitude floatValue]));
        //2.计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        
        MyPointAnnotation *pointAnnotation = [[MyPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([model.parking_Latitude floatValue], [model.parking_Longitude floatValue]);
        
        pointAnnotation.title = model.parking_Name;
        pointAnnotation.subtitle = [NSString stringWithFormat:@"%d",[model.isIn intValue]];//改为待入场
        pointAnnotation.parkState = [NSString stringWithFormat:@"%d",model.canUse];
        pointAnnotation.parkDistance = [NSString stringWithFormat:@"%d",(int)distance];
        pointAnnotation.parkColorState = model.parking_status;
        
        pointAnnotation.parkID = [NSString stringWithFormat:@"%d",_myParkID];
        _myParkID++;
        
        [annotationArray addObject:pointAnnotation];
    }
    
    [_mapView addAnnotations:annotationArray];
}

//返回添加的大头针
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MyPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
//        annotationView.image = [UIImage imageNamed:@"greenMapNewImage"];
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        annotationView.myDelegate = self;
//        annotationView.selected = YES;
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
//        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

#pragma mark --MyAnnotationViewTapDelegate代理方法
//点击跳转详情
- (void)myAnnotationTapWithIndex:(int)index
{
    ParkingModel *model = self.userLocationArray[index];
    
    ParkingDetailViewController *detailCtrl = [[ParkingDetailViewController alloc] init];
    detailCtrl.parkingModel = model;
    detailCtrl.nowLatitude = _nowLatitude;
    detailCtrl.nowongitude = _nowLongitude;
    
    [self.navigationController pushViewController:detailCtrl animated:YES];
}
//点击调出导航
- (void)myAnnotationTapForNavigationWithIndex:(int)index
{
    _navigationIndex = index;
    
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"苹果自带地图",@"百度地图",@"高德地图", nil];
    //    shareSheet.actionSheetStyle = UIBarStyleBlackOpaque;
    [shareSheet showInView:self.view];
}

#pragma mark -UIActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ParkingModel *model = self.userLocationArray[_navigationIndex];
    
    switch (buttonIndex) {
        case 0:{
            //自带地图导航
            CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(_nowLatitude, _nowLongitude);
            
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
                NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:自己的位置&destination=latlng:%f,%f|name:%@&mode=driving",_nowLatitude,_nowLongitude,[model.parking_Latitude floatValue], [model.parking_Longitude floatValue], model.parking_Name];
                
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

//添加完大头针调用的方法
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (int i=0; i < views.count; i++) {
        if (![views[i] isKindOfClass:[CustomAnnotationView class]]) {
            return;
        }
        CustomAnnotationView *annotationView = (CustomAnnotationView *)views[i];
        
        MyPointAnnotation *annotation = (MyPointAnnotation *)annotationView.annotation;
        

        if ([annotation.subtitle isEqualToString:@"1"]) {
            annotationView.image = [UIImage imageNamed:@"grayMapNewImage"];
            annotationView.parkStateLabel.textColor = [UIColor grayColor];
            annotationView.parkStateLabel.text = @"待";
        }else{
            if ([annotation.parkColorState isEqualToString:@"满"]) {
                annotationView.image = [UIImage imageNamed:@"redMapNewImage"];
                annotationView.parkStateLabel.textColor = [UIColor redColor];
            }else{
                annotationView.image = [UIImage imageNamed:@"greenMapNewImage"];
                annotationView.parkStateLabel.textColor = MAIN_COLOR;
            }
            annotationView.parkStateLabel.text = annotation.parkState;
        }
    }
}


//设置默认的UI界面
- (void)setUI
{  
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.headerView.backgroundColor = MAIN_COLOR;
    
    self.searchResultLabel.layer.cornerRadius = 3;
    self.searchResultLabel.layer.masksToBounds = YES;
    self.searchResultLabel.backgroundColor = [MyUtil colorWithHexString:@"#269d8a"];
    self.searchResultLabel.textColor = [MyUtil colorWithHexString:@"#93cec5"];
    
    //设置搜索页面的UI
    self.heightContraint.constant = SCREEN_HEIGHT;
    self.topConstraint.constant = SCREEN_HEIGHT;
    
    self.searchHeaderView.backgroundColor = MAIN_COLOR;
    self.searchTextField.layer.cornerRadius = 3;
    self.searchTextField.layer.masksToBounds = YES;
    self.searchTextField.backgroundColor = [MyUtil colorWithHexString:@"#269d8a"];
    [self.searchTextField setValue:[MyUtil colorWithHexString:@"#93cec5"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.searchTextField addTarget:self action:@selector(searchTextHaveChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)searchTextHaveChange:(UITextField *)textField
{
    if (self.searchTextField.text.length != 0) {
        [self searchParkingByName:self.searchTextField.text];
    }
}

- (void)createUserLoctionBtn
{
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT-80, 30, 30)];
    imageView2.image = [UIImage imageNamed:@"navigation"];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(0, 0, 30, 30);
    btn2.center = imageView2.center;
    [btn2 addTarget:self action:@selector(gotoUserLoction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:imageView2];
    [self.view addSubview:btn2];
}

#pragma mark -- 锁定用户的坐标
//回到用户当前位置
- (void)gotoUserLoction:(UIButton *)btn
{
    MACoordinateRegion region;
    region.span = MACoordinateSpanMake(0.05, 0.05);
    region.center = _mapView.userLocation.location.coordinate;
    _mapView.region = region;
}

#pragma mark ---UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 28;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"searchListCellId";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil]lastObject];
    }
    SearchModel *model = self.searchArray[indexPath.row];
    cell.myTitleLabel.text = model.searchTitle;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchModel *model = self.searchArray[indexPath.row];
    
    MACoordinateRegion region;
    region.span = MACoordinateSpanMake(0.005, 0.005);
    region.center = CLLocationCoordinate2DMake(model.searchLatitude, model.searchLongitude);
//    _mapView.region = region;
    [_mapView setRegion:region animated:YES];
    
    //隐藏搜索视图
    [self.searchTextField resignFirstResponder];
    self.searchTextField.text = @"";
    
    self.topConstraint.constant = SCREEN_HEIGHT;
    [self.view bringSubviewToFront:self.searchBackView];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchTextField resignFirstResponder];
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

- (IBAction)editingBtnClick:(id)sender {
//    _isEditing = !_isEditing;
//    
//    if (_isEditing) {
//        //----------换图片
//        self.imageWidthConstraint.constant = 17;
//        self.imageHeightConstraint.constant = 12;
//        self.editingImageView.image = [UIImage imageNamed:@"tick"];
//        self.searchTableView.editing = YES;
//    }else{
//        //----------换图片
//        self.imageWidthConstraint.constant = 17;
//        self.imageHeightConstraint.constant = 17;
//        self.editingImageView.image = [UIImage imageNamed:@"editing"];
//        self.searchTableView.editing = NO;
//    }
}

#pragma mark --跳转选中收藏停车场详情
- (IBAction)gotoSelectParkingBtnClick:(id)sender {
    
    if (_selectModel.parking_Id.length != 0) {
        ParkingDetailViewController *detailCtrl = [[ParkingDetailViewController alloc] init];
        detailCtrl.parkingModel = _selectModel;
        detailCtrl.nowLatitude = _nowLatitude;
        detailCtrl.nowongitude = _nowLongitude;
        
        [self.navigationController pushViewController:detailCtrl animated:YES];
    }
}

//跳转我的收藏
- (IBAction)changeMyHomeBtnClick:(id)sender {
    HomeListViewController *homeListCtrl = [[HomeListViewController alloc] init];
    [self.navigationController pushViewController:homeListCtrl animated:YES];
}

//取消搜索
- (IBAction)cancelSearchBtnClick:(id)sender {
    [self.searchTextField resignFirstResponder];
    self.searchTextField.text = @"";
    
    self.topConstraint.constant = SCREEN_HEIGHT;
    [self.view bringSubviewToFront:self.searchBackView];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

//开始搜索
- (IBAction)beginSearchBtnClick:(id)sender {
    [self.searchTextField resignFirstResponder];
    
    if (self.searchTextField.text.length != 0) {
//        SearchModel *model = [[SearchModel alloc] init];
//        model.searchTitle = self.searchTextField.text;
//        DBManager *manager = [DBManager sharedInstance];
//        BOOL ret = [manager isModelExists:model];
//        if (!ret) {
//            [manager addSearchtModel:model];
//        }
        
        [self searchParkingByName:self.searchTextField.text];
    }else
    {
        ALERT_VIEW(@"请输入关键词");
        _alert = nil;
    }
}

#pragma mark -高德地图根据关键字搜索
- (void)searchParkingByName:(NSString *)keyWord
{
    _tipsRequest.keywords = keyWord;
    //发起输入提示搜索
    [_mapSearch AMapInputTipsSearch: _tipsRequest];
}

- (IBAction)leftUserBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- textField进入编辑状态
- (IBAction)midSearchBtnClick:(id)sender {
    //加载历史搜索数据
//    NSArray *array = [[DBManager sharedInstance] searchAllModel];
//    [self.searchArray removeAllObjects];
//    [self.searchArray addObjectsFromArray:array];
//    [self.searchTableView reloadData];
    [self.searchArray removeAllObjects];
    [self.searchTableView reloadData];
    
    self.topConstraint.constant = 0;
    [self.view bringSubviewToFront:self.searchBackView];//让搜索页面始终在最前方
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        [self.searchTextField becomeFirstResponder];
    }];
//    [self.searchTextField becomeFirstResponder];
}

- (IBAction)rightListBtnClick:(id)sender {
    
}



@end









