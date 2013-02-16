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
    [self performHouseKeepingTasks];
    NSURL *fileUrl = [NSURL URLWithString:[self.gistFile getRawUrl]];
    NSURLRequest *fileRequest = [NSURLRequest requestWithURL:fileUrl];
    NSURLConnection *fileConnection = [NSURLConnection connectionWithRequest:fileRequest delegate:self];
    [fileConnection start];
}

- (void)performHouseKeepingTasks
{
    [self.navigationItem setTitle:[self.gistFile getName]];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = @"Loading";
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *rawFilePath = [[NSBundle mainBundle] pathForResource:@"raw_file" ofType:@"html"];
    NSString *rawFileContent = [NSString stringWithContentsOfFile:rawFilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *htmlString = [NSString stringWithFormat:rawFileContent, [self encodeHtmlEntities:content]];
    [fileWebView loadHTMLString:htmlString baseURL:baseURL];
    [fileWebView loadHTMLString:htmlString baseURL:baseURL];
    [self.hud hide:YES];
}

- (NSString *)encodeHtmlEntities:(NSString *)rawHtmlString
{
    return [[rawHtmlString
             stringByReplacingOccurrencesOfString: @">" withString: @"&#62;"]
            stringByReplacingOccurrencesOfString: @"<" withString: @"&#60;"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hud hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
