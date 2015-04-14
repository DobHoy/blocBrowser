//
//  BLCWebBrowserViewController.m
//  BlocBrowser
//
//  Created by Srikanth Narayanamohan on 02/04/2015.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BLCWebBrowserViewController.h"
#import <WebKit/WebKit.h>

//@interface BLCWebBrowserViewController () <WKNavigationDelegate, WKUIDelegate, UITextFieldDelegate>
//
//@property (nonatomic, strong) WKWebView *webview;
//


@interface BLCWebBrowserViewController () <UIWebViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UIButton *reloadButton;

//@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSUInteger frameCount;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation BLCWebBrowserViewController

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
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setEnabled:NO];
    
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.forwardButton setEnabled:NO];
    
    self.stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.stopButton setEnabled:NO];
    
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.reloadButton setEnabled:NO];
    
    [self.backButton setTitle:NSLocalizedString(@"Back", @"Back comnmand") forState:UIControlStateNormal];
    [self.backButton addTarget:self.webview action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.forwardButton setTitle:NSLocalizedString(@"Forward", @"Forward comnmand") forState:UIControlStateNormal];
    [self.forwardButton addTarget:self.webview action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    [self.stopButton setTitle:NSLocalizedString(@"Stop", @"Stop comnmand") forState:UIControlStateNormal];
    [self.stopButton addTarget:self.webview action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
    
    [self.reloadButton setTitle:NSLocalizedString(@"Refresh", @"Reload comnmand") forState:UIControlStateNormal];
    [self.reloadButton addTarget:self.webview action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backButton setTitle:NSLocalizedString(@"Back", @"Back Command") forState:UIControlStateNormal];
    
    [self.forwardButton setTitle:NSLocalizedString(@"Forward", @"Forward comnmand") forState:UIControlStateNormal];
    [self.forwardButton addTarget:self.webview action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    [self.stopButton setTitle:NSLocalizedString(@"Stop", @"Stop comnmand") forState:UIControlStateNormal];
    [self.stopButton addTarget:self.webview action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
    
    [self.reloadButton setTitle:NSLocalizedString(@"Refresh", @"Reload comnmand") forState:UIControlStateNormal];
    [self.reloadButton addTarget:self.webview action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [mainView addSubview:self.webview];
//    [mainView addSubview:self.textField];
//    [mainView addSubview:self.backButton];
//    [mainView addSubview:self.forwardButton];
//    [mainView addSubview:self.stopButton];
//    [mainView addSubview:self.reloadButton];
    
    for (UIView *viewToAdd in @[self.webview, self.textField, self.backButton, self.forwardButton, self.stopButton, self.reloadButton]) {
        [mainView addSubview:viewToAdd];
        
    }
    
    
    self.view = mainView;
}

-(void) webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [self updateButtonsAndTitle];
    
    
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
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight -itemHeight;
    CGFloat buttonWidth = CGRectGetWidth(self.view.bounds) / 4;
    
    self.textField.frame = CGRectMake(0,0,width, itemHeight);
    
    self.webview.frame = CGRectMake(0,CGRectGetMaxY(self.textField.frame), width, browserHeight);
    
    CGFloat currentButtonX = 0;
    
    for(UIButton *thisButton in @[self.backButton, self.forwardButton, self.stopButton, self.reloadButton])
    {
        thisButton.frame = CGRectMake(currentButtonX, CGRectGetMaxY(self.webview.frame), buttonWidth, itemHeight);
        currentButtonX += buttonWidth;
    }
    
    
    
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
    
    
    self.backButton.enabled = [self.webview canGoBack];
    self.forwardButton.enabled = [self.webview canGoForward];
    
    self.stopButton.enabled = self.frameCount > 0;
    self.reloadButton.enabled = self.frameCount == 0;
    
    
}


@end
