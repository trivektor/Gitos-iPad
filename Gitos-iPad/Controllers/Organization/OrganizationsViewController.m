//
//  OrganizationsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/6/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "OrganizationsViewController.h"
#import "Organization.h"
#import "OrganizationViewController.h"

@interface OrganizationsViewController ()

@end

@implementation OrganizationsViewController

@synthesize organizationsTable, hud, user, organizations, currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        organizations = [[NSMutableArray alloc] initWithCapacity:0];
        currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self registerEvents];
    [self fetchOrganizations];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Organizations";
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayOrganizations:) name:@"OrganizationsFetched" object:nil];
}

- (void)fetchOrganizations
{
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];
    [user fetchOrganizationsForPage:currentPage++];
}

- (void)displayOrganizations:(NSNotification *)notification
{
    [organizations addObjectsFromArray:notification.object];
    [organizationsTable reloadData];
    [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
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
    return [organizations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [organizationsTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    Organization *org = [organizations objectAtIndex:indexPath.row];

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[org getAvatarUrl]]];

    cell.imageView.image = [UIImage imageWithData:data];
    cell.textLabel.text = [org getLogin];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrganizationViewController *organizationController = [[OrganizationViewController alloc] init];
    organizationController.organization = [organizations objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:organizationController animated:YES];
}

@end
