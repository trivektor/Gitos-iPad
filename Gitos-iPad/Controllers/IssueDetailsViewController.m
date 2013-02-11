//
//  IssueDetailsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "IssueDetailsViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SSKeychain.h"
#import "Comment.h"

@interface UILabel (BPExtensions)

- (void)sizeToFitFixedWith:(CGFloat)fixedWith;

@end


@interface IssueDetailsViewController ()

@end

@implementation IssueDetailsViewController

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
    self.navigationItem.title = [NSString stringWithFormat:@"#%i", [self.issue getNumber]];
    [self performHouseKeepingTasks];
    [self fetchIssueDetails];
}

- (void)performHouseKeepingTasks
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = @"Loading";
}

- (void)fetchIssueDetails
{
    NSURL *commentsUrl = [NSURL URLWithString:[self.issue getCommentsUrl]];
    
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
         
         [self displayIssueDetails];
         [self.hud hide:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [self.hud hide:YES];
     }];
    
    [operation start];

}

- (void)displayIssueDetails
{
    NSString *commentHtmlString = @"";

    Comment *comment;
    User *user;

    for (int i=0; i < self.comments.count; i++) {
        comment = [self.comments objectAtIndex:i];
        user = [comment getUser];
        commentHtmlString = [commentHtmlString stringByAppendingFormat:@"<tr><td><img src='%@' class='avatar' /><div class='comment-details'><b>%@</b><p>%@</p></div></td></tr>", [user getAvatarUrl], [user getLogin], [comment getBody]];
    }
    
    NSString *issueDetailsPath = [[NSBundle mainBundle] pathForResource:@"issue_details" ofType:@"html"];
    NSString *issueDetails = [NSString stringWithContentsOfFile:issueDetailsPath encoding:NSUTF8StringEncoding error:nil];
    NSString *contentHtml = [NSString stringWithFormat:issueDetails, [user getAvatarUrl], [self.issue getTitle], [self.issue getBody], commentHtmlString];
    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.detailsView loadHTMLString:contentHtml baseURL:baseUrl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

@end
