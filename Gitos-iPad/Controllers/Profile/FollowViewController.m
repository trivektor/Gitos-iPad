//
//  FollowViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/4/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "FollowViewController.h"
#import "ProfileViewController.h"
#import "UIImageView+WebCache.h"

@interface FollowViewController ()

@end

@implementation FollowViewController

@synthesize controllerTitle, user, users, usersTable, userType, hud, currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        users = [[NSMutableArray alloc] initWithCapacity:0];
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
    [self fetchUsers:currentPage++];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = self.controllerTitle;
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayUsers:)
                                                 name:@"FollowUsersFetched"
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
    return [users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [usersTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    User *_user = [users objectAtIndex:indexPath.row];

    [cell.imageView setImageWithURL:[NSURL URLWithString:[_user getAvatarUrl]] placeholderImage:[UIImage imageNamed:@"avatar-placeholder.png"]];
    cell.textLabel.text = [_user getLogin];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    [cell defineAccessoryType];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileViewController *profileController = [[ProfileViewController alloc] init];
    profileController.user = [users objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:profileController animated:YES];
}

- (void)fetchUsers:(NSInteger)page
{
    if ([userType isEqualToString:@"followers"]) {
        [user fetchFollowersForPage:page];
    } else if ([userType isEqualToString:@"following"]) {
        [user fetchFollowingUsersForPage:page];
    }
}

- (void)displayUsers:(NSNotification *)notification
{
    [users addObjectsFromArray:notification.object];
    [usersTable reloadData];
    [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) == scrollView.contentSize.height) {
        // Bottom of UITableView reached
        [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];
        [self fetchUsers:currentPage++];
    }
}

@end
