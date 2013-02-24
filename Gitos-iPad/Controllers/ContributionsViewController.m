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
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s contributions", [self.user getLogin]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end