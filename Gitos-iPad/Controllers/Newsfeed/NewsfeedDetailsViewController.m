//
//  NewsfeedDetailsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "NewsfeedDetailsViewController.h"

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

@end
