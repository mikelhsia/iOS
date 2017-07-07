//
//  FirstViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/2.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "FirstViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "HomeViewController.h"
#import "NewHomeViewController.h"

@interface FirstViewController ()<UIScrollViewDelegate>

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.bottomSpaceConstraint.constant *= RATIO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [userDefaults boolForKey:had_Login];
    if (isLogin) {
//        HomeViewController *homeCtrl = [[HomeViewController alloc] init];
//        [self.navigationController pushViewController:homeCtrl animated:NO];
        NewHomeViewController *homeCtrl = [[NewHomeViewController alloc] init];
        [self.navigationController pushViewController:homeCtrl animated:NO];
    }

    self.guideBackView.hidden = YES;
    //引导页相关
    [self setGuidePage];
    
}

- (void)setGuidePage
{
    NSFileManager *manager=[NSFileManager defaultManager];
   
    //判断 我是否创建了文件，如果没创建 就创建这个文件
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    if (![manager fileExistsAtPath:[path stringByAppendingPathComponent:@"a.txt"]]){
    
        self.guideBackView.hidden = NO;
        self.guideBottomView.hidden = YES;
        
        for (int i=1; i<=5; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*(i-1), 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guidePage%d",i]];
            [self.guideScrollView addSubview:imageView];
        }
        
        self.guideScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*5, SCREEN_HEIGHT);
        self.guideScrollView.pagingEnabled = YES;
        
        //第一次运行后创建文件，以后就不再运行
        [manager createFileAtPath:[path stringByAppendingPathComponent:@"a.txt"] contents:nil attributes:nil];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    引导界面的图片的数量写为了确定值
    if (scrollView.contentOffset.x == SCREEN_WIDTH*4) {
        self.guideBottomView.hidden = NO;
    }else{
        self.guideBottomView.hidden = YES;
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

- (IBAction)guideBtnClick:(id)sender {
    self.guideBackView.hidden = YES;
}

- (IBAction)registBtnClick:(id)sender {
    //跳转注册页面
    RegistViewController *registVCtrl = [[RegistViewController alloc] init];
    
    [self.navigationController pushViewController:registVCtrl animated:YES];
    
}

- (IBAction)loginBtnClick:(id)sender {
    //跳转登陆页面
    LoginViewController *loginVCtrl = [[LoginViewController alloc] init];
    
    [self.navigationController pushViewController:loginVCtrl animated:YES];
}
@end




