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

@synthesize repo;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Commit Activity";
}

@end
