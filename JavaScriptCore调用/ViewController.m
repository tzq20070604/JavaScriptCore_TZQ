//
//  ViewController.m
//  JavaScriptCore调用
//
//  Created by tangzhiqiang on 2021/1/25.
//  Copyright © 2021 com.yjihua. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <JavaScriptCore/JSContext.h>

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    self.webView.frame = self.view.bounds;
    [self loadHtmlWithFileName:@"javaScript"];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
//        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (void)loadHtmlWithFileName:(NSString *)fileName {
    //加载本地html文件
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    //protocal   html文件名称    html文件类型
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:fileName
                                                             ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    [self.webView loadHTMLString:htmlCont baseURL:baseURL];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"add"] = ^(NSDictionary *params) {
        NSInteger result = [params[@"first"] intValue] + [params[@"two"] intValue];
        NSLog(@"%ld", result);
        NSString *jsStr = [NSString stringWithFormat:@"addCallBack(%ld)", result];
        [[JSContext currentContext] evaluateScript:jsStr];
    };
}
@end
