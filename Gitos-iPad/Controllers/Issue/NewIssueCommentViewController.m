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
    [self registerEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Add Comment";
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-remove"]
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(dismiss)];

    [dismissButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:17], UITextAttributeFont, nil] forState:UIControlStateNormal];

    self.navigationItem.leftBarButtonItem = dismissButton;

    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-ok-sign"]
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(submitComment)];

    [submitButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:17], UITextAttributeFont, nil] forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = submitButton;
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleCommentSubmittedEvent:)
                                                 name:@"IssueCommentSubmitted"
                                               object:nil];
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
        [commentTextField resignFirstResponder];
        [issue createComment:commentTextField.text];
    }
}

- (void)handleCommentSubmittedEvent:(NSNotification *)notification
{
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *) notification.object;

    if (operation.response.statusCode == 201) {
        [AppHelper flashAlert:@"Comment has been submitted"
                       inView:self.view];
    }
}

@end
