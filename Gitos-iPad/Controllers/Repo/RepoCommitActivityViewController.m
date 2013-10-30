//
//  RepoCommitActivityViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 7/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoCommitActivityViewController.h"

@interface RepoCommitActivityViewController ()

@end

@implementation RepoCommitActivityViewController

@synthesize repo, dataWebView;

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
    [self displayCommitActivity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Commit Activity";

    UIBarButtonItem *reloadBtn = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-repeat"]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(displayCommitActivity)];

    [reloadBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:17], NSFontAttributeName, nil]
                             forState:UIControlStateNormal];

    [self.navigationItem setRightBarButtonItem:reloadBtn];
}

- (void)displayCommitActivity
{
    NSString *commitActivity = [[NSBundle mainBundle] pathForResource:@"commit_activity"
                                                               ofType:@"html"];

    NSString *html = [NSString stringWithContentsOfFile:commitActivity
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];

    html = [html stringByReplacingOccurrencesOfString:@"%@"
                                    withString:[NSString stringWithFormat:@"https://api.github.com/repos/%@/stats/commit_activity?access_token=%@", [repo getFullName], [AppHelper getAccessToken]]];

    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [dataWebView loadHTMLString:html
                        baseURL:baseUrl];
}

@end
