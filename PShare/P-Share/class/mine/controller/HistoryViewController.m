//
//  HistoryViewController.m
//  P-Share
//
//  Created by VinceLee on 15/12/10.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
{
    
}

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *btnView;
@property (strong, nonatomic) UIButton *parkBtn;
@property (strong, nonatomic) UIButton *temParkBtn;
@property (strong, nonatomic) UIButton *rentBtn;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBar.hidden = YES;
    
    [self createViewControllers];
    
    [self createMyTabBar];
}

- (void)createMyTabBar
{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.headerView.backgroundColor = MAIN_COLOR;
    
    UILabel *titleLabel = [MyUtil createLabelFrame:CGRectMake(50, 64-30, SCREEN_WIDTH-100, 20) title:@"历史订单" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:19] textAlignment:NSTextAlignmentCenter numberOfLine:1];
    [self.headerView addSubview:titleLabel];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 34, 15, 20)];
    backImageView.image = [UIImage imageNamed:@"defaultBack"];
    [self.headerView addSubview:backImageView];
    
    UIButton *backBtn = [MyUtil createBtnFrame:CGRectMake(0, 20, 60, 44) title:nil bgImageName:nil target:self action:@selector(backBtnClick:)];
    [self.headerView addSubview:backBtn];
    
    [self.view addSubview:self.headerView];
    
    //-------------------
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 35)];
    self.btnView.backgroundColor = [UIColor whiteColor];
    
    self.parkBtn = [MyUtil createBtnFrame:CGRectMake(6, 0, (SCREEN_WIDTH-24)/3, 35) title:@"代泊订单" bgImageName:nil target:self action:@selector(parkBtnClick:)];
    self.parkBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.btnView addSubview:self.parkBtn];
    self.temParkBtn = [MyUtil createBtnFrame:CGRectMake(12+(SCREEN_WIDTH-24)/3, 0, (SCREEN_WIDTH-24)/3, 35) title:@"临停订单" bgImageName:nil target:self action:@selector(temParkBtnClick:)];
    self.temParkBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.btnView addSubview:self.temParkBtn];
    self.rentBtn = [MyUtil createBtnFrame:CGRectMake(18+(SCREEN_WIDTH-24)/3*2, 0, (SCREEN_WIDTH-24)/3, 35) title:@"月租/产权订单" bgImageName:nil target:self action:@selector(rentBtnClick:)];
    self.rentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.btnView addSubview:self.rentBtn];
    [self.parkBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [self.temParkBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.rentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(9+(SCREEN_WIDTH-24)/3, 3, 1, 35-6)];
    lineView1.backgroundColor = [MyUtil colorWithHexString:@"cccccc"];
    [self.btnView addSubview:lineView1];
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15+(SCREEN_WIDTH-24)/3*2, 3, 1, 35-6)];
    lineView2.backgroundColor = [MyUtil colorWithHexString:@"cccccc"];
    [self.btnView addSubview:lineView2];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(self.parkBtn.frame.origin.x, 35-2, (SCREEN_WIDTH-24)/3, 2)];
    self.lineView.backgroundColor = MAIN_COLOR;
    [self.btnView addSubview:self.lineView];
    
    [self.view addSubview:self.btnView];
}

//创建视图控制器
- (void)createViewControllers
{
    NSArray *ctrlArray = @[@"HistoryOrderViewController",@"TemHistoryViewController",@"RentHistoryViewController"];
    NSMutableArray *array = [NSMutableArray array];
    
    //循环创建视图控制器
    for (int i=0; i<ctrlArray.count; i++) {
        NSString *className = ctrlArray[i];
        
        Class cls = NSClassFromString(className);
        
        UIViewController *ctrl = [[cls alloc] init];
        
        [array addObject:ctrl];
    }
    self.viewControllers = array;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (void)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)parkBtnClick:(id)sender {
    self.selectedIndex = 0;
    [self.parkBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [self.temParkBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.rentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(self.parkBtn.frame.origin.x, 35-2, (SCREEN_WIDTH-24)/3, 2);
    }];
}

- (void)temParkBtnClick:(id)sender {
    self.selectedIndex = 1;
    [self.parkBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.temParkBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [self.rentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(self.temParkBtn.frame.origin.x, 35-2, (SCREEN_WIDTH-24)/3, 2);
    }];
}

- (void)rentBtnClick:(id)sender {
    self.selectedIndex = 2;
    [self.parkBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.temParkBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.rentBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(self.rentBtn.frame.origin.x, 35-2, (SCREEN_WIDTH-24)/3, 2);
    }];
}
@end


