//
//  NotificationsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/18/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "NotificationsViewController.h"
#import "IssueDetailsViewController.h"
#import "PullRequestDetailsViewController.h"
#import "Notification.h"
#import "NotificationCell.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.notifications = [[NSMutableArray alloc] initWithCapacity:0];
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
        self.currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self registerNib];
    [self setupPullToRefresh];
    [self fetchNotificationsForPage:self.currentPage++];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Notifications";
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = @"Loading";
}

- (void)registerNib
{
    UINib *nib = [UINib nibWithNibName:@"NotificationCell" bundle:nil];
    [self.notificationsTable registerNib:nib forCellReuseIdentifier:@"NotificationCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notifications.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NotificationCell";

    NotificationCell *cell = [self.notificationsTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.notification = [self.notifications objectAtIndex:indexPath.row];
    [cell render];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Notification *notification = [self.notifications objectAtIndex:indexPath.row];

    if ([[notification getSubjectType] isEqualToString:@"Issue"]) {
        [self fetchIssue:notification];
    } else if ([[notification getSubjectType] isEqualToString:@"PullRequest"]) {
        [self fetchPullRequest:notification];
    }
}

- (void)fetchNotificationsForPage:(NSInteger)page
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
    NSURL *notificationsUrl = [NSURL URLWithString:[githubApiHost stringByAppendingString:@"/notifications"]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:notificationsUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   @"true", @"all",
                                   [NSString stringWithFormat:@"%i", page], @"page",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:notificationsUrl.absoluteString parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         [self.hud hide:YES];
         [self.notificationsTable.pullToRefreshView stopAnimating];
         NSString *response = [operation responseString];

         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         for (int i=0; i < json.count; i++) {
             [self.notifications addObject:[[Notification alloc] initWithData:[json objectAtIndex:i]]];
         }

         [self.notificationsTable reloadData];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.hud hide:YES];
         [self.notificationsTable.pullToRefreshView stopAnimating];
         NSLog(@"%@", error);
     }];
    
    [operation start];
}

- (void)setupPullToRefresh
{
    self.currentPage = 1;
    [self.notifications removeAllObjects];
    [self.notificationsTable addPullToRefreshWithActionHandler:^{
        [self fetchNotificationsForPage:self.currentPage++];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) == scrollView.contentSize.height) {
        // Bottom of UITableView reached
        [self.hud show:YES];
        [self fetchNotificationsForPage:self.currentPage++];
    }
}

- (void)fetchIssue:(Notification *)notification
{
    NSURL *issueUrl = [NSURL URLWithString:[notification getSubjectUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:issueUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:issueUrl.absoluteString parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         [self.hud hide:YES];

         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         IssueDetailsViewController *issueDetailsController = [[IssueDetailsViewController alloc] init];
         issueDetailsController.issue = [[Issue alloc] initWithData:json];
         [self.navigationController pushViewController:issueDetailsController animated:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.hud hide:YES];
         NSLog(@"%@", error);
     }];

    [operation start];
}

- (void)fetchPullRequest:(Notification *)notification
{
    NSURL *pullRequestUrl = [NSURL URLWithString:[notification getSubjectUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:pullRequestUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:pullRequestUrl.absoluteString parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         [self.hud hide:YES];

         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         PullRequestDetailsViewController *pullRequestDetailsController = [[PullRequestDetailsViewController alloc] init];
         pullRequestDetailsController.pullRequest = [[PullRequest alloc] initWithData:json];
         [self.navigationController pushViewController:pullRequestDetailsController animated:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.hud hide:YES];
         NSLog(@"%@", error);
     }];

    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
