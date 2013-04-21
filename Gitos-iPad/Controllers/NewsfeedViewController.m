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

@synthesize newsFeed, user, currentPage, hud;

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
    [self setupPullToRefresh];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayUserNewsFeed:)
                                                 name:@"NewsFeedFetched"
                                               object:nil];

    [User fetchNewsFeedForUser:[AppHelper getAccountUsername] andPage:currentPage++];
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

    [reloadButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:17], UITextAttributeFont, nil] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:reloadButton];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = LOADING_MESSAGE;
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
    newsfeedDetailsController.currentPage = (indexPath.row / 30) + 1;
    newsfeedDetailsController.username = [user getLogin];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [backButton setTintColor:[UIColor colorWithRed:209/255.0 green:0 blue:0 alpha:1]];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    [self.navigationController pushViewController:newsfeedDetailsController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) == scrollView.contentSize.height) {
        // Bottom of UITableView reached
        [hud show:YES];
        [User fetchNewsFeedForUser:[AppHelper getAccountUsername] andPage:currentPage++];
    }
}

- (void)displayUserNewsFeed:(NSNotification *)notication
{
    [newsFeed addObjectsFromArray:[notication.userInfo valueForKey:@"NewsFeed"]];
    [newsFeedTable.pullToRefreshView stopAnimating];
    [newsFeedTable reloadData];
    [hud hide:YES];
}

- (void)setupPullToRefresh
{
    currentPage = 1;
    [newsFeedTable addPullToRefreshWithActionHandler:^{
        [User fetchNewsFeedForUser:[AppHelper getAccountUsername] andPage:currentPage++];
    }];
}

- (void)reloadNewsfeed
{
    [hud show:YES];
    currentPage = 1;
    [newsFeed removeAllObjects];
    [newsFeedTable reloadData];
    [User fetchNewsFeedForUser:[AppHelper getAccountUsername] andPage:currentPage++];
}

@end
