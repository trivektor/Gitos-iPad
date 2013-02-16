//
//  CommitViewController.m
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/13/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import "CommitViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SSKeychain.h"
#import "CommitFile.h"
#import "User.h"

@interface CommitViewController ()

@end

@implementation CommitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.accessToken = [SSKeychain passwordForService:@"access_token" account:@"gitos"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self performHouseKeepingTasks];
    [self fetchCommitDetails];
}

- (void)performHouseKeepingTasks
{
    self.navigationItem.title = [self.commit getSha];
}

- (void)fetchCommitDetails
{
    NSURL *commitsUrl = [NSURL URLWithString:[self.commit getUrl]];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:commitsUrl];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.accessToken, @"access_token",
                                   nil];

    NSMutableURLRequest *getRequest = [httpClient requestWithMethod:@"GET" path:commitsUrl.absoluteString parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:getRequest];

    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *response = [operation responseString];

         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
         self.commit = [[Commit alloc] initWithData:json];
         [self displayCommitDetails];
         [self.hud hide:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
         [self.hud hide:YES];
     }];

    [operation start];
}

- (void)displayCommitDetails
{
    NSString *commitHtmlString = @"";
    NSArray *files = [self.commit getFiles];
    User *author = [self.commit getAuthor];

    NSString *commitMessageString = [NSString stringWithFormat:@" \
    <tr id='commit-overview'> \
        <td> \
            <h4>%@</h4> \
            <p> \
                <img src='%@' class='avatar pull-left' /> \
                authored %@ \
            </p> \
        </td> \
    </tr>",
    [self.commit getMessage],
    [author getAvatarUrl],
    [self.commit getCommittedAt]];

    commitMessageString = [commitMessageString stringByAppendingFormat:@" \
    <tr> \
        <td>Showing %i changed %@</td> \
    </tr>",
    [files count],
    [files count] > 1 ? @"files" : @"file"];

    NSString *markupString = @" \
    <tr> \
        <td> \
            <div class='clearfix'> \
                <b class='pull-left'>%@</b> \
                <span class='pull-right commit-stats'> \
                    <b>%@</b> \
                    <label class='label label-success'>%@</label> \
                    <label class='label label-important'>%@</label> \
                </span> \
            </div> \
            <pre><code>%@</code></pre> \
        </td> \
    </tr>";

    for (int i=0; i < files.count; i++) {
        CommitFile *file = [[CommitFile alloc] initWithData:[files objectAtIndex:i]];
        NSInteger additions = [file getAdditions], deletions = [file getDeletions];

        commitHtmlString = [commitHtmlString stringByAppendingFormat:markupString,
            [file getFileName],
            [NSString stringWithFormat:@"%i", (additions + deletions)],
            [NSString stringWithFormat:@"%i %@", additions, additions > 1 ? @"additions" : @"addition"],
            [NSString stringWithFormat:@"%i %@", deletions, deletions > 1 ? @"deletions" : @"deletion"],
            [self encodeHtmlEntities:[file getPatch]]];
    }

    NSString *commitDetailsPath = [[NSBundle mainBundle] pathForResource:@"commit_details" ofType:@"html"];
    NSString *commitDetails = [NSString stringWithContentsOfFile:commitDetailsPath encoding:NSUTF8StringEncoding error:nil];
    NSString *contentHtml = [NSString stringWithFormat:commitDetails, commitMessageString, commitHtmlString];
    NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.commitView loadHTMLString:contentHtml baseURL:baseUrl];
}

- (NSString *)encodeHtmlEntities:(NSString *)rawHtmlString
{
    return [[rawHtmlString
      stringByReplacingOccurrencesOfString: @">" withString: @"&#62;"]
     stringByReplacingOccurrencesOfString: @"<" withString: @"&#60;"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
