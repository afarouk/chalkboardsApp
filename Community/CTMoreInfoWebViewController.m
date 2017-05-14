//
//  CTMoreInfoWebViewController.m
//  Community
//
//  Created by ADMIN on 18/05/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import "CTMoreInfoWebViewController.h"

@interface CTMoreInfoWebViewController ()

@end

@implementation CTMoreInfoWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *aRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_WebUrl]];
    //    aRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:strLoadUrl]];
    [webViewDetail loadRequest:aRequest];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - WebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [MBProgressHUD showHUDAddedTo:webViewDetail animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:webViewDetail animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:webViewDetail animated:YES];
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

@end
