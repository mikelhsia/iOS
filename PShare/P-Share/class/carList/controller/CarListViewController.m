//
//  CarListViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/9.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "CarListViewController.h"
#import "CarListCell.h"
#import "AddCarInfoViewController.h"
#import "CarModel.h"
#import "MJRefresh.h"

@interface CarListViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    BOOL _isEditing;
    
    NSInteger _curIndex;
    BOOL _isLoading;
    MJRefreshHeaderView *_mjHeaderView;
    MJRefreshFooterView *_mjFooterView;
}

@property (nonatomic,strong)NSMutableArray *carArray;

@end

@implementation CarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
    
    self.carArray = [NSMutableArray array];
    
    [self setRefresh];
    
    [self createTableViewFooterView];
    
    ALLOC_MBPROGRESSHUD;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _curIndex = 1;
    [self loadCarArrayDataWithBeginIndex:_curIndex];
}

- (void)setUI
{
    _isEditing = NO;
    
    self.headerView.backgroundColor = MAIN_COLOR;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.carListTableView.backgroundColor = BACKGROUND_COLOR;
    self.carListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setRefresh
{
    _curIndex = 1;
    _isLoading = NO;
    
    _mjHeaderView = [MJRefreshHeaderView header];
    _mjHeaderView.scrollView = self.carListTableView;
    _mjHeaderView.delegate = self;
    
    _mjFooterView = [MJRefreshFooterView footer];
    _mjFooterView.scrollView = self.carListTableView;
    _mjFooterView.delegate = self;
    
    //    [_mjHeaderView beginRefreshing];
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
                 [self.carListTableView reloadData];
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
         MyLog(@"%@",error);
         _isLoading = NO;
         [_mjHeaderView endRefreshing];
         [_mjFooterView endRefreshing];
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
}

- (void)createTableViewFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footerView.backgroundColor = BACKGROUND_COLOR;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.frame = CGRectMake(0, 5, SCREEN_WIDTH, 45);
    [addBtn setTitle:@"+  添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor whiteColor]];
    [footerView addSubview:addBtn];
    
    [addBtn addTarget:self action:@selector(addNewCar:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 20)];
    addLabel.text = @"点击添加车辆信息";
    addLabel.textColor = [UIColor lightGrayColor];
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.font = [UIFont systemFontOfSize:13];
    [footerView addSubview:addLabel];
    
    self.carListTableView.tableFooterView = footerView;
}

//添加新车辆
- (void)addNewCar:(UIButton *)btn
{
    AddCarInfoViewController *addCarCtrl = [[AddCarInfoViewController alloc] init];
    [self.navigationController pushViewController:addCarCtrl animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carArray.count;
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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求-----删除车辆
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    CarModel *model = self.carArray[indexPath.row];
    NSDictionary *paramDic = @{@"car_id":model.car_id};
    
    NSString *urlString = [DELETE_CAR stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 [self.carArray removeObjectAtIndex:indexPath.row];
                 [self.carListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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

- (IBAction)editingBtnClick:(id)sender {
    _isEditing = !_isEditing;
    
    if (_isEditing) { 
        //----------换图片
        self.imageWidthConstraint.constant = 17;
        self.imageHeightConstraint.constant = 12;
        self.editingImageView.image = [UIImage imageNamed:@"tick"];
        self.carListTableView.editing = YES;
    }else{
        //----------换图片
        self.imageWidthConstraint.constant = 17;
        self.imageHeightConstraint.constant = 17;
        self.editingImageView.image = [UIImage imageNamed:@"deleteEditing"];
        self.carListTableView.editing = NO;
    }
}


@end



