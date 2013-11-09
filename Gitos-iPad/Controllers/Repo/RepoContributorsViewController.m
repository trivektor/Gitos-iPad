//
//  RepoContributorsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 7/4/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RepoContributorsViewController.h"
#import "UIImageView+WebCache.h"
#import "ProfileViewController.h"

@interface RepoContributorsViewController ()

@end

@implementation RepoContributorsViewController

@synthesize contributorsTable, contributors, repo, hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        contributors = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self registerEvents];
    [repo fetchContributors];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Contributors";
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayContributors:)
                                                 name:@"RepoContributorsFetched"
                                               object:nil];
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
    return [contributors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [contributorsTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }

    User *contributor = [[contributors objectAtIndex:indexPath.row] getAuthor];
    cell.textLabel.text = [contributor getLogin];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[contributor getAvatarUrl]]
                   placeholderImage:[UIImage imageNamed:@"avatar-placeholder.png"]];
    [cell defineAccessoryType];
    [cell defineHighlightedColorsForLabels:@[]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *contributor = [[contributors objectAtIndex:indexPath.row] getAuthor];
    ProfileViewController *profileController = [[ProfileViewController alloc] init];
    profileController.user = contributor;
    [self.navigationController pushViewController:profileController animated:YES];
}

- (void)displayContributors:(NSNotification *)notification
{
    [contributors addObjectsFromArray:notification.object];
    [contributorsTable reloadData];
    [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
}

@end
