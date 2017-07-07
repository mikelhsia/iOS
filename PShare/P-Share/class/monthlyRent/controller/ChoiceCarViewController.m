//
//  ChoiceCarViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/13.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "ChoiceCarViewController.h"
#import "CarListCell.h"
#import "MJRefresh.h"

@interface ChoiceCarViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
    
    UIAlertView *_alert;
    
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
}

@property (nonatomic,strong)NSMutableArray *carArray;

@end

@implementation ChoiceCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headerView.backgroundColor = MAIN_COLOR;
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.choiceCarTableView.backgroundColor = BACKGROUND_COLOR;
    self.choiceCarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.carArray = [NSMutableArray array];
    
    ALLOC_MBPROGRESSHUD;
    [self setRefresh];
}

- (void)setRefresh
{
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    _mjHeaderView.scrollView = self.choiceCarTableView;
    _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
    _mjFooterView.scrollView = self.choiceCarTableView;
    _mjFooterView.delegate = self;
    
    [self loadCarArrayDataWithBeginIndex:_curIndex];
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
    [self loadCarArrayDataWithBeginIndex:_curIndex];
}


- (void)loadCarArrayDataWithBeginIndex:(NSInteger)beginIndex
{
    _isLoading = YES;
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求-----查看车列表
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSString *indexStr = [NSString stringWithFormat:@"%ld",beginIndex];
    NSDictionary *paramDic = @{customer_id:userId,@"pageindex":indexStr};
    
    NSString *urlString = [GET_CAR_LIST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 if (beginIndex == 1) {
                     [self.carArray removeAllObjects];
                 }
                 NSArray *infoArrray = dict[@"datas"][@"orderInfo"];
                 if ([infoArrray[0] isKindOfClass:[NSDictionary class]]) {
                     for (NSDictionary *infoDict in infoArrray){
                         CarModel *model = [[CarModel alloc] init];
                         [model setValuesForKeysWithDictionary:infoDict];
                         
                         [self.carArray addObject:model];
                     }
                 }
                 [self.choiceCarTableView reloadData];
             }else{
                 if (beginIndex != 1) {
                     ALERT_VIEW(@"已加载完毕");
                     _alert = nil;
                 }else{
                     ALERT_VIEW(@"没有车辆,赶紧去车辆管理添加车辆");
                     _alert = nil;
                 }
             }
         }
         _isLoading = NO;
         [_mjHeaderView endRefreshing];
         [_mjFooterView endRefreshing];
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"%@",error);
         _isLoading = NO;
         [_mjHeaderView endRefreshing];
         [_mjFooterView endRefreshing];
         END_MBPROGRESSHUD;
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
    return self.carArray.count;;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"carListCellId";
    CarListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CarListCell" owner:self options:nil]lastObject];
    }
    CarModel *model = self.carArray[indexPath.row];
    cell.carNameLabel.text = model.car_Brand;
    cell.carNumLabel.text = model.car_Number;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarModel *model = self.carArray[indexPath.row];
    if (self.delegate) {
        [self.delegate selectedCarWithCarModel:model];
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
@end
