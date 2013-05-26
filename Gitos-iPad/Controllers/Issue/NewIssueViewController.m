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

@synthesize issueFormTable, titleCell, descriptionCell, titleField, descriptionField;

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
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Create New Issue";

    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-ok-sign"]
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(submitIssue)];

    [submitButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:17], UITextAttributeFont, nil] forState:UIControlStateNormal];

    [self.navigationItem setRightBarButtonItem:submitButton];
}

- (void)prepIssueFormTable
{
    [issueFormTable setScrollEnabled:NO];
    [issueFormTable drawSeparator];
    [issueFormTable drawShadow];

    [self.view setBackgroundColor:[UIColor colorWithRed:230/255.0
                                                  green:230/255.0
                                                   blue:237/255.0
                                                  alpha:1.0]];
}

- (void)registerEvents
{

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
    if (titleField.text.length == 0 || descriptionField.text.length == 0) {
        [AppHelper flashError:@"Please fill in all the fields"
                       inView:self.view];
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
