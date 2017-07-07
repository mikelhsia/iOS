//
//  SimpleBrowserController.h
//  WebViewFunction
//
//  Created by Puppylpy on 3/10/16.
//  Copyright © 2016 Puppylpy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleBrowserController : UIViewController <UITextFieldDelegate,UITableViewDelegate, UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *URLSearchBar;


@property (strong, nonatomic)NSURL *url;

@end

