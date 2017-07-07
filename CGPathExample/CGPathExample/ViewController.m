//
//  ViewController.m
//  CGPathExample
//
//  Created by Puppylpy on 2/25/16.
//  Copyright © 2016 Puppylpy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TriangleView* triangle = [[TriangleView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    triangle.backgroundColor = [UIColor redColor];
    [self.view addSubview:triangle];

    textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 200, 200)];
    textField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textField];
    
    submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 420, 60, 20)];
    [submitBtn setTitle:@"Test" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:submitBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillAppear:(BOOL)animated {
//    float abc = [[NSUserDefaults standardUserDefaults] floatForKey:@"abc"];
//    
//    if (abc == 1.f) {
//        [textField setBackgroundColor:[UIColor blueColor]];
//    }
//    
//    NSLog(@"abc++ = %f++",abc);
//}
//
//-(void)viewWillDisappear:(BOOL)animated {
//    float abc = 1.f;
//    [[NSUserDefaults standardUserDefaults] setFloat:abc forKey:@"abc"];
//    NSLog(@"abc = %f",abc);
//
//}

@end
