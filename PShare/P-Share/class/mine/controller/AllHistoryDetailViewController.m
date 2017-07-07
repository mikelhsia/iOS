//
//  AllHistoryDetailViewController.m
//  P-Share
//
//  Created by VinceLee on 15/12/14.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "AllHistoryDetailViewController.h"
#import "AllHistoryCell.h"
#import "PictureView.h"
#import "JZAlbumViewController.h"

@interface AllHistoryDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,PictureViewTapImageDelegate>

@property(nonatomic,strong)NSMutableArray *imageArray;

@end

@implementation AllHistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headerView.backgroundColor = MAIN_COLOR;
    if ([self.historyType isEqualToString:@"daiBo"]) {
        self.headerTitleLabel.text = @"代泊订单详情";
    }else if ([self.historyType isEqualToString:@"linTing"]){
        self.headerTitleLabel.text = @"临停订单详情";
    }
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [MyUtil createLabelFrame:CGRectMake(12, 10, 100, 20) title:@"订单信息" textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft numberOfLine:1];
    [tableHeaderView addSubview:titleLabel];
    self.allHistoryTableView.tableHeaderView = tableHeaderView;
    
    self.allHistoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.allHistoryTableView.backgroundColor = [MyUtil colorWithHexString:@"eaeaea"];
}

#pragma mark --   UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if (section == 1){
        if ([self.historyType isEqualToString:@"daiBo"]) {
            return 6;
        }else{
            return 4;
        }
    }else{
        if ([self.historyType isEqualToString:@"linTing"]) {
            return 3;
        }else{
            return 2;
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2 && [self.historyType isEqualToString:@"daiBo"]){
        return 145;
    }else if (section == 2 || section == 1){
        return 45;
    }else{
        return 0;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.historyType isEqualToString:@"daiBo"]) {
        CGFloat sectionHeaderHeight = 45;
        if (scrollView.contentOffset.y<=sectionHeaderHeight && scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
- (void)pictureViewTapImageWithIndex:(NSInteger)index
{
    JZAlbumViewController *jzAlbumCtrl = [[JZAlbumViewController alloc] init];
    jzAlbumCtrl.imgArr = self.imageArray;
    jzAlbumCtrl.currentIndex = index;
    [self presentViewController:jzAlbumCtrl animated:YES completion:nil];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2 && [self.historyType isEqualToString:@"daiBo"]) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 145)];
        backView.backgroundColor = [UIColor clearColor];
        
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"PictureView" owner:self options:nil];
        PictureView *pictureScrollView = [nibArray objectAtIndex:0];
        pictureScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        pictureScrollView.delegate = self;
        self.imageArray = [NSMutableArray array];
        NSArray *modelImages = [self.orderModel.order_path componentsSeparatedByString:@","];
        [self.imageArray addObjectsFromArray:modelImages];
        [self.imageArray removeObject:@""];
        if (self.orderModel.parking_path.length > 5) {
            NSString *imageString = [self.orderModel.parking_path substringToIndex:[self.orderModel.parking_path length]-1];
            [self.imageArray addObject:imageString];
        }
        [pictureScrollView configDataWithArray:self.imageArray];
        [backView addSubview:pictureScrollView];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, 35)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [backView addSubview:whiteView];
        UILabel *titleLabel = [MyUtil createLabelFrame:CGRectMake(12, 10, 100, 20) title:@"支付信息" textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft numberOfLine:1];
        [whiteView addSubview:titleLabel];
        
        return backView;
    }else if (section == 2 || section == 1){
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        backView.backgroundColor = [UIColor clearColor];
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 35)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [backView addSubview:whiteView];
        UILabel *titleLabel = [MyUtil createLabelFrame:CGRectMake(12, 10, 100, 20) title:nil textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft numberOfLine:1];
        [whiteView addSubview:titleLabel];
        
        if (section == 1) {
            if ([self.historyType isEqualToString:@"daiBo"]) {
                titleLabel.text = @"代泊信息";
            }else if ([self.historyType isEqualToString:@"linTing"]){
                titleLabel.text = @"临停信息";
            }else{
                titleLabel.text = @"车位信息";
            }
        }else if (section == 2){
            titleLabel.text = @"支付信息";
        }
        
        return backView;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"allHistoryCellId";
    AllHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AllHistoryCell" owner:self options:nil]lastObject];
    }
    cell.lineView.hidden = NO;
    if ([self.historyType isEqualToString:@"daiBo"]) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单号: %@",self.orderModel.order_Id];
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = @"订单状态: 已完成";
            }else if (indexPath.row == 2){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单创建时间: %@",self.orderModel.create_at];
            }else if (indexPath.row == 3){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单支付时间: %@",self.orderModel.add_time];
                cell.lineView.hidden = YES;
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"小区名称: %@",self.orderModel.parking_Name];
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"车牌号: %@",self.orderModel.car_Number];
            }else if (indexPath.row == 2){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"代泊员: %@",self.orderModel.parker_name];
            }else if (indexPath.row == 3){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"交车时间: %@",self.orderModel.giveCarTime];
            }else if (indexPath.row == 4){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"取车时间: %@",self.orderModel.getCarTime];
            }else{
                cell.orderTitleLabel.text = @"车辆照片:";
                cell.lineView.hidden = YES;
            }
        }else{
            if (indexPath.row == 0) {
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付方式: %@",self.orderModel.pay_type];
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付金额: %0.1f元",self.orderModel.order_total_fee];
                cell.lineView.hidden = YES;
            }
        }
    }else if ([self.historyType isEqualToString:@"linTing"]){
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单号: %@",self.temOrderModel.order_ID];
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = @"订单状态: 已完成";
            }else if (indexPath.row == 2){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单创建时间: %@",self.temOrderModel.create_at];
            }else if (indexPath.row == 3){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单支付时间: %@",self.temOrderModel.order_actual_end_stop];
                cell.lineView.hidden = YES;
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"小区名称: %@",self.temOrderModel.parking_Name];
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"车牌号: %@",self.temOrderModel.car_Number];
            }else if (indexPath.row == 2){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"进场时间: %@",self.temOrderModel.order_actual_begin_start];
            }else if (indexPath.row == 3){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"停车时长: %@",self.temOrderModel.carStoreTime];
                cell.lineView.hidden = YES;
            }
        }else{
            if (indexPath.row == 0) {
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付方式: %@",self.temOrderModel.pay_type];
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"优惠金额: %@",self.temOrderModel.order_discount];
            }else if (indexPath.row == 2){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付金额: %@",self.temOrderModel.order_total_fee];
                cell.lineView.hidden = YES;
            }
        }
    }else if ([self.historyType isEqualToString:@"yueZu"] || [self.historyType isEqualToString:@"chanQuan"]){
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单号: %@",self.rentModel.ID];
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = @"订单状态: 已到期";
            }else if (indexPath.row == 2){
                //时间数据源   @"yyyy-MM-dd HH:mm:ss"
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy/MM/dd";
                NSDate *date = [formatter dateFromString:self.rentModel.validityEndTime];
                //获取当前年份
                formatter.dateFormat = @"yyyy";
                NSString *yearStr= [formatter stringFromDate:date];
                formatter.dateFormat = @"MM";
                NSString *monStr = [formatter stringFromDate:date];
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单有效月份: %@年%@月",yearStr,monStr];
            }else if (indexPath.row == 3){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"订单支付时间: %@",self.rentModel.pay_time];
                cell.lineView.hidden = YES;
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"小区名称: %@",self.rentModel.villageName];
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = @"车位类型: 产权车位";
            }else if (indexPath.row == 2){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"车牌号: %@",self.rentModel.carNumber];
            }else if (indexPath.row == 3){
                if ([self.historyType isEqualToString:@"chanQuan"]) {
                    cell.orderTitleLabel.text = [NSString stringWithFormat:@"车位号: %@",self.rentModel.parking_number];
                }else{
                    cell.orderTitleLabel.text = [NSString stringWithFormat:@"地址: %@",self.rentModel.address];
                }
                cell.lineView.hidden = YES;
            }
            
        }else{
            if (indexPath.row == 0) {
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付方式: %@",self.rentModel.receivablesPlatformType];
            }else if (indexPath.row == 1){
                cell.orderTitleLabel.text = [NSString stringWithFormat:@"支付金额: %@元",self.rentModel.amount];
                cell.lineView.hidden = YES;
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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




