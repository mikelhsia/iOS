//
//  FirstNavController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/2.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "FirstNavController.h"
#import "FirstViewController.h"

@interface FirstNavController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation FirstNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationBarHidden = YES;
    self.toolbarHidden = YES;
    
    //实现默认的侧滑返回效果
//    __weak FirstNavController *weakSelf = self;
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.delegate = weakSelf;
//    }
    
    //防止在push过程中触发手势滑动返回，导致导航栏崩溃
//    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//防止在push过程中触发手势滑动返回，导致导航栏崩溃
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    // fix 'nested pop animation can result in corrupted navigation bar'
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//    
//    [super pushViewController:viewController animated:animated];
//}
//- (void)navigationController:(UINavigationController *)navigationController
//       didShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animated
//{
//    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
