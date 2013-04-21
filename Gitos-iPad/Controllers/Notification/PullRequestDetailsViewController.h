//
//  PullRequestDetailsViewController.h
//  Gitos-iPad
//
//  Created by Tri Vuong on 2/24/13.
//  Copyright (c) 2013 Crafted By Tri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRequest.h"

@interface PullRequestDetailsViewController : UIViewController

@property (nonatomic, strong) PullRequest *pullRequest;
@property (nonatomic, weak) IBOutlet UIWebView *pullRequestView;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)performHouseKeepingTasks;
- (void)fetchPullRequestDetails;
- (void)displayPullRequestDetails;

@end
