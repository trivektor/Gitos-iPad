//
//  ContributionsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/23/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "ContributionsViewController.h"

@interface ContributionsViewController ()

@end

@implementation ContributionsViewController

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
    [self fetchContributions];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s contributions", [self.user getLogin]];
}

- (void)fetchContributions
{
    NSString *contributionsFormPath = [[NSBundle mainBundle] pathForResource:@"contributions" ofType:@"html"];
    NSString *contributionsFormHtml = [NSString stringWithContentsOfFile:contributionsFormPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.contributionsView loadHTMLString:[NSString stringWithFormat:contributionsFormHtml, [self.user getLogin]] baseURL:baseUrl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
