//
//  SiSLoginViewController.m
//  46_Client_Server_APIs_OAuth_T
//
//  Created by Stanly Shiyanovskiy on 16.06.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSLoginViewController.h"
#import "SiSAccessToken.h"

@interface SiSLoginViewController () <UIWebViewDelegate>

@property (copy, nonatomic) SiSLoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView* webView;

@end

@implementation SiSLoginViewController

- (id) initWithCompletionBlock:(SiSLoginCompletionBlock) completionBlock {
    
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect r = self.view.bounds;
    r.origin = CGPointZero;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:r];
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:webView];
    
    self.webView = webView;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(actionCancel:)];
    
    [self.navigationItem setRightBarButtonItem:item animated:NO];
    
    self.navigationItem.title = @"Login";
    
    NSString* urlString = @"https://oauth.vk.com/authorize?"
                           "client_id=5508572&"
                           "display=mobile&"
                           "redirect_uri=https://oauth.vk.com/blank.html&"
                           "scope=139286&"
                           "revoke=1&"
                           "response_type=token";
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    webView.delegate = self;
    
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    
    self.webView.delegate = nil;
}

#pragma mark - Actions

- (void) actionCancel:(UIBarButtonItem*) sender {
    
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] description] rangeOfString:@"#access_token="].location != NSNotFound) {
        
        SiSAccessToken* token = [[SiSAccessToken alloc] init];
        
        NSString* query = [[request URL] description];
        
        NSArray* array = [query componentsSeparatedByString:@"#"];
        
        if ([array count] > 1) {
            
            query = [array lastObject];
        }
        
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString* pair in pairs) {
            
            NSArray* values = [pair componentsSeparatedByString:@"="];
            
            if ([values count] == 2) {
                
                NSString* key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    
                    token.token = [values lastObject];
                    
                } else if ([key isEqualToString:@"expires_in"]) {
                 
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    
                } else if ([key isEqualToString:@"user_id"]) {
                    
                    token.friendID = [values lastObject];
                }
            }
        }
        
        self.webView.delegate = nil;
        
        if (self.completionBlock) {
            self.completionBlock(token);
        }
        
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
        
        return NO;
    }
    
    NSLog(@"%@", [request URL]);
    
    return YES;
}




@end
