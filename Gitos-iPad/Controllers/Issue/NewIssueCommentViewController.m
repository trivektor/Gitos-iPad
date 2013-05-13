//
//  NewIssueCommentViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/12/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "NewIssueCommentViewController.h"

@interface NewIssueCommentViewController ()

@end

@implementation NewIssueCommentViewController

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
    self.navigationItem.title = @"Add Comment";
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(dismiss)];

    self.navigationItem.rightBarButtonItem = dismissButton;
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
