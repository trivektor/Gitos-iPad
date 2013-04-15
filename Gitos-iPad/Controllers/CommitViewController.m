//
//  CommitViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "CommitViewController.h"

@interface CommitViewController ()

@end

@implementation CommitViewController

@synthesize commit, commitView;

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
    [self registerEvents];
    [self fetchCommitDetails];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = [commit getSha];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayCommitDetails:)
                                                 name:@"CommitDetailsFetched" object:nil];
}

- (void)fetchCommitDetails
{
    [commit fetchDetails];
}

- (void)displayCommitDetails:(NSNotification *)notification
{
    commit = [notification.userInfo valueForKey:@"CommitDetails"];
    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [commitView loadHTMLString:[commit toHTMLString] baseURL:baseUrl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
