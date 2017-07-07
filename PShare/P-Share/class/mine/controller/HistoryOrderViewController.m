//
//  HistoryOrderViewController.m
//  P-Share
//
//  Created by VinceLee on 15/11/25.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "HistoryOrderViewController.h"
#import "OrderCell.h"
#import "OrderDetailViewController.h"
#import "MJRefresh.h"
#import "AllHistoryDetailViewController.h"
#import "HistoryOrderModel.h"

@interface HistoryOrderViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    UIAlertView *_alert;
}

@property (nonatomic,strong)NSMutableArray *orderArray;

@end

@implementation HistoryOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    self.orderArray = [NSMutableArray array];
    ALLOC_MBPROGRESSHUD;
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.historyTableView.backgroundColor = [MyUtil colorWithHexString:@"eaeaea"];
    
    [self setRefresh];
}

//添加下拉刷新，上拉加载
- (void)setRefresh
{
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    _mjHeaderView.scrollView = self.historyTableView;
    _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
    _mjFooterView.scrollView = self.historyTableView;
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

#pragma mark -MJRefreshBaseView代理方法
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

//加载历史订单数据
- (void)downloadDataWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求-----查看历史订单列表
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSString *indexStr = [NSString stringWithFormat:@"%ld",beginIndex];
    NSDictionary *paramDic = @{customer_id:userId,@"page_index":indexStr};
    
    NSString *urlString = [HISTORY_ORDER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 if (beginIndex == 1) {
                     [self.orderArray removeAllObjects];
                 }
                 NSArray *dataArray = dict[@"datas"][@"orderList"];
                 if ([dataArray[0] isKindOfClass:[NSDictionary class]]) {
                     for (NSDictionary *infoDict in dataArray){
                         HistoryOrderModel *model = [[HistoryOrderModel alloc] init];
                         [model setValuesForKeysWithDictionary:infoDict];
                         
                         [self.orderArray addObject:model];
                     }
                 }
                 [self.historyTableView reloadData];
             }else{
                 if (beginIndex == 1) {
                     ALERT_VIEW(@"还没订单,赶紧去预约车位吧");
                     _alert = nil;
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


#pragma mark UITableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"orderCellId";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:self options:nil]lastObject];
    }
    
    HistoryOrderModel *model = self.orderArray[indexPath.row];
    cell.parkTitleLabel.text = model.parking_Name;
    cell.parkAddressLabel.text = [NSString stringWithFormat:@"车牌号:%@",model.car_Number];
    cell.createDateLabel.text = model.add_time;
    cell.payMoneyLabel.text = [NSString stringWithFormat:@"已付款%.1f元",model.order_total_fee];
    cell.lineView.backgroundColor = [MyUtil colorWithHexString:@"eaeaea"];
    cell.typeLabel.hidden = YES;
    cell.rentMonthLabel.hidden = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllHistoryDetailViewController *detailCtrl = [[AllHistoryDetailViewController alloc] init];
    detailCtrl.orderModel = self.orderArray[indexPath.row];
    detailCtrl.historyType = @"daiBo";
    [self.navigationController pushViewController:detailCtrl animated:YES];
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


@end




