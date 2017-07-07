//
//  SimpleBrowserController.m
//  WebViewFunction
//
//  Created by Puppylpy on 3/10/16.
//  Copyright © 2016 Puppylpy. All rights reserved.
//

#import "SimpleBrowserController.h"

@interface SimpleBrowserController ()

@end


@implementation SimpleBrowserController

@synthesize url=_url;
@synthesize webView=_webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"View did load!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.url = [[NSURL alloc] initWithString:textField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];


    [_webView loadRequest:request];
    
    NSLog(@"Go modified info.plist if the webview can't work just fine. \nThis key is basicly to address that XCode 7 block the access of HTTP protocol");
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    
    NSLog(@"View will appear: %@", self.url);
    
    [_webView loadRequest:request];
    // [self loadurl]
}

#warning Start showing network activity animation (little spinning)
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//- (void) loadurl {
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
//    [self.webView loadRequest:request];
//    
//    self.URLSearchBar.text = self.url.absoluteString;
//}


//
//-(void)dealloc {
//    [super dealloc];
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
