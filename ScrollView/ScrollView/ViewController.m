//
//  ViewController.m
//  ScrollView
//
//  Created by Puppylpy on 3/1/16.
//  Copyright © 2016 Puppylpy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    // Do any additional setup after loading the view, typically from a nib.
    UIImage * img = [UIImage imageNamed:@"3101644_221206899369_2.jpg"];
    imageView = [[UIImageView alloc]initWithImage:img];
    [imageView setContentMode:UIViewContentModeScaleToFill];
//    float pro = self.view.frame.size.height/[img size].height;
//    NSLog(@"(%f/%f)pro = %f", self.view.frame.size.height, [img size].height, pro);
//    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [img size].width*pro, [img size].height*pro)];
//    [imageView setImage:img];
    [self.view addSubview:imageView];
    
    [(UIScrollView *)self.view setContentSize:[img size]];
    [(UIScrollView *)self.view setMaximumZoomScale:2.0f];
    [(UIScrollView *)self.view setMinimumZoomScale:0.5f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Implement Zooming
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

@end
