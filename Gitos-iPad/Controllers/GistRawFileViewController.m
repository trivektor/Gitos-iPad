//
//  GistRawFileViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GistRawFileViewController.h"

@interface GistRawFileViewController ()

@end

@implementation GistRawFileViewController

@synthesize fileWebView;

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
    // Do any additional setup after loading the view from its nib.
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    [self.navigationItem setTitle:[self.gistFile getName]];
    NSURL *fileUrl = [NSURL URLWithString:[self.gistFile getRawUrl]];
    NSURLRequest *fileRequest = [NSURLRequest requestWithURL:fileUrl];
    NSURLConnection *fileConnection = [NSURLConnection connectionWithRequest:fileRequest delegate:self];
    [fileConnection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.spinnerView setHidden:YES];
    
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *htmlString = [NSString stringWithFormat:@" \
                            <!DOCTYPE html> \
                            <html> \
                            <head> \
                            <link rel='stylesheet' href='prettify.css'></link> \
                            <link rel='stylesheet' href='sunburst.css'></link> \
                            <script src='prettify.js'></script> \
                            </head> \
                            <body onload='prettyPrint()'> \
                            <pre class='prettyprint'><code>%@</code></pre> \
                            </body> \
                            </html>", content];
    
    [fileWebView loadHTMLString:htmlString baseURL:baseURL];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinnerView setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
