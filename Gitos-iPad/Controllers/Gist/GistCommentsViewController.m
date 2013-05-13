//
//  GistCommentsViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 5/12/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "GistCommentsViewController.h"
#import "GistComment.h"

@interface GistCommentsViewController ()

@end

@implementation GistCommentsViewController

@synthesize gist, commentsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self registerEvents];
    [gist fetchComments];
}

- (void)registerEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayComments:)
                                                 name:@"GistCommentsFetched"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = @"Comments";
}

- (void)displayComments:(NSNotification *)notification
{
    NSMutableArray *comments = (NSMutableArray *) notification.object;

    NSString *commentHtmlString = @"";

    for (int i=0; i < comments.count; i++) {
        GistComment *comment = [comments objectAtIndex:i];
        User *user = [comment getUser];
        commentHtmlString = [commentHtmlString stringByAppendingFormat:@"<tr><td><img src='%@' class='avatar pull-left' /><div class='comment-details'><b>%@</b><p>%@</p></div></td></tr>", [user getAvatarUrl], [user getLogin], [comment getBody]];
    }

    NSString *gistCommentsPath = [[NSBundle mainBundle] pathForResource:@"gist_comments" ofType:@"html"];
    NSString *gistComments = [NSString stringWithContentsOfFile:gistCommentsPath encoding:NSUTF8StringEncoding error:nil];
    NSString *contentHtml = [NSString stringWithFormat:gistComments, commentHtmlString];
    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [commentsView loadHTMLString:contentHtml baseURL:baseUrl];
}

@end
