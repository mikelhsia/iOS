//
//  viewController.h
//  Pushing & Popping
//
//  Created by Puppylpy on 3/3/16.
//  Copyright © 2016 Puppylpy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface viewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *pushAnotherBtn;
- (IBAction)pushAnotherView:(id)sender;
@end
