//
//  ViewController.m
//  UITouchExample
//
//  Created by Puppylpy on 3/14/16.
//  Copyright © 2016 Puppylpy. All rights reserved.
//

#import "ViewController.h"
#import "TouchImageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    UIImage *img = [UIImage imageNamed:@"MoveImage.png"];
    
    TouchImageView *imgView = [[TouchImageView alloc] initWithFrame:CGRectMake(80,80,img.size.width/5,img.size.height/5)];
    [imgView setImage:img];
    
    self.view.multipleTouchEnabled = YES;
    
    [self.view addSubview:imgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [event touchesForView:self.view];		
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
