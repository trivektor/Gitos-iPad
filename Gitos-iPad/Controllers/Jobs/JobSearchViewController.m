//
//  JobSearchViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 12/15/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "JobSearchViewController.h"

@interface JobSearchViewController ()

@end

@implementation JobSearchViewController

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
    [self performHousekeepingTasks];
}

- (void)performHousekeepingTasks
{
    self.navigationItem.title = @"Job Search";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
