//
//  RepoPunchCardViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 7/17/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoPunchCardViewController.h"

@interface RepoPunchCardViewController ()

@end

@implementation RepoPunchCardViewController

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
    self.navigationItem.title = @"Punch Card";

    UIBarButtonItem *reloadBtn = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-repeat"]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(displayPunchCard)];

    [reloadBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:17], NSFontAttributeName, nil]
                             forState:UIControlStateNormal];

    [self.navigationItem setRightBarButtonItem:reloadBtn];

    [self displayPunchCard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayPunchCard
{
    NSString *punchCard = [[NSBundle mainBundle] pathForResource:@"punch_card"
                                                          ofType:@"html"];

    NSString *html = [NSString stringWithContentsOfFile:punchCard
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];

    html = [html stringByReplacingOccurrencesOfString:@"%@"
                                           withString:[NSString stringWithFormat:@"https://api.github.com/repos/%@/stats/punch_card?access_token=%@", [repo getFullName], [AppHelper getAccessToken]]];

    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [dataWebView loadHTMLString:html
                        baseURL:baseUrl];
}

@end
