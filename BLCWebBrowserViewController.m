//
//  BLCWebBrowserViewController.m
//  BlocBrowser
//
//  Created by Srikanth Narayanamohan on 02/04/2015.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BLCWebBrowserViewController.h"
#import <WebKit/WebKit.h>
#import "BLCAwesomeFloatingToolbar.h"
//@interface BLCWebBrowserViewController () <WKNavigationDelegate, WKUIDelegate, UITextFieldDelegate>
//
//@property (nonatomic, strong) WKWebView *webview;
//


#define kBLCWebBrowserBackString NSLocalizedString(@"Back", @"Back command")
#define kBLCWebBrowserForwardString NSLocalizedString(@"Forward", @"Forward command")
#define kBLCWebBrowserStopString NSLocalizedString(@"Stop", @"Stop command")
#define kBLCWebBrowserRefreshString NSLocalizedString(@"Refresh", @"Reload command")


@interface BLCWebBrowserViewController () <UIWebViewDelegate,UITextFieldDelegate, BLCAwesomeFloatingToolBarDelgate>

@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UITextField *textField;
//@property (nonatomic, strong) UIButton *backButton;
//@property (nonatomic, strong) UIButton *forwardButton;
//@property (nonatomic, strong) UIButton *stopButton;
//@property (nonatomic, strong) UIButton *reloadButton;

//@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSUInteger frameCount;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) BLCAwesomeFloatingToolbar *awesomeToolbar;

@end

@implementation BLCWebBrowserViewController

- (void) resetWebView{
    [self.webview removeFromSuperview];
    
    UIWebView *newWebView = [[UIWebView alloc] init];
    newWebView.delegate = self;
    [self.view addSubview:newWebView];
    
    self.webview = newWebView;
    
    
    self.textField.text = nil;
    [self updateButtonsAndTitle];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - UIViewController
- (void)loadView {
    UIView *mainView = [UIView new];
    
//    self.webview = [[WKWebView alloc]init];
//    self.webview.UIDelegate = self;
//    self.webview.navigationDelegate = self;
    
    self.webview = [[UIWebView alloc] init];
    self.webview.delegate = self;
    
    self.textField = [[UITextField alloc] init];
    self.textField.keyboardType = UIKeyboardTypeURL;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.placeholder = NSLocalizedString(@"Website url or Google Search", @"Placeholder text for web browser url field");
    self.textField.backgroundColor = [UIColor colorWithWhite:220/255.0f alpha:1];
    self.textField.delegate = self;
    
    self.awesomeToolbar = [[BLCAwesomeFloatingToolbar alloc] initWithFourTitles:@[kBLCWebBrowserBackString, kBLCWebBrowserForwardString, kBLCWebBrowserStopString, kBLCWebBrowserRefreshString]];
    self.awesomeToolbar.delegate = self;
    
    
    for(UIView *viewToAdd in @[self.webview, self.textField, self.awesomeToolbar]){
        [mainView addSubview:viewToAdd];
        
    }
    
    
    self.view = mainView;
}

-(void) webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [self updateButtonsAndTitle];
    
    
}


#pragma mark - BLCAwesomeFloatingToolBarDelegate

- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title{
    
    if ([title isEqual:kBLCWebBrowserBackString]) {
        [self.webview goBack];
    } else if ([title isEqual:kBLCWebBrowserForwardString]) {
        [self.webview goForward];
    } else if ([title isEqual:kBLCWebBrowserStopString]) {
        [self.webview stopLoading];
    } else if ([title isEqual:kBLCWebBrowserRefreshString]) {
        [self.webview reload];
    }
}



//
//-(void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [self updateButtonsAndTitle];
//}
//
//-(void) webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    
//    
//}


-(void) viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    self.webview.frame = self.view.frame;
    
    static const CGFloat itemHeight = 50;
    CGFloat width = CGRectGetWidth(self.view.bounds);

    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight;
    
  
    
    self.textField.frame = CGRectMake(0,0,width, itemHeight);
    
    self.webview.frame = CGRectMake(0,CGRectGetMaxY(self.textField.frame), width, browserHeight);
    
    
    self.awesomeToolbar.frame = CGRectMake(0, 100, 100, 100);
    
    
}


#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSString *URLString = textField.text;
    
    
  
    if ([URLString componentsSeparatedByString:@" "].count > 1)
    {
        NSString* escapedUrlString =
        [URLString stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
        
        URLString = [NSString stringWithFormat:@"http://www.google.com/search?q=%@", escapedUrlString];
    }
    NSURL *URL = [NSURL URLWithString:URLString];
    
    if(!URL.scheme){
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", URLString]];
    }
    
    if(URL){
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
     
        [self.webview loadRequest:request];
        
    }
    
    return NO;
    
}



#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    self.frameCount++;
    [self updateButtonsAndTitle];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.frameCount--;
    [self updateButtonsAndTitle];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error.code != -999) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self updateButtonsAndTitle];
    self.frameCount--;

}

//
//-(void) webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
//{
//    if (error.code != -999) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
//    
//        [alert show];
//    }
//    [self updateButtonsAndTitle];
//
//}

#pragma mark - Miscellaneous



-(void) updateButtonsAndTitle{
    
    NSString *webpageTitle = [self.webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (webpageTitle) {
        self.title = webpageTitle;
    } else {
        self.title = self.webview.request.URL.absoluteString;
    }
   
    if (self.frameCount > 0) {
        [self.activityIndicator startAnimating];
    }
    else{
        [self.activityIndicator stopAnimating];
    }
    
    [self.awesomeToolbar setEnabled:[self.webview canGoBack] forButtonWithTitle:kBLCWebBrowserBackString];
    [self.awesomeToolbar setEnabled:[self.webview canGoForward] forButtonWithTitle:kBLCWebBrowserForwardString];
    [self.awesomeToolbar setEnabled:self.frameCount > 0 forButtonWithTitle:kBLCWebBrowserStopString];
    [self.awesomeToolbar setEnabled:self.webview.request.URL && self.frameCount == 0 forButtonWithTitle:kBLCWebBrowserRefreshString];
    
    
}


@end
