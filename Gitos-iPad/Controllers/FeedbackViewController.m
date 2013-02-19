//
//  FeedbackViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

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
    [self loadFeedbackForm];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Feedback";
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFeedbackForm
{
    NSString *feedbackFormPath = [[NSBundle mainBundle] pathForResource:@"feedback" ofType:@"html"];
    NSString *feedbackFormHtml = [NSString stringWithContentsOfFile:feedbackFormPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.formWebView loadHTMLString:feedbackFormHtml baseURL:baseUrl];
}

@end
