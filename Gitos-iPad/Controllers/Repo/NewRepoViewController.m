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

    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Create"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(submitNewRepo)];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = LOADING_MESSAGE;
    hud.hidden = YES;

    [self.navigationItem setRightBarButtonItem:submitButton];

    [self.view setBackgroundColor:[UIColor colorWithRed:230/255.0
                                                       green:230/255.0
                                                        blue:237/255.0
                                                       alpha:1.0]];

    [repoFormTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [repoFormTable setSeparatorColor:[UIColor colorWithRed:200/255.0
                                                  green:200/255.0
                                                   blue:200/255.0
                                                  alpha:1.0]];

    [repoFormTable drawShadow];
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
        [hud show:YES];

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
    [hud hide:YES];
}

- (void)handleCreationFailure:(NSNotification *)notification
{
    NSMutableArray *errors = (NSMutableArray *) notification.object;
    [AppHelper flashError:[errors componentsJoinedByString:@", "]
                   inView:self.view];
    [hud hide:YES];
}

- (void)blurFields
{
    if ([nameTextField isFirstResponder]) [nameTextField resignFirstResponder];
    if ([descriptionTextField isFirstResponder]) [descriptionTextField resignFirstResponder];
    if ([homePageTextField isFirstResponder]) [homePageTextField resignFirstResponder];
}

@end
