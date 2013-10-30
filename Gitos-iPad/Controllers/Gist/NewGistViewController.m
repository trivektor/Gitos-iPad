//
//  NewGistViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/23/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "NewGistViewController.h"

@interface NewGistViewController ()

@end

@implementation NewGistViewController

@synthesize descriptionCell, contentCell, nameCell, descriptionTextField, contentTextField, nameTextField,
gistFormTable;

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

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Create New Gist";
    [gistFormTable setBackgroundView:nil];
    [gistFormTable setSeparatorColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]];

    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-ok-sign"]
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(submitGist)];

    [submitButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:17], NSFontAttributeName, nil] forState:UIControlStateNormal];

    [self.navigationItem setRightBarButtonItem:submitButton];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleServerResponse:)
                                                 name:@"GistSubmitted"
                                               object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return descriptionCell;
    if (indexPath.row == 1) return nameCell;
    if (indexPath.row == 2) return contentCell;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) return 190;
    return 44;
}

- (void)submitGist
{
    [self blurTextFields];

    if (contentTextField.text.length == 0) {
        [AppHelper flashError:@"Gist content cannot be blank" inView:self.view];
        return;
    }

    [Gist save:[self prepDataForSubmission]];
}

- (NSDictionary *)prepDataForSubmission
{
    return @{
        @"description": [descriptionTextField text],
        @"public": @"true",
        @"files": @{
            @"file1.txt": @{
                @"content": [contentTextField text]
            }
        }
    };
}

- (void)handleServerResponse:(NSNotification *)notification
{
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *) notification.object;
    NSHTTPURLResponse *response = [operation response];

    if ([response statusCode] == 201) {
        [AppHelper flashAlert:@"Gist created successfully" inView:self.view];
    } else {
        [AppHelper flashError:[operation responseString] inView:self.view];
    }
}

- (void)blurTextFields
{
    if ([descriptionTextField isFirstResponder]) [descriptionTextField resignFirstResponder];
    if ([nameTextField isFirstResponder]) [nameTextField resignFirstResponder];
    if ([contentTextField isFirstResponder]) [contentTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
