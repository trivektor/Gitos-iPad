//
//  NewsfeedViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 1/28/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "NewsfeedViewController.h"
#import "NewsfeedDetailsViewController.h"
#import "NewsFeedCell.h"

@interface NewsfeedViewController ()

@end

@interface UILabel (BPExtensions)

- (void)sizeToFitFixedWith:(CGFloat)fixedWith;

@end

@implementation UILabel (BPExtensions)

- (void)sizeToFitFixedWith:(CGFloat)fixedWith
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, fixedWith, 0);
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;
    [self sizeToFit];
}

@end

@implementation NewsfeedViewController

@synthesize newsFeed, currentPage, hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        newsFeed     = [[NSMutableArray alloc] initWithCapacity:0];
        currentPage  = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self prepareTableView];
    //self setupPullToRefresh];
    [self registerEvents];
    [self fetchUserNewsFeed];
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}

- (void)performHouseKeepingTasks
{
    [super performHousekeepingTasks];

    self.navigationItem.title = @"News Feed";

    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-repeat"] style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(reloadNewsfeed)];

    [reloadButton setTitleTextAttributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontAwesomeFamilyName size:20]
    } forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:reloadButton];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayUserNewsFeed:)
                                                 name:@"NewsFeedFetched"
                                               object:nil];
}

- (void)prepareTableView
{
    // Load 'NewsFeed' nib
    UINib *nib = [UINib nibWithNibName:@"NewsFeedCell" bundle:nil];
    [newsFeedTable registerNib:nib forCellReuseIdentifier:@"NewsFeedCell"];
    
    // Auto resize
    [newsFeedTable setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
    // Remove background
    [newsFeedTable setBackgroundView:nil];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)fetchUserNewsFeed
{
    [[CurrentUserManager getUser] fetchNewsFeedForPage:currentPage++];
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
    return newsFeed.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NewsFeedCell";

    NewsFeedCell *cell = [newsFeedTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[NewsFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.event = [self.newsFeed objectAtIndex:indexPath.row];
    [cell displayEvent];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsfeedDetailsViewController *newsfeedDetailsController = [[NewsfeedDetailsViewController alloc] init];
    newsfeedDetailsController.event = [newsFeed objectAtIndex:indexPath.row];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [backButton setTintColor:[UIColor colorWithRed:209/255.0 green:0 blue:0 alpha:1]];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    [self.navigationController pushViewController:newsfeedDetailsController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) == scrollView.contentSize.height) {
        // Bottom of UITableView reached
        [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];
        [self fetchUserNewsFeed];
    }
}

- (void)displayUserNewsFeed:(NSNotification *)notication
{
    [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
    [newsFeed addObjectsFromArray:notication.object];
    [newsFeedTable.pullToRefreshView stopAnimating];
    [newsFeedTable reloadData];
}

- (void)setupPullToRefresh
{
    currentPage = 1;
    [newsFeedTable addPullToRefreshWithActionHandler:^{
        [self fetchUserNewsFeed];
    }];
}

- (void)reloadNewsfeed
{
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];
    currentPage = 1;
    [newsFeed removeAllObjects];
    [newsFeedTable reloadData];
    [self fetchUserNewsFeed];
}

@end
