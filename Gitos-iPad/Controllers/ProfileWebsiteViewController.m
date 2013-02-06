//
//  ProfileWebsiteViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/5/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "ProfileWebsiteViewController.h"

@interface ProfileWebsiteViewController ()

@end

@implementation ProfileWebsiteViewController

@synthesize user, profileWebView;

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
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    // Do any additional setup after loading the view from its nib.
    [self loadWebPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWebPage
{
    NSURL *url = [NSURL URLWithString:[self.user getWebsite]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [profileWebView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinnerView setHidden:YES];
    NSString* title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    [self.navigationItem setTitle:title];
}

@end
