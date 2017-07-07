//
//  ParkAndFavViewController.m
//  P-Share
//
//  Created by VinceLee on 15/11/20.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "ParkAndFavViewController.h"
#import "SetParkingCell.h"
#import "MJRefresh.h"
#import "ParkingDetailViewController.h"
#import "SearchParkingViewController.h"
#import "UIImageView+WebCache.h"

@interface ParkAndFavViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    UIAlertView *_alert;
    
    UIView *_lineView;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    BOOL _isFavorite;
    
    NSInteger _curIndex;
    NSInteger _curFavIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
}

@property (nonatomic,strong)NSMutableArray *parkDataArray;
@property (nonatomic,strong)NSMutableArray *favDataArray;

@end

@implementation ParkAndFavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setDefaultUI];
    
    _isFavorite = NO;
    self.parkAndFavTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.parkDataArray = [NSMutableArray array];
    self.favDataArray = [NSMutableArray array];
    
    ALLOC_MBPROGRESSHUD;
    
    [self setRefresh];
}

- (void)setDefaultUI
{
    self.headerView.backgroundColor = MAIN_COLOR;
    
    self.orderLabel.textColor = MAIN_COLOR;
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(_orderBtn.frame.origin.x,_ord_hisView.frame.size.height - 2, (SCREEN_WIDTH-21)/2, 2)];
    _lineView.backgroundColor = MAIN_COLOR;
    [_ord_hisView addSubview:_lineView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self downloadFavoriteData];
}

- (void)setRefresh
{
    _curIndex = 1;
    _curFavIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    _mjHeaderView.scrollView = self.parkAndFavTableView;
    _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
    _mjFooterView.scrollView = self.parkAndFavTableView;
    _mjFooterView.delegate = self;
    
    [self downloadDataWithBeginIndex:_curIndex];
}

- (void)dealloc
{
    [_mjHeaderView free];
    [_mjFooterView free];
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_isLoading) {
        return;
    }
    
    if (_isFavorite) {
        if (_mjHeaderView == refreshView) {
            _curFavIndex = 1;
        }
        if (refreshView == _mjFooterView) {
            _curFavIndex += 1;
        }
        [self downloadFavoriteDataWithBeginIndex:_curFavIndex];
    }else{
        if (_mjHeaderView == refreshView) {
            _curIndex = 1;
        }
        if (refreshView == _mjFooterView) {
            _curIndex += 1;
        }
        [self downloadDataWithBeginIndex:_curIndex];
    }
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
    NSDictionary *paramDic = @{customer_id:userId,@"page_index":indexStr};
    
    NSString *urlString = [CUSFINDALLPARKING stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 if (beginIndex == 1) {
                     [self.parkDataArray removeAllObjects];
                 }
                 NSArray *dictArray = dict[@"datas"][@"parkingList"];
                 if (dictArray.count != 0) {
                     if ([dictArray[0] isKindOfClass:[NSDictionary class]]) {
                         for (NSDictionary *tmpDict in dictArray){
                             ParkingModel *model = [[ParkingModel alloc] init];
                             [model setValuesForKeysWithDictionary:tmpDict];
                             [self.parkDataArray addObject:model];
                         }
                     }
                 }
                 [self.parkAndFavTableView reloadData];
             }else{
                 if (beginIndex == 1) {
                     
                 }else{
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

- (void)downloadFavoriteDataWithBeginIndex:(NSInteger)beginIndex
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
    NSDictionary *paramDic = @{customer_id:userId,@"pageindex":indexStr,@"index":@2};
    
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
                     [self.favDataArray removeAllObjects];
                 }
                 NSArray *dictArray = dict[@"datas"][@"parkingList"];
                 if ([dictArray[0] isKindOfClass:[NSDictionary class]]) {
                     for (NSDictionary *tmpDict in dictArray){
                         ParkingModel *model = [[ParkingModel alloc] init];
                         [model setValuesForKeysWithDictionary:tmpDict];
                         [self.favDataArray addObject:model];
                     }
                 }
                 [self.parkAndFavTableView reloadData];
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

- (void)downloadFavoriteData
{
//    _isLoading = YES;
    //---------------------------网路请求
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSString *indexStr = [NSString stringWithFormat:@"%d",1];
    NSDictionary *paramDic = @{customer_id:userId,@"pageindex":indexStr,@"index":@2};
    
    NSString *urlString = [GET_PARDERLIST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 [self.favDataArray removeAllObjects];
                 
                 NSArray *dictArray = dict[@"datas"][@"parkingList"];
                 if ([dictArray[0] isKindOfClass:[NSDictionary class]]) {
                     for (NSDictionary *tmpDict in dictArray){
                         ParkingModel *model = [[ParkingModel alloc] init];
                         [model setValuesForKeysWithDictionary:tmpDict];
                         [self.favDataArray addObject:model];
                     }
                 }
             }
         }
//         _isLoading = NO;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"77777777%@",error);
//         _isLoading = NO;
     }];
    //---------------------------网路请求
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --   UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isFavorite) {
        return self.favDataArray.count;
    }else{
        return self.parkDataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"setParkingCellId";
    SetParkingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SetParkingCell" owner:self options:nil]lastObject];
    }
    
    ParkingModel *model;
    if (_isFavorite) {
        model = self.favDataArray[indexPath.row];
    }else{
        model = self.parkDataArray[indexPath.row];
    }
    cell.index = indexPath.row;
    cell.parkingTitleLabel.text = model.parking_Name;
    cell.parkingPriceLabel.text = model.parking_address;
    if (model.parking_path.length > 10) {
        [cell.parkingImageView sd_setImageWithURL:[NSURL URLWithString:model.parking_path] placeholderImage:[UIImage imageNamed:@"parkingDefaultImage"]];
    }
    
    if ([[self.parkDataArray[0] ln] isEqualToNumber:@1]) {
        if (indexPath.row == 0) {
            cell.colorView.backgroundColor = MAIN_COLOR;
            
            cell.setHomeParkingBtn.layer.cornerRadius = 4;
            [cell.setHomeParkingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.setHomeParkingBtn setBackgroundColor:MAIN_COLOR];
            [cell.setHomeParkingBtn setTitle:@"首页车场" forState:UIControlStateNormal];
            
        }else{
            cell.colorView.backgroundColor = [UIColor lightGrayColor];
            
            cell.setHomeParkingBtn.layer.cornerRadius = 4;
            cell.setHomeParkingBtn.layer.borderColor = MAIN_COLOR.CGColor;
            cell.setHomeParkingBtn.layer.borderWidth = 1;
            [cell.setHomeParkingBtn setTitle:@"设为首页" forState:UIControlStateNormal];
            [cell.setHomeParkingBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            [cell.setHomeParkingBtn setBackgroundColor:[UIColor whiteColor]];
            
            ParkAndFavViewController *weakSelf = self;
            cell.setHomeParkingBlock = ^(NSInteger index){
                [weakSelf setHomeParkingWithIndex:index];
            };
        }
    }else{
        cell.colorView.backgroundColor = [UIColor lightGrayColor];
        
        cell.setHomeParkingBtn.layer.cornerRadius = 4;
        cell.setHomeParkingBtn.layer.borderColor = MAIN_COLOR.CGColor;
        cell.setHomeParkingBtn.layer.borderWidth = 1;
        [cell.setHomeParkingBtn setTitle:@"设为首页" forState:UIControlStateNormal];
        [cell.setHomeParkingBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [cell.setHomeParkingBtn setBackgroundColor:[UIColor whiteColor]];
        
        ParkAndFavViewController *weakSelf = self;
        cell.setHomeParkingBlock = ^(NSInteger index){
            [weakSelf setHomeParkingWithIndex:index];
        };
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkingModel *model;
    if (_isFavorite) {
        model = self.favDataArray[indexPath.row];
    }else{
        model = self.parkDataArray[indexPath.row];
    }
    
    ParkingDetailViewController *detailCtrl = [[ParkingDetailViewController alloc] init];
    detailCtrl.parkingModel = model;
    detailCtrl.nowLatitude = self.nowLatitude;
    detailCtrl.nowongitude = self.nowLongitude;
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

- (void)setHomeParkingWithIndex:(NSInteger)index
{
    ParkingModel *model;
    if (_isFavorite) {
        model = self.favDataArray[index];
    }else{
        model = self.parkDataArray[index];
    }
    
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = @{customer_id:userId,parking_id:model.parking_Id};
    
    NSString *urlString = [SETDEFAULTSCAN stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
                 ALERT_VIEW(@"设置失败");
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


- (IBAction)backBtnClick:(id)sender {
    _mjHeaderView.delegate = nil;
    _mjFooterView.delegate = nil;
    [_mjFooterView free];
    [_mjHeaderView free];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gotoMapBtnClick:(id)sender {
    SearchParkingViewController *searchCtrl = [[SearchParkingViewController alloc] init];
    searchCtrl.nowLatitude = self.nowLatitude;
    searchCtrl.nowLongitude = self.nowLongitude;
    [self.navigationController pushViewController:searchCtrl animated:YES];
}


- (IBAction)allParkBtnClick:(id)sender {
    self.orderLabel.textColor = MAIN_COLOR;
    self.historyOrderLabel.textColor = [UIColor lightGrayColor];
    CGRect lineViewFrame = _lineView.frame;
    lineViewFrame.origin.x = _orderBtn.frame.origin.x;
    [UIView animateWithDuration:0.2 animations:^{
        _lineView.frame = lineViewFrame;
    }];
    
    _isFavorite = NO;
    [self.parkAndFavTableView reloadData];
}

- (IBAction)favoriteBtnClick:(id)sender {
    self.orderLabel.textColor = [UIColor lightGrayColor];
    self.historyOrderLabel.textColor = MAIN_COLOR;
    CGRect lineViewFrame = _lineView.frame;
    lineViewFrame.origin.x = _historyOrderBtn.frame.origin.x;
    [UIView animateWithDuration:0.2 animations:^{
        _lineView.frame = lineViewFrame;
    }];
    
    _isFavorite = YES;
    [self.parkAndFavTableView reloadData];
}

@end






