//
//  PullRequestDetailsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/24/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "PullRequestDetailsViewController.h"

@interface PullRequestDetailsViewController ()

@end

@implementation PullRequestDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
        self.comments = [[NSMutableArray alloc] initWithCapacity:0];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self fetchPullRequestDetails];
}

- (void)performHouseKeepingTasks
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = @"Loading";
}

- (void)fetchPullRequestDetails
{
    NSURL *commentsUrl = [NSURL URLWithString:[self.pullRequest getCommentsUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:commentsUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:commentsUrl.absoluteString parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSArray *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

         for (int i=0; i < json.count; i++) {
             [self.comments addObject:[[Comment alloc] initWithData:[json objectAtIndex:i]]];
         }

         [self displayPullRequestDetails];
         [self.hud hide:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [self.hud hide:YES];
     }];

    [operation start];
}

- (void)displayPullRequestDetails
{
    self.navigationItem.title = [self.pullRequest getTitle];
    NSString *commentHtmlString = @"";

    User *owner = [self.pullRequest getOwner], *user;
    Comment *comment;

    for (int i=0; i < self.comments.count; i++) {
        comment = [self.comments objectAtIndex:i];
        user = [comment getUser];
        commentHtmlString = [commentHtmlString stringByAppendingFormat:@"<tr><td><img src='%@' class='avatar pull-left' /><div class='comment-details'><b>%@</b><p>%@</p></div></td></tr>", [user getAvatarUrl], [user getLogin], [comment getBody]];
    }

    NSString *pullRequestDetailsPath = [[NSBundle mainBundle] pathForResource:@"pull_request" ofType:@"html"];
    NSString *pullRequestDetails = [NSString stringWithContentsOfFile:pullRequestDetailsPath encoding:NSUTF8StringEncoding error:nil];
    NSString *contentHtml = [NSString stringWithFormat:pullRequestDetails, [owner getAvatarUrl], [self.pullRequest getState], [owner getLogin], [self.pullRequest getCreatedAt], [self.pullRequest getTitle], [self.pullRequest getBody], commentHtmlString];
    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.pullRequestView loadHTMLString:contentHtml baseURL:baseUrl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
