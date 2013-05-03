//
//  NewsfeedDetailsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "NewsfeedDetailsViewController.h"
#import "ProfileViewController.h"
#import "RepoViewController.h"
#import "GistViewController.h"
#import "WatchEvent.h"
#import "CreateEvent.h"

@interface NewsfeedDetailsViewController ()

@end

@implementation NewsfeedDetailsViewController

@synthesize event, webView;

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

    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"glyphicons_081_refresh"]
                                                       landscapeImagePhone:nil
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(reloadNewsfeedDetails)];

    [self.navigationItem setRightBarButtonItem:reloadButton];
}

- (void)showMenu
{
}

- (void)loadNewsfeedDetails
{
    NSString *newsfeedPath = [[NSBundle mainBundle] pathForResource:@"newsfeed" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:newsfeedPath encoding:NSUTF8StringEncoding error:nil];
    NSString *newsfeedContentHtml = [html stringByReplacingOccurrencesOfString:@"%@" withString:[event toHTMLString]];
    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [webView loadHTMLString:newsfeedContentHtml baseURL:baseUrl];
}

- (void)reloadNewsfeedDetails
{
    [webView reload];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;

    if ([url hasPrefix:@"actor:"]) {
        ProfileViewController *profileController = [[ProfileViewController alloc] init];
        profileController.user = [event getActor];
        [self.navigationController pushViewController:profileController animated:YES];
    } else if ([url hasPrefix:@"repo:"]) {
        RepoViewController *repoController = [[RepoViewController alloc] init];
        repoController.repo = [event getRepo];
        [self.navigationController pushViewController:repoController animated:YES];
    } else if ([url hasPrefix:@"gist:"]) {
        GistViewController *gistController = [[GistViewController alloc] init];
        gistController.gist = [event getTargetGist];
        [self.navigationController pushViewController:gistController animated:YES];
    } else if ([url hasPrefix:@"targetactor:"]) {
        ProfileViewController *profileController = [[ProfileViewController alloc] init];
        profileController.user = [event getTargetActor];
        [self.navigationController pushViewController:profileController animated:YES];
    }

    return TRUE;
}

@end
