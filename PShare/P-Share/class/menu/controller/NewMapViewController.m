//
//  NewMapViewController.m
//  P-Share
//
//  Created by fay on 15/12/30.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "NewMapViewController.h"
#import <MapKit/MapKit.h>
#import "ParkingModel.h"

#import "MyPointAnnotation.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>

@interface NewMapViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
    
    float _nowLatitude;  //当前经度
    float _nowLongitude;   //当前纬度
    
    float _dragLatitude;  //拖动后的经度
    float _dragLongitude;   //拖动后的纬度

    int _myParkID;
    
}
@property (nonatomic,retain)NSMutableArray *userLocationArray;


@end

@implementation NewMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    配置AppID
    [MAMapServices sharedServices].apiKey = GAODEAPPKEY;
    
    [self createMap];
    [self createUserLoctionBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)gotoUserLoction:(UIButton *)btn
{
    MACoordinateRegion regin;
    regin.span = MACoordinateSpanMake(0.05, 0.05);
    regin.center = _mapView.userLocation.location.coordinate;
    _mapView.region = regin;
    
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
        __weak NewMapViewController *weakSelf = self;
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



#pragma mark -- 常见地图
- (void)createMap
{
    _mapView = [[MAMapView alloc]initWithFrame:_MapView.bounds];
    _mapView.delegate = self;
    [self.MapView addSubview:_mapView];
    
    MACoordinateRegion regin;
    regin.span = MACoordinateSpanMake(0.05, 0.05);
    regin.center = _mapView.userLocation.location.coordinate;
    _mapView.region = regin;
    
    _mapView.showsUserLocation = YES;
    _mapView.showsCompass = YES;
    _mapView.showsScale = YES;
    
    _mapView.zoomLevel = 16;
    _nowLatitude = _mapView.userLocation.coordinate.latitude;
    _nowLongitude = _mapView.userLocation.coordinate.longitude;
    
    _dragLatitude = _mapView.userLocation.coordinate.latitude;
    _dragLongitude = _mapView.userLocation.coordinate.longitude;
    
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
