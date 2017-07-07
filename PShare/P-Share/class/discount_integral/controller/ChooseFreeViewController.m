//
//  ChooseFreeViewController.m
//  P-Share
//
//  Created by VinceLee on 15/12/9.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "ChooseFreeViewController.h"
#import "DiscountCell.h"

@interface ChooseFreeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
}

@property (nonatomic,strong)NSMutableArray *canUseArray;

@end

@implementation ChooseFreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.chooseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.canUseArray = [NSMutableArray array];
    ALLOC_MBPROGRESSHUD;
    
    [self loadData];
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
                 NSArray *dataArray = dict[@"datas"][@"couponList"];
                 for (NSDictionary *temDict in dataArray){
                     if ([temDict[@"coupon_status"] isEqualToString:@"100201"] && [temDict[@"minconsumption"] intValue] < self.orderTotalPay)
                     {
                         DiscountModel *model = [[DiscountModel alloc] init];
                         [model setValuesForKeysWithDictionary:temDict];
                         [self.canUseArray addObject:model];
                     }
                 }
             }
         }
         
         if (self.canUseArray.count != 0) {
             [self.chooseTableView reloadData];
         }else{
             ALERT_VIEW(@"没有可用优惠券");
             _alert = nil;
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         END_MBPROGRESSHUD;
         ALERT_VIEW(@"网络不可用");
         _alert = nil;
     }];
    //---------------------------网路请求
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.canUseArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"discountCellId";
    DiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiscountCell" owner:self options:nil] lastObject];
    }
    
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        DiscountModel *model = self.canUseArray[indexPath.row];
        [self.delegate selectedFreeWithModel:model];
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




