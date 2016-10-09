//
//  SellViewController.m
//  No.1 Pharmacy
//
//  Created by JCong on 15/11/4.
//  Copyright © 2015年 梁健聪. All rights reserved.
//

#import "WebViewController.h"
#import "WebModel.h"
#import "SVProgressHUD.h"
#import <unistd.h>
@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation WebViewController
{
    NSString *URL_Web;
    long long expectedLength;
    long long currentLength;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"webStar");
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-69)];
    _webView.backgroundColor = [UIColor whiteColor];
    // iOS中表示请求的类
//    NSLog(@"%@",URL_Web);
    _webView.scalesPageToFit =YES;
    _webView.delegate =self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *url = [NSURL URLWithString:URL_Web];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        _webView.scalesPageToFit =YES;
        // 加载请求(c/s模式)
        [_webView loadRequest:request];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.view addSubview:_webView];
        });
    });
    NSLog(@"webEnd");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    //    [LCProgressHUD showLoading:@"开始加载"];
    [SVProgressHUD showWithStatus:@"开始加载"];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    [LCProgressHUD hide];
    [SVProgressHUD dismiss];
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertController *errorAlertV = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"无网络" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [errorAlertV addAction:cancel];
    [self presentViewController:errorAlertV animated:YES completion:nil];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    JCKLog(@"%ld",response.statusCode);
    if (response.statusCode != 200)
    {
        UIAlertController *errorAlertV = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"网络访问过于频繁,请稍后" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {
        }];
        [errorAlertV addAction:cancel];
        [self presentViewController:errorAlertV animated:YES completion:nil];
        return NO;
        
    }
    return YES;
}

- (void)setModel:(WebModel *)model{
    _model = model;
    URL_Web = model.url;
}


@end
