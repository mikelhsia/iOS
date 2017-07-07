//
//  SetViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/7.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "SetViewController.h"
#import "SetCell.h"
#import "AdviceViewController.h"
#import "AboutUsViewController.h"
#import "HelpViewController.h"
#import "RequestModel.h"
#import "VersionModel.h"

@interface SetViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    VersionModel *_versionModel;
    UIAlertView *_alert;
    UIView *_clearBackView;

    
    MBProgressHUD *_mbView;
}

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createTableViewFooterAndSetUI];
    
    
}

- (void)createTableViewFooterAndSetUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.setTableView.backgroundColor = BACKGROUND_COLOR;
    self.setTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.setTableView.bounces = NO;
    
    self.headerView.backgroundColor = MAIN_COLOR;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = BACKGROUND_COLOR;
    
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    quitBtn.frame = CGRectMake(0, 20, SCREEN_WIDTH, 43);
    [quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:[UIColor whiteColor]];
    [footerView addSubview:quitBtn];
    
    [quitBtn addTarget:self action:@selector(quitLogin:) forControlEvents:UIControlEventTouchUpInside];
    self.setTableView.tableFooterView = footerView;
    
    VERSION_MBPROGRESSHUD;
}

- (void)quitLogin:(UIButton *)btn
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认退出" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    alertView = nil;
}

#pragma mark -- alertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_versionModel.trackViewUrl]];
            
        }
    }
    else
    {
        if (buttonIndex == 1) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:NO forKey:had_Login];
            [userDefaults synchronize];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
  
    
}


#pragma mark - UITableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"setCellId";
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SetCell" owner:self options:nil] lastObject];
    }
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"意见反馈";
    }
    if (indexPath.row == 1) {
        cell.titleLabel.text = @"评分打气";
    }
    if (indexPath.row == 2) {
        cell.titleLabel.text = @"关于我们";
    }
    if (indexPath.row == 3) {
        cell.titleLabel.text = @"帮助说明";
    }
    if (indexPath.row == 4) {
        cell.titleLabel.text = @"版本检测";
    }
    
    cell.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"setImage%ld",indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AdviceViewController *adviceCtrl = [[AdviceViewController alloc] init];
        [self.navigationController pushViewController:adviceCtrl animated:YES];
    }
    if (indexPath.row == 1) {
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1049233050"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    if (indexPath.row == 2) {
        AboutUsViewController *aboutCtrl = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutCtrl animated:YES];
    }
    if (indexPath.row == 3) {
        HelpViewController *helpCtrl = [[HelpViewController alloc] init];
        [self.navigationController pushViewController:helpCtrl animated:YES];
    }
    else
    {
        
        [self detectionVersionWithCompletion];
        
    }
}

#pragma mark -- 检测版本
- (void)detectionVersionWithCompletion
{
    BEGIN_MBPROGRESSHUD;
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSLog(@"*****%@",currentVersion);
    [RequestModel requestPShareVersionWithCompletion:^(VersionModel *versionModel) {
        _versionModel = versionModel;
        double doubleCurrentVersion = [currentVersion doubleValue];
        double doubleUpdateVersion = [_versionModel.version doubleValue];
        if (doubleCurrentVersion < doubleUpdateVersion) {
        
            NSString *titleStr = [NSString stringWithFormat:@"检查更新:%@",_versionModel.trackCensoredName];
            NSString *messageStr = [NSString stringWithFormat:@"发现新版本（%@）,是否升级?",_versionModel.version];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
            alertView.tag = 2;
            END_MBPROGRESSHUD;
            [alertView show];
            
        }
        else
        {
            END_MBPROGRESSHUD;
            ALERT_VIEW(@"已是最新版本");
        }
        
    }];
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
