 //
//  MonthlyRentViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/11.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "MonthlyRentViewController.h"
#import "HistoryRentCell.h"
#import "AddRentViewController.h"
#import "HavePayViewController.h"
#import "RentModel.h"
#import "MJRefresh.h"

@interface MonthlyRentViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UIAlertView *_alert;
    
    UIView *footerView;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
}

@property (nonatomic,strong)NSMutableArray *rentDataArray;

@end

@implementation MonthlyRentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ALLOC_MBPROGRESSHUD;
    
    [self setUI];
    
    [self setRefresh];
    
    [self createTableViewFooterView];
    
}

- (void)setUI
{
    self.rentDataArray = [NSMutableArray array];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.rentTableView.backgroundColor = BACKGROUND_COLOR;
    
    self.rentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.headerView.backgroundColor = MAIN_COLOR;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _curIndex = 1;
    [self loadMonthlyRentDataWithBeginIndex:_curIndex];
}

- (void)setRefresh
{
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    _mjHeaderView.scrollView = self.rentTableView;
    _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
    _mjFooterView.scrollView = self.rentTableView;
    _mjFooterView.delegate = self;

    [self loadMonthlyRentDataWithBeginIndex:_curIndex];
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
    [self loadMonthlyRentDataWithBeginIndex:_curIndex];
}


- (void)loadMonthlyRentDataWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSString *indexStr = [NSString stringWithFormat:@"%ld",beginIndex];
    NSDictionary *paramDic = @{customer_id:userId,@"index":@"0",@"pageindex":indexStr};
    
    NSString *urlString = [GET_RENT_ORDER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 if (beginIndex == 1) {
                     [self.rentDataArray removeAllObjects];
                 }
                 NSArray *dataArray = dict[@"datas"][@"feeOrderInfoList"];
                 for (NSDictionary *tmpDict in dataArray){
                     RentModel *model = [[RentModel alloc] init];
                     [model setValuesForKeysWithDictionary:tmpDict];
                     [self.rentDataArray addObject:model];
                 }
             }else{
                 if (beginIndex != 1) {
                     ALERT_VIEW(@"已加载完毕");
                     _alert = nil;
                 }
             }
         }
         [self.rentTableView reloadData];
         _isLoading = NO;
         [_mjHeaderView endRefreshing];
         [_mjFooterView endRefreshing];
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"1111111%@",error);
         _isLoading = NO;
         [_mjHeaderView endRefreshing];
         [_mjFooterView endRefreshing];
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
}

- (void)createTableViewFooterView
{
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footerView.backgroundColor = BACKGROUND_COLOR;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.frame = CGRectMake(0, 5, SCREEN_WIDTH, 45);
    [addBtn setTitle:@"+  添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor whiteColor]];
    [footerView addSubview:addBtn];
    
    [addBtn addTarget:self action:@selector(addNewRent:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 20)];
    addLabel.text = @"点击添加车辆月租";
    addLabel.textColor = [UIColor lightGrayColor];
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.font = [UIFont systemFontOfSize:13];
    [footerView addSubview:addLabel];
    
    self.rentTableView.tableFooterView = footerView;
}

//添加新车辆月租
- (void)addNewRent:(UIButton *)btn
{
    AddRentViewController *addRentCtrl = [[AddRentViewController alloc] init];
    [self.navigationController pushViewController:addRentCtrl animated:YES];
}

#pragma mark UITableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rentDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"historyRentCellId";
    HistoryRentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryRentCell" owner:self options:nil]lastObject];
    }
    RentModel *model = self.rentDataArray[indexPath.row];
    cell.carNumLabel.text = model.carNumber;
    cell.adressLabel.text = model.villageName;
    cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",model.validityStartTime,model.validityEndTime];
    if ([model.orderStatus isEqualToString:@"1"]) {
        [cell.payBtn setBackgroundColor:[UIColor lightGrayColor]];
        cell.payBtn.titleLabel.text = @"已支付";
        [cell.payBtn setTitle:@"已支付" forState:UIControlStateNormal];
    }else{
        [cell.payBtn setBackgroundColor:MAIN_COLOR];
        cell.payBtn.titleLabel.text = @"去支付";
        [cell.payBtn setTitle:@"去支付" forState:UIControlStateNormal];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RentModel *model = self.rentDataArray[indexPath.row];
    if ([model.orderStatus isEqualToString:@"0"]) {
        HavePayViewController *havePayCtrl = [[HavePayViewController alloc] init];
        [self.navigationController pushViewController:havePayCtrl animated:YES];
        havePayCtrl.addRentModel = model;
        havePayCtrl.comeType = @"pay";
    }else if ([model.orderStatus isEqualToString:@"1"]){
        HavePayViewController *havePayCtrl = [[HavePayViewController alloc] init];
        [self.navigationController pushViewController:havePayCtrl animated:YES];
        havePayCtrl.addRentModel = model;
        havePayCtrl.comeType = @"havePay";
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





