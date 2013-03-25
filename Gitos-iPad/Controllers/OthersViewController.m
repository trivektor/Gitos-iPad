//
//  OthersViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "OthersViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "RepoSearchViewController.h"

@interface OthersViewController ()

@end

@implementation OthersViewController

@synthesize options, user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.options = [[NSMutableArray alloc] initWithObjects:@"Profile",
                        @"Explore", @"Organizations", @"Search", @"Sign out", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"More";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"111-user.png"];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"151-telescope.png"];
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"300-orgchart.png"];
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"06-magnify.png"];
            break;
        case 4:
            cell.imageView.image = [UIImage imageNamed:@"63-runner.png"];
            break;
        default:
            break;
    }
    
    cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:nil];
    [backButton setTintColor:[UIColor colorWithRed:202/255.0 green:0 blue:0 alpha:1]];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    if (indexPath.row == 0) {
        ProfileViewController *profileController = [[ProfileViewController alloc] init];
        profileController.user = self.user;
        [self.navigationController pushViewController:profileController animated:YES];
    }
    
    if (indexPath.row == 3) {
        RepoSearchViewController *repoSearchController = [[RepoSearchViewController alloc] init];
        [self.navigationController pushViewController:repoSearchController animated:YES];
    }
    
    // 'Sign out' was clicked
    if (indexPath.row == [self.options count] - 1) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Go ahead, make my day" otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        return;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 'OK' was clicked
    if (buttonIndex == 0) {
        [SSKeychain deletePasswordForService:@"access_token" account:@"gitos"];
        
        LoginViewController *loginController = [[LoginViewController alloc] init];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
        
        [self.view.window setRootViewController:navController];
    }
}

@end
