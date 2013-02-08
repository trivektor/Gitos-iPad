//
//  NewsfeedDetailsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "NewsfeedDetailsViewController.h"
#import "AppConfig.h"
#import "SSKeychain.h"

@interface NewsfeedDetailsViewController ()

@end

@implementation NewsfeedDetailsViewController

@synthesize accessToken, event, currentPage, username, webView, hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self loadNewsfeedDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    [self.navigationItem setTitle:@"Details"];
    [webView setDelegate:self];
    
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"glyphicons_081_refresh"] landscapeImagePhone:nil style:UIBarButtonItemStyleBordered target:self action:@selector(reloadNewsfeedDetails)];

    [self.navigationItem setRightBarButtonItem:reloadButton];

    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = @"Loading";
}

- (void)loadNewsfeedDetails
{
    [self.hud show:YES];
    NSString *urlString = [AppConfig getConfigValue:@"GitosHost"];
    urlString = [urlString stringByAppendingFormat:@"/events/%d?page=%d&username=%@&access_token=%@",
                 self.event.eventId,
                 self.currentPage,
                 self.username,
                 self.accessToken];
    
    NSURL *url = [NSURL URLWithString:urlString];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
}

- (void)reloadNewsfeedDetails
{
    [self.hud hide:NO];
    [webView reload];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hud hide:YES];
}

@end
