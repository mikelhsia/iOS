//
//  DiscountViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/6.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "DiscountViewController.h"
#import "DiscountCell.h"
#import "DiscountModel.h"

@interface DiscountViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UILabel *_secTitleLabel;
    
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
}

@property (nonatomic,strong)NSMutableArray *canUseArray;
@property (nonatomic,strong)NSMutableArray *noUseArray;

@end

@implementation DiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    
    [self setDefaultUI];
    
    if (self.strScan.length > 0) {
        [self getDiscount];
    }else{
        [self loadData];
    }
}

- (void)setDefaultUI
{
    self.canUseArray = [NSMutableArray array];
    self.noUseArray = [NSMutableArray array];
    
    self.headerView.backgroundColor = MAIN_COLOR;
    self.discountTableView.hidden = YES;
    self.noDiscountView.hidden = YES;
    self.discountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.discountBtn.layer.cornerRadius = 2;
    self.discountBtn.layer.borderColor = MAIN_COLOR.CGColor;
    self.discountBtn.layer.borderWidth = 1.5;
    
    ALLOC_MBPROGRESSHUD;
}

- (void)getDiscount{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = @{customer_id:userId,@"vouchersname":self.strScan};
    
    NSString *urlString = [REXEIVEBYVOUCHERS stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 ALERT_VIEW(@"领取成功");
                 _alert = nil;
             }else{
                 ALERT_VIEW(dict[@"msg"]);
                 _alert = nil;
             }
         }
         END_MBPROGRESSHUD;
         [self loadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         END_MBPROGRESSHUD;
         ALERT_VIEW(@"网络不可用");
         _alert = nil;
     }];
    //---------------------------网路请求
}

- (void)loadData
{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    NSDictionary *paramDic = @{customer_id:userId};
    
    NSString *urlString = [GETCOUPONLIST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 [self.canUseArray removeAllObjects];
                 [self.noUseArray removeAllObjects];
                 NSArray *dataArray = dict[@"datas"][@"couponList"];
                 for (NSDictionary *temDict in dataArray){
                     if ([temDict[@"coupon_status"] isEqualToString:@"100201"]) {
                         DiscountModel *model = [[DiscountModel alloc] init];
                         [model setValuesForKeysWithDictionary:temDict];
                         [self.canUseArray addObject:model];
                     }else{
                         DiscountModel *model = [[DiscountModel alloc] init];
                         [model setValuesForKeysWithDictionary:temDict];
                         [self.noUseArray addObject:model];
                     }
                 }
             }else{
                 
             }
             MyLog(@"获取优惠券列表-------%@",dict);
         }
         if (self.canUseArray.count != 0 || self.noUseArray.count != 0) {
             self.discountTableView.hidden = NO;
             self.noDiscountView.hidden = YES;
             [self.discountTableView reloadData];
         }else{
             self.discountTableView.hidden = YES;
             self.noDiscountView.hidden = NO;
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         END_MBPROGRESSHUD;
         self.discountTableView.hidden = YES;
         self.noDiscountView.hidden = NO;
         ALERT_VIEW(@"网络不可用");
         _alert = nil;
     }];
    //---------------------------网路请求
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.canUseArray.count;
    }else{
        return self.noUseArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel;
    if (section == 0) {
        titleLabel = [MyUtil createLabelFrame:CGRectMake(20, 0, SCREEN_WIDTH, 30) title:[NSString stringWithFormat:@"您有%ld张可使用优惠券",self.canUseArray.count] textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft numberOfLine:1];
    }else{
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 1)];
        lineView.backgroundColor = [MyUtil colorWithHexString:@"e5e5e5"];
        [headerView addSubview:lineView];
        
        titleLabel = [MyUtil createLabelFrame:CGRectMake(20, 0, SCREEN_WIDTH, 30) title:@"已过期优惠券" textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft numberOfLine:1];
    }
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && self.canUseArray.count != 0) {
        return 30;
    }else if (section == 1 && self.noUseArray.count != 0){
        return 30;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"discountCellId";
    DiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiscountCell" owner:self options:nil] lastObject];
    }
    
    if (indexPath.section == 0) {//•
        DiscountModel *model = self.canUseArray[indexPath.row];
        
        cell.disTitleLabel.text = model.vouchers_name;
        cell.disDetailLabel1.text = [NSString stringWithFormat:@"•满%.0f元可用",model.minconsumption];
        cell.disDetailLabel3.text = [NSString stringWithFormat:@"•%@至%@",model.effective_begin,model.effective_end];
        if (model.coupon_type == 1) {//面值优惠
            cell.disNumLabel.text = [NSString stringWithFormat:@"%.0f",model.par_amount];
            cell.disNameLabel.text = @"元";
        }else{
            cell.disNumLabel.text = [NSString stringWithFormat:@"%.1f",(float)(model.par_discount/10)];
            cell.disNameLabel.text = @"折";
        }
        
        cell.backImageView.image = [UIImage imageNamed:@"couponsa_canUse"];
        cell.disTitleLabel.textColor = [UIColor whiteColor];
        cell.disDetailLabel1.textColor = [UIColor whiteColor];
        cell.disDetailLabel2.textColor = [UIColor whiteColor];
        cell.disDetailLabel3.textColor = [UIColor whiteColor];
        cell.disNumLabel.textColor = [UIColor whiteColor];
        cell.disNameLabel.textColor = [UIColor whiteColor];
    }else{
        DiscountModel *model = self.noUseArray[indexPath.row];
        
        cell.disTitleLabel.text = model.vouchers_name;
        cell.disDetailLabel1.text = [NSString stringWithFormat:@"•满%.0f元可用",model.minconsumption];
        cell.disDetailLabel3.text = [NSString stringWithFormat:@"•%@至%@",model.effective_begin,model.effective_end];
        if (model.coupon_type == 1) {//面值优惠
            cell.disNumLabel.text = [NSString stringWithFormat:@"%.0f",model.par_amount];
            cell.disNameLabel.text = @"元";
        }else{
            cell.disNumLabel.text = [NSString stringWithFormat:@"%.1f",(float)(model.par_discount/10)];
            cell.disNameLabel.text = @"折";
        }
        
        cell.backImageView.image = [UIImage imageNamed:@"couponsb_noUse"];
        cell.disTitleLabel.textColor = [UIColor lightGrayColor];
        cell.disDetailLabel1.textColor = [UIColor lightGrayColor];
        cell.disDetailLabel2.textColor = [UIColor lightGrayColor];
        cell.disDetailLabel3.textColor = [UIColor lightGrayColor];
        cell.disNumLabel.textColor = [UIColor lightGrayColor];
        cell.disNameLabel.textColor = [UIColor lightGrayColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)discountBtnClick:(id)sender {
    [self.discountTextField resignFirstResponder];
    if (self.discountTextField.text.length > 0) {
        BEGIN_MBPROGRESSHUD;
        //---------------------------网路请求
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDefaultes objectForKey:customer_id];
        NSDictionary *paramDic = @{customer_id:userId,@"cdkey":self.discountTextField.text};
        
        NSString *urlString = [RECEIVEBYCDKEY stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if ([result isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = result;
                 
                 if ([dict[@"code"] isEqualToString:@"000000"])
                 {
                     [self loadData];
                 }else{
                     ALERT_VIEW(@"兑换失败");
                     _alert = nil;
                 }
             }
             END_MBPROGRESSHUD;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             END_MBPROGRESSHUD;
             ALERT_VIEW(@"网络不可用");
             _alert = nil;
         }];
        //---------------------------网路请求
    }else{
        ALERT_VIEW(@"请输入有效兑换码");
        _alert = nil;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.discountTextField resignFirstResponder];
}


@end



