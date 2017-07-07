//
//  viewController.m
//  Pushing & Popping
//
//  Created by Puppylpy on 3/3/16.
//  Copyright © 2016 Puppylpy. All rights reserved.
//

#import "viewController.h"
#import "SecondViewController.h"

@interface viewController ()

@end

@implementation viewController
@synthesize pushAnotherBtn = _pushAnotherBtn;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor greenColor]];
    
    // Bar Button Items
    UIBarButtonItem * backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Pop" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // Segment Title View
    NSArray *items = [[NSArray alloc] initWithObjects:@"123",@"456", nil];
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:items];
    self.navigationItem.titleView = segCtrl;
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
- (IBAction)pushAnotherView:(id)sender {
    static int count = 1;
    SecondViewController * secViewCtrl = [[SecondViewController alloc] init];
    [secViewCtrl setTitle:@"Second Page"];
    secViewCtrl.label = [NSString stringWithFormat:@"Pushed %d", count];
    
    count++;
    
    [self.navigationController pushViewController:secViewCtrl animated:YES];
    
}

@end
