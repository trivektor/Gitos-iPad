//
//  AttributionsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 6/29/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "AttributionsViewController.h"

@interface AttributionsViewController ()

@end

@implementation AttributionsViewController

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
    [super performHousekeepingTasks];
    self.navigationItem.title = @"Attributions";
    [self loadAttributions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAttributions
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *attributionsFile = [mainBundle pathForResource:@"attributions" ofType:@"html"];
    NSString *attributionsHtml = [NSString stringWithContentsOfFile:attributionsFile
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    [fileWebView loadHTMLString:attributionsHtml baseURL:[NSURL fileURLWithPath:[mainBundle bundlePath]]];
}

@end
