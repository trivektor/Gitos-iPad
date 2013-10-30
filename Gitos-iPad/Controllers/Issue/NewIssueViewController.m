//
//  NewIssueViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/25/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "NewIssueViewController.h"

@interface NewIssueViewController ()

@end

@implementation NewIssueViewController

@synthesize issueFormTable, titleCell, descriptionCell, titleField, descriptionField, hud, repo;

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
    [self prepIssueFormTable];
    [self registerEvents];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Create New Issue";

    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-ok-sign"]
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(submitIssue)];

    [submitButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:17], NSFontAttributeName, nil] forState:UIControlStateNormal];

    hud = [AppHelper loadHudInView:self.view
                     withAnimation:YES];
    [hud hide:YES];

    [self.navigationItem setRightBarButtonItem:submitButton];
}

- (void)prepIssueFormTable
{
    [issueFormTable setScrollEnabled:NO];
    [issueFormTable drawSeparator];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleIssueSubmittedEvent:)
                                                 name:@"IssueSubmitted"
                                               object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 211;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return titleCell;
    if (indexPath.row == 1) return descriptionCell;
    return nil;
}

- (void)submitIssue
{
    [self blurFields];

    if (titleField.text.length == 0 || descriptionField.text.length == 0) {
        [AppHelper flashError:@"Please fill in all the fields"
                       inView:self.view];
        return;
    }

    [hud show:YES];
    [repo createIssueWithData:@{
        @"title"        :   titleField.text,
        @"description"  :   descriptionField.text
     }];
}

- (void)handleIssueSubmittedEvent:(NSNotification *)notification
{
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *) notification.object;

    if (operation.response.statusCode == 201) {
        [AppHelper flashAlert:@"Issue has been created"
                       inView:self.view];
    }
    [hud hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)blurFields
{
    [titleField resignFirstResponder];
    [descriptionField resignFirstResponder];
}

@end
