//
//  UserViewController.m
//  P-Share
//
//  Created by VinceLee on 15/11/24.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoViewController.h"
#import "UserHomeCell.h"
#import "QRCodeGenerator.h"
#import "CarListViewController.h"
#import "HomeListViewController.h"
#import "SetViewController.h"
#import "UIImageView+WebCache.h"
//#import "HistoryOrderViewController.h"
#import "DiscountViewController.h"
#import "HistoryViewController.h"

@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headerView.backgroundColor = MAIN_COLOR;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *phoneNume = [userDefault objectForKey:customer_mobile];
    NSString *userId = [userDefault objectForKey:customer_id];
    NSString *codeString = [NSString stringWithFormat:@"customer:%@ %@",userId,phoneNume];
    /*字符转二维码
     导入 libqrencode文件
     引入头文件#import "QRCodeGenerator.h" 即可使用
     */
    self.quickMarkImageView.image = [QRCodeGenerator qrImageForString:codeString imageSize:self.quickMarkImageView.bounds.size.width];
    
    
    //设置用户基本信息
    NSString *userName = [userDefault objectForKey:customer_nickname];
    if (userName.length != 0) {
        self.userNameLabel.text = userName;
    }
    self.userNumLabel.text = [NSString stringWithFormat:@"登录账号:%@",phoneNume];
//    imageString:网络头像的URL
    NSString *imageString = [userDefault objectForKey:customer_head];
    if (imageString.length > 5) {
        [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"defaultHeaderImage"]];
    }
}


#pragma mark UITableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if (section == 1) {
        return 1;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"userHomeCellId";
    UserHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserHomeCell" owner:self options:nil]lastObject];
    }
    if (indexPath.section == 0) {
        cell.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"userHome%ld",indexPath.row + 1]];
        if (indexPath.row == 0) {
            cell.userTitleLabe.text = @"我的收藏";
        }else if (indexPath.row == 1){
            cell.userTitleLabe.text = @"车辆管理";
        }
        else if (indexPath.row == 2){
            cell.userTitleLabe.text = @"历史订单";
        }
    }else if (indexPath.section == 1) {
        cell.userTitleLabe.text = @"我的优惠券";
        cell.leftImageView.image = [UIImage imageNamed:@"userHome11"];
    }else if (indexPath.section == 2){
        cell.userTitleLabe.text = @"设置";
        cell.leftImageView.image = [UIImage imageNamed:@"userHome21"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HomeListViewController *homeListCtrl = [[HomeListViewController alloc] init];
            [self.navigationController pushViewController:homeListCtrl animated:YES];
        }else if (indexPath.row == 1){
            CarListViewController *carListCtrl = [[CarListViewController alloc] init];
            [self.navigationController pushViewController:carListCtrl animated:YES];
        }else if (indexPath.row == 2){
            HistoryViewController *historyCtrl = [[HistoryViewController alloc] init];
            [self.navigationController pushViewController:historyCtrl animated:YES];
        }
    }else if (indexPath.section == 1) {
        DiscountViewController *discountCtrl = [[DiscountViewController alloc] init];
        [self.navigationController pushViewController:discountCtrl animated:YES];
    }else if (indexPath.section == 2) {
        SetViewController *setCtrl = [[SetViewController alloc] init];
        [self.navigationController pushViewController:setCtrl animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
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

#pragma mark -- 编辑个人资料
- (IBAction)setUserInfoBtnClick:(id)sender {
    UserInfoViewController *userInfoCtrl = [[UserInfoViewController alloc] init];
    [self.navigationController pushViewController:userInfoCtrl animated:YES];
}
@end




