//
//  AddressViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/18.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "AddressViewController.h"
#import "addressCell.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIAlertView *_alert;
}
@property (nonatomic,strong)NSMutableArray *addressArray;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.headerView.backgroundColor = MAIN_COLOR;
    self.mySearchTableView.backgroundColor = BACKGROUND_COLOR;
    
    self.mySearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.addressArray = [NSMutableArray array];
    
    [self.myTextField addTarget:self action:@selector(searchRefresh:) forControlEvents:UIControlEventEditingChanged];
    
    [self loadData];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.myTextField resignFirstResponder];
}

- (void)searchRefresh:(UITextField *)textField
{
    if (self.myTextField.text.length != 0) {
        
        //---------------------------网路请求-----搜索车场
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *paramDic = @{parking_name:self.myTextField.text};
        
        NSString *urlString = [SEARCH_PARKLIST_BY_NAME stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if ([result isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = result;
                 
                 if ([dict[@"code"] isEqualToString:@"000000"])
                 {
                     [self.addressArray removeAllObjects];
                     
                     if ([dict[@"datas"][@"parkingList"][0] isKindOfClass:[NSDictionary class]]) {
                         NSArray *dataArray = dict[@"datas"][@"parkingList"];
                         for (NSDictionary *tmpDict in dataArray){
                             ParkingModel *model = [[ParkingModel alloc] init];
                             [model setValuesForKeysWithDictionary:tmpDict];
                             [self.addressArray addObject:model];
                         }
                     }
                     [self.mySearchTableView reloadData];
                 }else{
                     MyLog(@"%@",dict[@"msg"]);
                 }
                 MyLog(@"%@",dict);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             MyLog(@"%@",error);
         }];
        //---------------------------网路请求
    }
}

- (void)loadData
{
    //---------------------------网路请求-----搜索车场
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *paramDic;
    if ([self.homeOrMonthlyRent isEqualToString:@"temPark"]) {
        paramDic = @{parking_area:self.homeAddress};
    }else if ([self.homeOrMonthlyRent isEqualToString:@"monthly"]){
        paramDic = @{parking_area:self.monthlyRentAddress};
    }
    
    NSString *urlString = [SEARCH_PARKLIST_BY_AREA stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 [self.addressArray removeAllObjects];
                 
                 if ([dict[@"datas"] isKindOfClass:[NSDictionary class]]) {
                     NSArray *dataArray = dict[@"datas"][@"parkingList"];
                     for (NSDictionary *tmpDict in dataArray){
                         ParkingModel *model = [[ParkingModel alloc] init];
                         [model setValuesForKeysWithDictionary:tmpDict];
                         [self.addressArray addObject:model];
                     }
                 }
                 [self.mySearchTableView reloadData];
             }else{
                 MyLog(@"%@",dict[@"msg"]);
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"%@",error);
     }];
    //---------------------------网路请求
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"addressCellId";
    addressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"addressCell" owner:self options:nil]lastObject];
    }
    
    ParkingModel *model = self.addressArray[indexPath.row];
    cell.parkingNameLabel.text = model.parking_Name;
    cell.parkingAddressLabel.text = model.parking_address;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkingModel *model = self.addressArray[indexPath.row];
    
    if (self.delegate) {
        if ([self.homeOrMonthlyRent isEqualToString:@"temPark"]) {
            [self.delegate selectedParkingAtHome:model];
            
        }else if ([self.homeOrMonthlyRent isEqualToString:@"monthly"]){
            
            [self.delegate selectedParkingAtMonthlyRent:model];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)searchBtnClick:(id)sender {
    [self.myTextField resignFirstResponder];
    
    if (self.myTextField.text.length != 0) {
        
        //---------------------------网路请求-----搜索车场
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *paramDic = @{parking_name:self.myTextField.text};
        
        NSString *urlString = [SEARCH_PARKLIST_BY_NAME stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if ([result isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = result;
                 
                 if ([dict[@"code"] isEqualToString:@"000000"])
                 {
                     [self.addressArray removeAllObjects];
                     
                     if ([dict[@"datas"][@"parkingList"][0] isKindOfClass:[NSDictionary class]]) {
                         NSArray *dataArray = dict[@"datas"][@"parkingList"];
                         for (NSDictionary *tmpDict in dataArray){
                             ParkingModel *model = [[ParkingModel alloc] init];
                             [model setValuesForKeysWithDictionary:tmpDict];
                             [self.addressArray addObject:model];
                         }
                     }
                     [self.mySearchTableView reloadData];
                 }else{
                     MyLog(@"%@",dict[@"msg"]);
                 }
                 MyLog(@"%@",dict);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             MyLog(@"%@",error);
         }];
        //---------------------------网路请求
    }else
    {
        ALERT_VIEW(@"请输入关键字");
        _alert = nil;
    }
}
@end





