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

@synthesize notifications, notificationsTable, currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        notifications = [NSMutableDictionary dictionaryWithDictionary:@{}];
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
    [self setupPullToRefresh];
    [self fetchNotificationsForPage:self.currentPage++];
}

- (void)performHouseKeepingTasks
{
    [self performHousekeepingTasks];

    self.navigationItem.title = @"Notifications";
}

- (void)registerNib
{
    UINib *nib = [UINib nibWithNibName:@"NotificationCell" bundle:nil];
    [notificationsTable registerNib:nib forCellReuseIdentifier:@"NotificationCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *allKeys = [notifications allKeys];
    if (allKeys.count == 0) return 0;
    NSString *repoName = [allKeys objectAtIndex:section];
    return [[notifications valueForKey:repoName] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *keys = [notifications allKeys];
    if (keys.count == 0) return @"";
    return [keys objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NotificationCell";

    NotificationCell *cell = [notificationsTable dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    //cell.notification = [self.notifications objectAtIndex:indexPath.row];
    NSArray *allKeys = [notifications allKeys];

    if (allKeys.count == 0) return nil;

    NSString *repoName = [allKeys objectAtIndex:indexPath.section];
    NSArray *repoNotifications = [notifications objectForKey:repoName];

    if (repoNotifications.count == 0) return nil;

    cell.notification = [repoNotifications objectAtIndex:indexPath.row];
    [cell render];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    Notification *notification = [self.notifications objectAtIndex:indexPath.row];
//
//    if (notification.isIssue) {
//        [self fetchIssue:notification];
//    } else if (notification.isPullRequest) {
//        [self fetchPullRequest:notification];
//    }
//}

- (void)fetchNotificationsForPage:(NSInteger)page
{
    NSString *githubApiHost = [AppConfig getConfigValue:@"GithubApiHost"];
    NSURL *notificationsUrl = [NSURL URLWithString:[githubApiHost stringByAppendingString:@"/notifications"]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:notificationsUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [AppHelper getAccessToken], @"access_token",
                                   @"true", @"all",
                                   [NSString stringWithFormat:@"%i", page], @"page",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET"
                                                               path:notificationsUrl.absoluteString
                                                         parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
         [notificationsTable.pullToRefreshView stopAnimating];
         NSString *response = [operation responseString];

         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         
         NSMutableArray *notificationsArray = [NSMutableArray arrayWithCapacity:0];

         for (int i=0; i < json.count; i++) {
             [notificationsArray addObject:[[Notification alloc] initWithData:[json objectAtIndex:i]]];
         }

         NSMutableDictionary *notificationGroups = [NSMutableDictionary dictionaryWithDictionary:@{}];

         for (int i=0; i < notificationsArray.count; i++) {
             Notification *n = (Notification *) [notificationsArray objectAtIndex:i];
             NSString *key = [[n getRepo] getFullName];
             if (!notifications[key]) notifications[key] = @[n];
             [notificationGroups[key] addObject:n];
         }

         [notificationsTable reloadData];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
         [notificationsTable.pullToRefreshView stopAnimating];
         NSLog(@"%@", error);
     }];
    
    [operation start];
}

- (void)setupPullToRefresh
{
    currentPage = 1;
    [notifications removeAllObjects];
    [notificationsTable addPullToRefreshWithActionHandler:^{
        [self fetchNotificationsForPage:self.currentPage++];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (([scrollView contentOffset].y + scrollView.frame.size.height) == scrollView.contentSize.height) {
        // Bottom of UITableView reached
        [MRProgressOverlayView showOverlayAddedTo:self.view animated:NO];
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
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];

         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         IssueDetailsViewController *issueDetailsController = [[IssueDetailsViewController alloc] init];
         issueDetailsController.issue = [[Issue alloc] initWithData:json];
         [self.navigationController pushViewController:issueDetailsController animated:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
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
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];

         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         PullRequestDetailsViewController *pullRequestDetailsController = [[PullRequestDetailsViewController alloc] init];
         pullRequestDetailsController.pullRequest = [[PullRequest alloc] initWithData:json];
         [self.navigationController pushViewController:pullRequestDetailsController animated:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MRProgressOverlayView dismissOverlayForView:self.view animated:NO];
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
