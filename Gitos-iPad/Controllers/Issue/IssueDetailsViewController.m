//
//  IssueDetailsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/10/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "IssueDetailsViewController.h"
#import "Comment.h"

@interface UILabel (BPExtensions)

- (void)sizeToFitFixedWith:(CGFloat)fixedWith;

@end


@interface IssueDetailsViewController ()

@end

@implementation IssueDetailsViewController

@synthesize issue, hud, comments, currentPage, detailsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        comments = [[NSMutableArray alloc] initWithCapacity:0];
        currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = [self.issue getTitle];
    [self performHouseKeepingTasks];
    [self registerEvents];
    [issue fetchCommentsForPage:currentPage++];
}

- (void)performHouseKeepingTasks
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"Loading";
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayComments:)                                                 name:@"IssueCommentsFetched"
                                               object:nil];
}

- (void)displayComments:(NSNotification *)notification
{
    comments = notification.object;

    NSString *commentHtmlString = @"";

    User *owner = [issue getUser], *user;
    Comment *comment;

    for (int i=0; i < comments.count; i++) {
        comment = [comments objectAtIndex:i];
        user = [comment getUser];
        commentHtmlString = [commentHtmlString stringByAppendingFormat:@"<tr><td><img src='%@' class='avatar pull-left' /><div class='comment-details'><b>%@</b><p>%@</p></div></td></tr>", [user getAvatarUrl], [user getLogin], [comment getBody]];
    }
    
    NSString *issueDetailsPath = [[NSBundle mainBundle] pathForResource:@"issue_details" ofType:@"html"];
    NSString *issueDetails = [NSString stringWithContentsOfFile:issueDetailsPath encoding:NSUTF8StringEncoding error:nil];
    NSString *contentHtml = [NSString stringWithFormat:issueDetails, [owner getAvatarUrl], [issue getState], [owner getLogin], [issue getCreatedAt], [issue getTitle], [issue getBody], commentHtmlString];
    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [detailsView loadHTMLString:contentHtml baseURL:baseUrl];

    [hud hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
