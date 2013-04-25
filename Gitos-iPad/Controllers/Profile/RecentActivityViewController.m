//
//  RecentActivityViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/5/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RecentActivityViewController.h"
#import "NewsFeedCell.h"
#import "TimelineEvent.h"
#import <objc/message.h>

@interface RecentActivityViewController ()

@end

@implementation RecentActivityViewController

@synthesize activityTable, user, activities, hud, currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        activities  = [[NSMutableArray alloc] initWithCapacity:0];
        currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self registerNib];
    [self registerEvents];
    [self setupPullToRefresh];
    [User fetchRecentActivityForUser:[user getLogin] andPage:currentPage++];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Recent Activity";

    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-repeat"] style:UIBarButtonItemStyleBordered target:self action:@selector(reloadActivities)];

    [reloadButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:17], UITextAttributeFont, nil] forState:UIControlStateNormal];

    [self.navigationItem setRightBarButtonItem:reloadButton];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"Loading";
}

- (void)registerNib
{
    UINib *nib = [UINib nibWithNibName:@"NewsFeedCell" bundle:nil];
    [activityTable registerNib:nib forCellReuseIdentifier:@"NewsFeedCell"];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayRecentActivity:)
                                                 name:@"RecentActivityFetched"
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
    return [activities count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NewsFeedCell";

    NewsFeedCell *cell = [activityTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[NewsFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.event = [activities objectAtIndex:indexPath.row];
    [cell displayEvent];

    return cell;
}

- (void)displayRecentActivity:(NSNotification *)notification
{
    [activities addObjectsFromArray:notification.object];
    [activityTable reloadData];
    [hud hide:YES];
}

- (void)reloadActivities
{
    self.currentPage = 1;
    [hud show:YES];
    [activities removeAllObjects];
}

- (void)setupPullToRefresh
{
    currentPage = 1;
    [activityTable addPullToRefreshWithActionHandler:^{
        [User fetchRecentActivityForUser:[user getLogin] andPage:currentPage++];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) == scrollView.contentSize.height) {
        // Bottom of UITableView reached
        [hud show:YES];
        [User fetchRecentActivityForUser:[user getLogin] andPage:currentPage++];
    }
}

@end
