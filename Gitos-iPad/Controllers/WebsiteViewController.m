//
//  WebsiteViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/5/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "WebsiteViewController.h"

@interface WebsiteViewController ()

@end

@implementation WebsiteViewController

@synthesize requestedUrl, websiteView, hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = @"Loading";
    // Do any additional setup after loading the view from its nib.
    [self loadWebsite];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWebsite
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestedUrl]];
    
    [websiteView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hud hide:YES];
    self.navigationItem.title = [websiteView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.hud hide:YES];
}

@end
