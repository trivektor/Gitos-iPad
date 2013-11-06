//
//  NewRepoViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/5/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "NewRepoViewController.h"

@interface NewRepoViewController ()

@end

@implementation NewRepoViewController

@synthesize repoFormTable, nameCell, nameTextField, descriptionCell, descriptionTextField,
homePageCell, homePageTextField, visibilityCell, hud;

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
    [self registerEvents];
}

- (void)performHousekeepingTasks
{
    [super performHousekeepingTasks];

    self.navigationItem.title = @"New Repository";

    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-ok-sign"]
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(submitNewRepo)];

    [submitButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:17], NSFontAttributeName, nil] forState:UIControlStateNormal];

    [self.navigationItem setRightBarButtonItem:submitButton];

    [repoFormTable drawSeparator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSuccessfulCreation:)
                                                 name:@"RepoCreationSucceeded"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleCreationFailure:)
                                                 name:@"RepoCreationFailed"
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
    if (indexPath.row == 0) return nameCell;
    if (indexPath.row == 1) return descriptionCell;
    if (indexPath.row == 2) return homePageCell;

    return nil;
}

- (void)submitNewRepo
{
    [self blurFields];

    if (nameTextField.text.length == 0) {
        [AppHelper flashError:@"Name cannot be blank"
                       inView:self.view];
        return;
    } else {
        [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];

        NSDictionary *repoData = @{
            @"name": nameTextField.text,
            @"description": descriptionTextField.text,
            @"homepage": homePageTextField.text
        };
        [Repo createNewWithData:repoData];
    }
}

- (void)handleSuccessfulCreation:(NSNotification *)notification
{
    [AppHelper flashAlert:@"Repo created successfully"
                   inView:self.view];
    [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
}

- (void)handleCreationFailure:(NSNotification *)notification
{
    NSMutableArray *errors = (NSMutableArray *) notification.object;
    [AppHelper flashError:[errors componentsJoinedByString:@", "]
                   inView:self.view];
    [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
}

- (void)blurFields
{
    if ([nameTextField isFirstResponder]) [nameTextField resignFirstResponder];
    if ([descriptionTextField isFirstResponder]) [descriptionTextField resignFirstResponder];
    if ([homePageTextField isFirstResponder]) [homePageTextField resignFirstResponder];
}

@end
