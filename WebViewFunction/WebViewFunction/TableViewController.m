//
//  TableViewController.m
//  WebViewFunction
//
//  Created by Puppylpy on 3/10/16.
//  Copyright © 2016 Puppylpy. All rights reserved.
//

#import "TableViewController.h"
#import "SimpleBrowserController.h"
#import "TestingViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if( cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    NSString * link = nil;
    
    if (indexPath.row == 0) {
        link = @"Go to <a href=\"http://www.baidu.com\">Baidu</a>" ;
    } else if (indexPath.row == 1) {
        link = @"Go to <a href=\"http://apple.com\">Apple</a>" ;
    } else if (indexPath.row == 2) {
        link = @"Go to <a href=\"http://disney.com\">Disney</a>" ;
    }
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:cell.contentView.bounds];
    webView.delegate = self;
    
    [webView loadHTMLString:link baseURL:nil];
    [cell.contentView addSubview:webView];
    
    return cell;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    
//        SimpleBrowserController * webviewController = [[SimpleBrowserController alloc] init];
//        webviewController.url = request.URL;

        TestingViewController *test = [[TestingViewController alloc]init];
        
        if (!self.navigationController) {
            [self.navigationController pushViewController:test animated:YES];
            NSLog(@"Testing");
        } else {
            NSLog(@"No navigationController");
        }
        
//        [self.navigationController pushViewController:webviewController animated:YES];
//        NSLog(@"in here: %@", request.URL);
        
        // Push a new WebViewController into self.navigationController as below
        return NO;
    }
    
    
    return YES;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
