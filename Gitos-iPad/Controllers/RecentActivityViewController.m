//
//  RecentActivityViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/5/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "RecentActivityViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "NewsFeedCell.h"
#import "NSString+FontAwesome.h"
#import "AppConfig.h"
#import "SSKeychain.h"
#import "TimelineEvent.h"
#import "SVPullToRefresh.h"

@interface RecentActivityViewController ()

@end

@implementation RecentActivityViewController

@synthesize activityTable, user, activities, spinnerView, currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.activities  = [[NSMutableArray alloc] initWithCapacity:0];
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
        self.currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    [self performHouseKeepingTasks];
    [self fetchActivities:self.currentPage++];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Recent Activity";
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-repeat"] style:UIBarButtonItemStyleBordered target:self action:@selector(reloadActivities)];
    [reloadButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kFontAwesomeFamilyName size:17], UITextAttributeFont, nil] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:reloadButton];

    [self registerNib];
    [self setupPullToRefresh];
}

- (void)registerNib
{
    UINib *nib = [UINib nibWithNibName:@"NewsFeedCell" bundle:nil];
    [activityTable registerNib:nib forCellReuseIdentifier:@"NewsFeedCell"];
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
    return [self.activities count];
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

    cell.event = [self.activities objectAtIndex:indexPath.row];
    [cell displayEvent];

    return cell;
}

- (void)fetchActivities:(NSInteger)page
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[self.user getEventsUrl]]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   [NSString stringWithFormat:@"%i", page], @"page",
                                   nil];
    
    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:[self.user getEventsUrl] parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];
         
         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         for (int i=0; i < json.count; i++) {
             [self.activities addObject:[[TimelineEvent alloc] initWithOptions:[json objectAtIndex:i]]];
         }
         
         [activityTable.pullToRefreshView stopAnimating];
         [self.spinnerView setHidden:YES];
         [activityTable reloadData];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [self.spinnerView setHidden:YES];
         [activityTable.pullToRefreshView stopAnimating];
     }
     ];
    
    [operation start];
}

- (void)reloadActivities
{
    self.currentPage = 1;
    [self.spinnerView setHidden:NO];
    [self.activities removeAllObjects];
    [self fetchActivities:self.currentPage];
}

- (void)setupPullToRefresh
{
    self.currentPage = 1;
    [activityTable addPullToRefreshWithActionHandler:^{
        [self fetchActivities:self.currentPage++];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) == scrollView.contentSize.height) {
        // Bottom of UITableView reached
        [self.spinnerView setHidden:NO];
        [self fetchActivities:self.currentPage++];
    }
}

@end
