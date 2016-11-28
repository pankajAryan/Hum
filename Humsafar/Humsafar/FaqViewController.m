//
//  BlogViewController.m
//  FabFurnish
//
//  Created by Apple on 14/10/15.
//  Copyright © 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import "FaqViewController.h"

@interface FaqViewController ()

@end

@implementation FaqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Nav back action

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - load web view
-(void)loadWebView {
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[FFWebServiceHelper urlWithString:@"http://128.199.129.241/humsafarapp/faq/faq.html"]];
    [vwWeb loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)showLoading:(BOOL)isShow{
    if (isShow)
        [self showProgressHudWithMessage:nil];
    else
        [self hideProgressHudAfterDelay:0.0];
    
}

#pragma mark - UIWeb view delegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoading:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self showLoading:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self showLoading:NO];
}

@end
