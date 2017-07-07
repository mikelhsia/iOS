//
//  SearchParkingViewController.m
//  P-Share
//
//  Created by VinceLee on 15/11/24.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "SearchParkingViewController.h"
#import "SetParkingCell.h"
#import "ParkingDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "HomeViewController.h"

@interface SearchParkingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
}

@property (nonatomic,strong)NSMutableArray *searchArray;

@end

@implementation SearchParkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.searchArray = [NSMutableArray array];
    
    [self setDefaultUI];
}

- (void)setDefaultUI
{
    self.headerView.backgroundColor = MAIN_COLOR;
    
    self.searchTextField.layer.cornerRadius = 4;
    self.searchTextField.layer.masksToBounds = YES;
    self.searchTextField.backgroundColor = [MyUtil colorWithHexString:@"#269d8a"];
    [self.searchTextField setValue:[MyUtil colorWithHexString:@"#93cec5"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.searchTextField becomeFirstResponder];
}

- (void)dealloc
{
    
}

#pragma mark -UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.searchTextField resignFirstResponder];
    
    [self searchRefresh];
    
    return YES;
}

- (void)searchRefresh
{
    if (self.searchTextField.text.length != 0) {
        
        //---------------------------网路请求-----搜索车场
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *paramDic = @{parking_name:self.searchTextField.text};
        
        NSString *urlString = [SEARCH_PARKLIST_BY_NAME stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if ([result isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = result;
                 
                 if ([dict[@"code"] isEqualToString:@"000000"])
                 {
                     [self.searchArray removeAllObjects];
                     
                     if ([dict[@"datas"][@"parkingList"][0] isKindOfClass:[NSDictionary class]]) {
                         NSArray *dataArray = dict[@"datas"][@"parkingList"];
                         for (NSDictionary *tmpDict in dataArray){
                             ParkingModel *model = [[ParkingModel alloc] init];
                             [model setValuesForKeysWithDictionary:tmpDict];
                             [self.searchArray addObject:model];
                         }
                     }
                     [self.searchTableView reloadData];
                 }else{
                     MyLog(@"%@",dict[@"msg"]);
                 }
                 MyLog(@"%@",dict);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             MyLog(@"%@",error);
         }];
        //---------------------------网路请求
    }else{
        ALERT_VIEW(@"请输入关键字");
        _alert = nil;
    }
}


#pragma mark --   UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
    
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
    
    ParkingModel *model = self.searchArray[indexPath.row];
    cell.parkingTitleLabel.text = model.parking_Name;
    cell.parkingPriceLabel.text = model.parking_address;
    if (model.parking_path.length > 10) {
        [cell.parkingImageView sd_setImageWithURL:[NSURL URLWithString:model.parking_path] placeholderImage:[UIImage imageNamed:@"parkingDefaultImage"]];
    }
    
    cell.colorView.backgroundColor = [UIColor lightGrayColor];
    cell.setHomeParkingBtn.layer.cornerRadius = 4;
    cell.setHomeParkingBtn.layer.borderColor = MAIN_COLOR.CGColor;
    cell.setHomeParkingBtn.layer.borderWidth = 1;
    
    cell.setHomeParkingBlock = ^(NSInteger index){
        [self setHomeParkingWithIndex:index];
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkingModel *model = self.searchArray[indexPath.row];
    ParkingDetailViewController *detailCtrl = [[ParkingDetailViewController alloc] init];
    detailCtrl.parkingModel = model;
    detailCtrl.nowLatitude = self.nowLatitude;
    detailCtrl.nowongitude = self.nowLongitude;
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

- (void)setHomeParkingWithIndex:(NSInteger)index
{
    ParkingModel *model = self.searchArray[index];
    
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
                 for (UIViewController *temp in self.navigationController.viewControllers) {
                     if ([temp isKindOfClass:[HomeViewController class]]) {
                         [self.navigationController popToViewController:temp animated:YES];
                     }  
                 }
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

#pragma mark -UIScrollView代理方法
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

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end





