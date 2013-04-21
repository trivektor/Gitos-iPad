//
//  EditProfileViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 4/20/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

@synthesize user, nameCell, emailCell, websiteCell, companyCell, locationCell, profileTableForm,
nameTextField, emailTextField, websiteTextField, companyTextField, locationTextField;

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
    [self populateUserInfo];
}

- (void)populateUserInfo
{
    [nameTextField setText:[user getName]];
    [emailTextField setText:[user getEmail]];
    [websiteTextField setText:[user getWebsite]];
    [companyTextField setText:[user getCompany]];
    [locationTextField setText:[user getLocation]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return nameCell;
    if (indexPath.row == 1) return emailCell;
    if (indexPath.row == 2) return websiteCell;
    if (indexPath.row == 3) return companyCell;
    if (indexPath.row == 4) return locationCell;

    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHousekeepingTasks
{
    self.navigationItem.title = @"Edit Profile";
    [profileTableForm setBackgroundView:nil];

    [profileTableForm setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [profileTableForm setSeparatorColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]];

    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(updateInfo)];
    [self.navigationItem setRightBarButtonItem:submitButton];
}

- (void)updateInfo
{

}

@end
