//
//  SecondViewController.h
//  Pushing & Popping
//
//  Created by Puppylpy on 3/3/16.
//  Copyright © 2016 Puppylpy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController {
    NSString * label;
    IBOutlet UILabel *secLabel;
}

@property (copy, nonatomic) NSString *label;

@end
