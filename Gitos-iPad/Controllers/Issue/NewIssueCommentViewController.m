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

@synthesize commentTextField, issue;

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

    self.navigationItem.leftBarButtonItem = dismissButton;

    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(submitComment)];

    self.navigationItem.rightBarButtonItem = submitButton;
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submitComment
{
    if (commentTextField.text.length == 0) {
        [AppHelper flashError:@"Comment cannot be blank" inView:self.view];
    } else {
        [issue createComment:commentTextField.text];
    }
}

@end
