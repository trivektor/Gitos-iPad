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
    [self registerEvents];
    [self populateUserInfo];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleServerResponse:) name:@"ProfileUpdated" object:nil];
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
    [profileTableForm drawSeparator];

    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-ok-sign"]
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(updateInfo)];

    [submitButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:17], NSFontAttributeName, nil] forState:UIControlStateNormal];

    [self.navigationItem setRightBarButtonItem:submitButton];
}

- (void)updateInfo
{
    NSDictionary *updatedInfo = @{
        @"name"     : nameTextField.text,
        @"email"    : emailTextField.text,
        @"blog"     : websiteTextField.text,
        @"company"  : companyTextField.text,
        @"location" : locationTextField.text
    };

    [self blurTextFields];
    [user update:updatedInfo];
}

- (void)blurTextFields
{
    if (nameTextField.isFirstResponder) [nameTextField resignFirstResponder];
    if (emailTextField.isFirstResponder) [emailTextField resignFirstResponder];
    if (websiteTextField.isFirstResponder) [websiteTextField resignFirstResponder];
    if (companyTextField.isFirstResponder) [companyTextField resignFirstResponder];
    if (locationTextField.isFirstResponder) [locationTextField resignFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)handleServerResponse:(NSNotification *)notification
{
    int statusCode = [notification.object statusCode];

    if (statusCode == 200) {
        [AppHelper flashAlert:@"Profile updated successfully" inView:self.view];
    } else {
        NSString *errorMessage = [NSString stringWithFormat:@"Error: %@", [notification.object responseString]];
        [AppHelper flashError:errorMessage inView:self.view];
    }
}

@end
